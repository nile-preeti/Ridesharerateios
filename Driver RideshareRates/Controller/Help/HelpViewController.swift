//
//  HelpViewController.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit

class HelpViewController: UIViewController {

    //MARK:- OUTLETS
    
    @IBOutlet weak var helpView: SetView!
    @IBOutlet weak var contactView: SetView!
    @IBOutlet weak var emailView: SetView!
    
    
    //MARK:- Variables
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
        self.navigationItem.title = "Help"
        self.setNavButton()
        self.helpView.layer.cornerRadius = 5
        self.contactView.layer.cornerRadius = 5
        self.emailView.layer.cornerRadius = 5
    }
    
    //MARK:- User Defined Func
    func setNavButton(){
        let logoBtn = UIButton(type: .custom)
        logoBtn.setImage(UIImage(named: "shape_28"), for: .normal)
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
//        self.navigationController?.navigationBar.standardAppearance = appearance
//        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        logoBtn.addTarget(self, action: #selector(tapNavButton), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: logoBtn)
        self.navigationItem.leftBarButtonItem = barButton
    }
    @objc func tapNavButton(){
        let presentedVC = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController")
        let nvc = UINavigationController(rootViewController: presentedVC)
        present(nvc, animated: false, pushing: true, completion: nil)
    }
    @IBAction func numberBtnAct(_ sender: Any) {
        dialNumber(number: "+1 404.207.5620")

    }
    @IBAction func emailBtnAct(_ sender: Any) {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "Email", style: .default) { action -> Void in
            
            print("First Action pressed")
            let email = "info@ridesharerates.com"
            if let url = URL(string: "mailto:\(email)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }

        let secondAction: UIAlertAction = UIAlertAction(title: "Gmail", style: .default) { action -> Void in

            print("Second Action pressed")
            let email = "info@ridesharerates.com"
            let googleUrlString = "googlegmail://"

            if let googleUrl = URL(string: googleUrlString) {
                UIApplication.shared.open(googleUrl, options: [:]) {
                    success in
                    if !success {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(googleUrl)
                        } else {
                            UIApplication.shared.openURL(googleUrl)
                        }
                    }
                }
            }
            else {
                print("Could not get URL from string")
            }
        }

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }

        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)


        // present an actionSheet...
        // present(actionSheetController, animated: true, completion: nil)   // doesn't work for iPad

        present(actionSheetController, animated: true) {
            print("option menu presented")
        }
        
        

        
    }
    //MARK:-  dial number func
    func dialNumber(number : String) {

     if let url = URL(string: "tel://\(number)"),
       UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
           } else {
               UIApplication.shared.openURL(url)
           }
       } else {
                // add error message here
       }
    }

}
