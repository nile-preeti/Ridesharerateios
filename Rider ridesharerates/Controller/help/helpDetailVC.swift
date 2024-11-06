//
//  helpDetailVC.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//

import UIKit

class helpDetailVC: UIViewController {

    @IBOutlet weak var mContactnoBTN: UIButton!
    @IBOutlet weak var mEmailBTN: UIButton!
    @IBOutlet weak var mHelpTitleLBL: UILabel!
    @IBOutlet weak var mDetailTF: UITextView!
    let conn = webservices()

    var email = ""
    var HelpTitle = ""
    var question_id = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        mDetailTF.contentInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        mHelpTitleLBL.text = HelpTitle
        mDetailTF.delegate = self
        mDetailTF.text = "Write Short Description"
        mDetailTF.textColor = UIColor.lightGray
        mDetailTF.delegate = self
        mEmailBTN.setTitle(email, for: .normal)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "green")
        self.navigationController?.navigationBar.backgroundColor = .black

        self.setNavButton()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "Help"
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    // Mark : set nav bar button
    func setNavButton(){
        
        let logoBtn = UIButton(type: .custom)
        logoBtn.setImage(UIImage(named: "leftArrowWhite"), for: .normal)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = .black

        
        logoBtn.addTarget(self, action: #selector(tapNavButton), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: logoBtn)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func tapNavButton(){
        self.navigationController?.popViewController(animated: true)
//        let presentedVC = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController")
//        let nvc = UINavigationController(rootViewController: presentedVC)
//        present(nvc, animated: false, pushing: true, completion: nil)
    }
    @IBAction func mEmailBTN(_ sender: Any) {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "Email", style: .default) { action -> Void in
            
            print("First Action pressed")
            let email = self.email
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
            let email = self.email
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
    @IBAction func mCAllBTN(_ sender: Any) {
        let url: NSURL = URL(string: "TEL://802-375-5793")! as NSURL
           UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        
//      //  let number = mContactnoBTN.currentTitle as! String
//        if let url = URL(string: "tel:// 802-375-5793"),
//          UIApplication.shared.canOpenURL(url) {
//             if #available(iOS 10, *) {
//               UIApplication.shared.open(url, options: [:], completionHandler:nil)
//              } else {
//                  UIApplication.shared.openURL(url)
//              }
//          } else {
//                   // add error message here
//          }
      
        
    }
    @IBAction func mSubmitBTN(_ sender: Any) {
        if mDetailTF.text == "Write Short Description" || mDetailTF.text == ""{
            self.showAlert("Rider RideshareRates", message: "Please enter description to submit")
        }else{
            helpPOST()
        }
    }
}

extension helpDetailVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        
        if mDetailTF.textColor == UIColor.lightGray {
           
            mDetailTF.text = ""
            mDetailTF.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if mDetailTF.text.isEmpty {
            mDetailTF.text = "Write Short Description"
            mDetailTF.textColor = UIColor.lightGray
        }
    }
}

//MARK:- Web Api
extension helpDetailVC{
    //MARK:- save answer api 
    func helpPOST() {
        let param = ["question_id":self.question_id,"answer":self.mDetailTF.text!, "ride_id": kRideId] as [String : Any]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "save_answer", params: param,authRequired: true) { (value) in
            //   print(value)
            let msg = (value["message"] as? String ?? "")
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                if (value["status"] as? Int ?? 0) == 1{
                   // self.navigationController?.popViewController(animated: true)
                    self.showAlert("Rider RideshareRates", message: "Your answer has been saved successfully")
                }
                else{
                    self.showAlert("Rider RideshareRates", message: msg)
                }
            }
            else{
                print("No Ride Available")
                guard var stat = value["Error"] as? String, stat == "ok" else {
                    return
                }
            }
        }
    }
    
}
