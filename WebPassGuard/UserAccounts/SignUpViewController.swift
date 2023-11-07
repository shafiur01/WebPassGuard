//
//  SignUpViewController.swift
//  UserAccounts
//
//  Created by Shafiur Rahman Bhuiyan on 11/3/23.
//

import UIKit

class SignUpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showWarningMessage.isHidden = true
    }
    
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtRetypePassword: UITextField!
    
    
    @IBOutlet weak var showWarningMessage: UILabel!
    
    
    
    @IBOutlet weak var ouletShowGeneratedPassword: UILabel!
    
    @IBAction func funcGeneratePassword(_ sender: Any) {
        ouletShowGeneratedPassword.text! = generateStrongPassword()
    }
    
    func generateStrongPassword() -> String {
        let minimumPasswordLength = 8
        let maximumPasswordLength = 12
        let passwordLength = Int.random(in: minimumPasswordLength...maximumPasswordLength)
        let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*(),.<>{}[]"
        let charactersArray = Array(charactersString)
        
        var password = ""
        
        // Ensure that the password contains at least one character from each set
        let lowerCase = Array("abcdefghijklmnopqrstuvwxyz")
        let upperCase = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let numbers = Array("1234567890")
        let specialCharacters = Array("!@#$%^&*(),.<>{}[]")
        
        password.append(contentsOf: [lowerCase.randomElement(), upperCase.randomElement(), numbers.randomElement(), specialCharacters.randomElement()].compactMap { $0 })
        
        // Fill the rest of the password length with random characters
        while password.count < passwordLength {
            password.append(charactersArray.randomElement()!)
        }
        
        // Shuffle the password to distribute the character types
        password = String(password.shuffled())
        
        return password
    }
    
    
    @IBAction func CopyGeneratedPassword(_ sender: Any) {
        // Ensuring that the label contains text and it is not empty
        if let passwordToCopy = ouletShowGeneratedPassword.text, !passwordToCopy.isEmpty {
            UIPasteboard.general.string = passwordToCopy
            // Notifing the user that the password has been copied.
            (sender as AnyObject).setTitle("Copied!", for: .normal)
            
            // Optionally, reverting the button title back to its original state after a delay.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                (sender as AnyObject).setTitle("Copy Password", for: .normal)
            }
        } else {
            // When there's no password present, it will prompt the user to generate a password first.
            print("No password to copy")
        }
        
    }
    
    // this is how we save new data in the CoreData DB
    func addNewAccount(newAccountUsername: String, newAccountPassword: String){
        // the Accounts is coming from the core data
        
        let newAccount = Accounts(context: context)
        
        newAccount.username = newAccountUsername
        newAccount.password = newAccountPassword
        
        
        appDelegate.saveContext()
        
    }
    
    @IBAction func btnAddUser(_ sender: Any) {
        if let username = txtUsername.text, !username.isEmpty {
                if let password = txtPassword.text, isPasswordStrong(password) {
                    if let retypedPassword = txtRetypePassword.text, retypedPassword == password {
                        addNewAccount(newAccountUsername: username, newAccountPassword: password)
                        // After adding the new account, navigate to ViewController
                        navigateToViewController()
                    } else {
                        showMessage(message: "Retyped password does not match.")
                    }
                } else {
                    showMessage(message: "Password does not meet the requirements.")
                }
            } else {
                showMessage(message: "Username cannot be empty.")
            }
        }

        func navigateToViewController() {
            

            // Or if you want to present the ViewController not in a navigation stack:
            
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                self.present(viewController, animated: true, completion: nil)
            }

        }
    
    func showMessage(message: String) {
        showWarningMessage.text = message
        showWarningMessage.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showWarningMessage.isHidden = true
        }
    }
    
    // Helper function to check password strength
    func isPasswordStrong(_ password: String) -> Bool {
        let passwordLength = 8...12
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasDigit = password.range(of: "\\d", options: .regularExpression) != nil
        let hasSpecialCharacter = password.range(of: "[!@#$%^&*(),.?\":{}|<>]", options: .regularExpression) != nil
        
        return passwordLength.contains(password.count) && hasUppercase && hasLowercase && hasDigit && hasSpecialCharacter
    }
}
