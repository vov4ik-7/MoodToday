//
//  ViewController.swift
//  MoodToday
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var viewBG: UIImageView!
    @IBOutlet var swipeGesture: UISwipeGestureRecognizer!
    @IBOutlet var menuTableView: UITableView!
    
    @IBOutlet var imageView: UIImageView!
    let screen = UIScreen.main.bounds
    var menu = false
    var home = CGAffineTransform()
    var options: [option] = [option(title: "Камера", segue: "CameraSegue"),
                             option(title: "Cтатистика", segue: "StatisticSegue"),
                             option(title: "Про нас", segue: "AboutUsSegue"),
                             option(title: "Контакти", segue: "ContactsSegue"),
                            ]
    
    struct option {
        var title = String()
        var segue = String()
    }

    @IBAction func testBtnClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "res") as! ImageResultViewController
        vc.image = nil
        self.present(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let face = UIImage.gifImageWithName("face")
        // imageView.image = face
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.backgroundColor = .clear
        
        home = self.containerView.transform
    }
    
    
    @IBAction func ConectButton(_ sender: UIButton) {
        // Check if the device can send emails
               guard MFMailComposeViewController.canSendMail() else {
                   // Handle the case where the device cannot send emails
                   print("Device cannot send emails.")
                   return
               }
               
               // Create an instance of MFMailComposeViewController
               let mailComposeViewController = MFMailComposeViewController()
               mailComposeViewController.mailComposeDelegate = self
               mailComposeViewController.setToRecipients(["recipient@example.com"])
               mailComposeViewController.setSubject("Hello")
               mailComposeViewController.setMessageBody("This is the body of the email.", isHTML: false)
               
               // Present the email address window
               self.present(mailComposeViewController, animated: true, completion: nil)
        
    }
    
    // Implement the MFMailComposeViewControllerDelegate method to handle the result of the email composition
       func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
           // Dismiss the email address window
           controller.dismiss(animated: true, completion: nil)
       }
    
    
    
    @IBAction func CameraButton(_ sender: UIButton) {
    // Instantiate the desired view controller using storyboard identifier
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
        let newViewController = storyboard.instantiateViewController(withIdentifier: "ViewControllerCamera")
        
        // Present the new view controller
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    
    func showMenu() {
        
        self.containerView.layer.cornerRadius = 40
        self.viewBG.layer.cornerRadius = self.containerView.layer.cornerRadius
        let x = screen.width * 0.8
        let originalTransform = self.containerView.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.8, y: 0.8)
            let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: x, y: 0)
            UIView.animate(withDuration: 0.7, animations: {
                self.containerView.transform = scaledAndTranslatedTransform
                
            })
        
    }
    
    func hideMenu() {
        
            UIView.animate(withDuration: 0.7, animations: {
                
                self.containerView.transform = self.home
                self.containerView.layer.cornerRadius = 0
                self.viewBG.layer.cornerRadius = 0
                
            })
        
    }
    
    
    
    @IBAction func showMenu(_ sender: UISwipeGestureRecognizer) {
        
        print("menu interaction")
        
        if menu == false && swipeGesture.direction == .right {
            
            print("user is showing menu")
            
            showMenu()
            
            menu = true
            
        }
        
    }
    
    
    
    @IBAction func hideMenu(_ sender: Any) {
        
        if menu == true {
            
            print("user is hiding menu")
            
            hideMenu()
            
            menu = false
            
        }
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return options.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! tableViewCell
        cell.descriptionLabel.text = options[indexPath.row].title
        cell.descriptionLabel.textColor = #colorLiteral(red: 0.6461477876, green: 0.6871469617, blue: 0.6214019656, alpha: 1)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let indexPath = tableView.indexPathForSelectedRow {

            let currentCell = (tableView.cellForRow(at: indexPath) ?? UITableViewCell()) as UITableViewCell
            
            // optional: animate the button when tapped
            
            currentCell.alpha = 0.5
            UIView.animate(withDuration: 1, animations: {
                currentCell.alpha = 1
            })
            
            // optional: perform a segue when tapped
            
            // self.parent?.performSegue(withIdentifier: options[indexPath.row].segue, sender: self)
            
        }
        
        let sequeIdentifier: String
        switch indexPath.row{
        case 0:
            sequeIdentifier = "CameraSegue"
        case 1:
            sequeIdentifier = "StatisticSegue"
        case 2:
            sequeIdentifier = "AboutUsSegue"
        case 3:
            sequeIdentifier = "ContactsSegue"
        default:
            sequeIdentifier = "non"
        }
        self.performSegue(withIdentifier: sequeIdentifier, sender: self)
    }
}


class tableViewCell: UITableViewCell {
    
    @IBOutlet var descriptionLabel: UILabel!
    
}
