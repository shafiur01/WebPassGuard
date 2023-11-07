//
//  ViewController.swift
//  UserAccounts
//
//  Created by Shafiur Rahman Bhuiyan on 10/17/23.
//

import UIKit
import CoreData
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

var activeuser : String?

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageOutlet.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var messageOutlet: UILabel!
    
    @IBAction func btnSignIn(_ sender: Any) {
        
        var data = [Accounts]()

        do {
            data = try context.fetch(Accounts.fetchRequest())

            for existingAccount in data {
                if(existingAccount.username! == txtUsername.text && existingAccount.password! == txtPassword.text) {
                    activeuser = txtUsername.text
                    print("Valid Login")
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let vc: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "TBCTasks") as UIViewController
                    self.present(vc, animated: true, completion: nil)
                    return
                }
            }
        } catch {
            // Handle the error appropriately
            print("An error occurred while fetching accounts")
        }

        // If the function has not returned by this point, authentication has failed.
        print("No! Invalid Authentication")
        displayErrorMessage()
    }

    func displayErrorMessage() {
        // Ensure the message outlet is visible and show the error message.
        messageOutlet.isHidden = false
        messageOutlet.alpha = 1.0
        messageOutlet.text = "Invalid username or password."

        // After 3 seconds, fade the message away.
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 1.0, animations: {
                self.messageOutlet.alpha = 0
            }) { completed in
                if completed {
                    self.messageOutlet.isHidden = true
                }
            }
        }
    }
        
        
        
        
        
//        var data = [Accounts]()
//
//        do{
//            data = try context.fetch(Accounts.fetchRequest())
//
//            for existingAccount in data{
//                if(existingAccount.username! == txtUsername.text && existingAccount.password! == txtPassword.text)
//                {
//                    activeuser = txtUsername.text
//                    print("Valid Login")
//                    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//                    let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "TBCTasks") as UIViewController
//                    self.present(vc, animated: true, completion: nil)
//                  return
//                }
//            }
//        }
//      catch
//
//    {}
//    print("No! Invalid Authentication")
//    messageOutlet.isHidden = false
//    }
}


