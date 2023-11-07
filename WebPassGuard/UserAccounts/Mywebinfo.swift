//
//  Mywebinfo.swift
//  UserAccounts
//
//  Created by Shafiur Rahman Bhuiyan on 10/31/23.
//

import UIKit
import CoreData
var activeUser: String?


class Mywebinfo: UIViewController {
    
    @IBOutlet weak var websiteName: UITextField!
    
    
    @IBOutlet weak var webUrl: UITextField!
    
    @IBOutlet weak var webUserName: UITextField!
    
    
    @IBOutlet weak var webPassword: UITextField!
    
    // Dependency Injection for context
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch the context from AppDelegate or use dependency injection to provide it.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        websiteName.text = ""
        webUrl.text = ""
        webUserName.text = ""
        webPassword.text = ""
    }
    
    @IBAction func BtnAddAction(_ sender: Any) {
        guard let websiteNameText = websiteName.text, !websiteNameText.isEmpty,
              let url = webUrl.text, !url.isEmpty,
              let username = webUserName.text, !username.isEmpty,
              let password = webPassword.text, !password.isEmpty
        else {
            showAlert(message: "Please fill in all fields.")
            return
        }
        
        let newWebsiteInfo = WebsiteInfo(context: context)
        newWebsiteInfo.activeUser = activeuser
        newWebsiteInfo.websiteName = websiteNameText
        newWebsiteInfo.url = url
        newWebsiteInfo.username = username
        newWebsiteInfo.password = password
        
        do {
            try context.save()
        } catch {
            showAlert(message: "Failed to save the website info: \(error.localizedDescription)")
            return
        }
        self.tabBarController?.selectedIndex = 0
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    @IBAction func btnWebNameTableView(_ sender: UIButton) {
        
        self.tabBarController?.selectedIndex = 0
    }
    
}
