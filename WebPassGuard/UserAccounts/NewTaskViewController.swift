//
//  NewTaskViewController.swift
//  UserAccounts
//
//  Created by Shafiur Rahman Bhuiyan on 10/24/23.
//

import UIKit
var count = Int32(1)

class NewTaskViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBOutlet weak var txtItem: UITextField!
    
    
    @IBAction func btnAddItem(_ sender: Any) {
        
        if txtItem.text != nil && txtItem.text != "" {
            
            let newTask = Task(context: context)
            
            newTask.userName = activeuser
            newTask.taskName = txtItem.text!
            newTask.taskID = count
            count = count + 1
            
            appDelegate.saveContext()
            txtItem.text = ""
            
            // this line helps to take us to the next view controller where we insert our data for the website
            navigateToMywebinfo()
        }
    }
    
    private func navigateToMywebinfo() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mywebinfoVC = storyboard.instantiateViewController(withIdentifier: "MywebinfoID") as? Mywebinfo {
            self.navigationController?.pushViewController(mywebinfoVC, animated: true)
        }
        
    }
}






//    private func navigateToMywebinfo() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let mywebinfoVC = storyboard.instantiateViewController(withIdentifier: "MywebinfoID") as? Mywebinfo {
//            print("Mywebinfo VC instantiated, attempting to push")
//            if let navigationController = self.navigationController {
//                navigationController.pushViewController(mywebinfoVC, animated: true)
//            } else {
//                print("Navigation controller is nil")
//            }
//        } else {
//            print("Failed to instantiate Mywebinfo VC")
//        }
//    }
