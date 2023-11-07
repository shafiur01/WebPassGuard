//
//  ShowWebinfo.swift
//  UserAccounts
//
//  Created by Shafiur Rahman Bhuiyan on 11/1/23.
//

import UIKit
import CoreData



class ShowWebinfo: UIViewController {
    
    @IBOutlet weak var lblwebNameView: UILabel!
    
    @IBOutlet weak var lblwebUrlView: UILabel!
    
    @IBOutlet weak var lblwebUsernameView: UILabel!
    
    @IBOutlet weak var lblwebPasswordView: UILabel!
    
    var selectedWebsiteName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var data = [WebsiteInfo]()
        
        do {
            data = try context.fetch(WebsiteInfo.fetchRequest())
            for existingData in data {
                if existingData.websiteName == selectedWebsiteName {
                    updateLabel(label: lblwebNameView, text: existingData.websiteName!, isURL: false)
                    updateLabel(label: lblwebUrlView, text: existingData.url!, isURL: true)
                    updateLabel(label: lblwebUsernameView, text: existingData.username!, isURL: false)
                    updateLabel(label: lblwebPasswordView, text: existingData.password!, isURL: false)
                }
            }
        } catch {
            // Handle the error appropriately
            print(error)
        }
        
        lblwebUrlView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        lblwebUrlView.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func labelTapped() {
        guard let urlString = lblwebUrlView.text else {
            showPopoverMessage(message: "The URL is not valid.")
            return
        }
        
        let formattedURLString = urlString.contains("://") ? urlString : "https://" + urlString
        
        // Check if the URL is of a valid format
        if isValidUrl(urlString: formattedURLString) {
            if let url = URL(string: formattedURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                showPopoverMessage(message: "The URL cannot be opened.")
            }
        } else {
            showPopoverMessage(message: "This is not a valid URL.")
        }
    }
    
    // Checking if the URL is Valid or not
    func isValidUrl(urlString: String) -> Bool {
        let urlRegEx = "^(https?:\\/\\/)?((\\w|-)+)(([.]|[/])((\\w|-)+))+([?].*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        return urlTest.evaluate(with: urlString)
    }
    
    // It it's not a valid URL then it will show an error message as a popover
    func showPopoverMessage(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func updateLabel(label: UILabel, text: String, isURL: Bool) {
        label.textAlignment = .center // Set the text to be in the middle of the label
        
        let fontName = "Noteworthy-Bold" // Attempt to use the bold variant
        let fontSize: CGFloat = 15
        let font = UIFont(name: fontName, size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
        let textColor = isURL ? UIColor.blue : UIColor.black // Set the text color to blue if it's a URL
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        label.attributedText = attributedString
    }
    
    @IBAction func btnGoToWebNameViewConroller(_ sender: Any) {
        
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let ruleForGames = storyboard .instantiateViewController (withIdentifier:
                                                                    "WebNameView" )
        ruleForGames.modalPresentationStyle = .fullScreen
        ruleForGames.modalTransitionStyle = .crossDissolve
    }
    
    
}
