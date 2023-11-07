//
//  TaskViewController.swift
//  UserAccounts
//
//  Created by Shafiur Rahman Bhuiyan on 10/24/23.

import UIKit
import CoreData

var webInfo: [String] = []
var selectedWebsite: String?

class TaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    // updating and showing the table data of current user
    @IBOutlet weak var tblItems: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return webInfo.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showWebsiteDetail", sender: self)
    }
    
    
    // this populates the table with new cell element that I created in the webInfo
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        var content = cell.defaultContentConfiguration()
        content.text = webInfo[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        webInfo = []
        var data = [WebsiteInfo]()
        
        do{
            data = try context.fetch(WebsiteInfo.fetchRequest())
            for particularWebsite in data {
                // checking if its the right user
                if particularWebsite.activeUser == activeuser
                {
                    webInfo.append(particularWebsite.websiteName!)
                }
            }
        }
        catch{
            
        }
        tblItems.reloadData()
    }
    
    
    
    // deleting items from the table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        var data = [WebsiteInfo]()
        
        if editingStyle == UITableViewCell.EditingStyle.delete{
            do{
                data = try context.fetch(WebsiteInfo.fetchRequest())
                for existingTask in data {
                    if existingTask.activeUser == activeuser
                    {
                        if existingTask.websiteName == webInfo[indexPath.row]
                        {
                            context.delete(existingTask)
                        }
                    }
                }
            }
            catch{
            }
        }
        appDelegate.saveContext()
        webInfo.remove(at: indexPath.row)
        tblItems.reloadData()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebsiteDetail"{
            if let indexPath = tblItems.indexPathForSelectedRow
            {
                if let infoViewController = segue.destination as? ShowWebinfo
                {
                    let selectedWebsiteName = webInfo[indexPath.row]
                    infoViewController.selectedWebsiteName = selectedWebsiteName
                }
            }
        }
    }
}

