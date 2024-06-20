//
//  LoginViewController.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//


import UIKit

class LoginViewController: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var mPAssView: UIView!
    @IBOutlet weak var emailAddress_txtField: UITextField!
    @IBOutlet weak var password_txtField: UITextField!
    @IBOutlet weak var login_btn: UIButton!
    
    //MARK:- Variables
    let conn = webservices()
    
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
       // FirebaseMessagingManager.shared.registerForRemoteNotifications()
        emailAddress_txtField.layer.borderWidth = 1
        emailAddress_txtField.layer.borderColor = #colorLiteral(red: 1, green: 0.9715370536, blue: 0.65270257, alpha: 1)
        mPAssView.layer.borderWidth = 1
        mPAssView.layer.borderColor = #colorLiteral(red: 1, green: 0.9715370536, blue: 0.65270257, alpha: 1)
        emailAddress_txtField.setLeftPaddingPoints(40)
        password_txtField.setLeftPaddingPoints(40)

        //   self.emailAddress_txtField.text = "jawwad.khan@niletechnologies.com"
        //     self.password_txtField.text = "abc@123"
        self.setView()
        self.navigationController?.isNavigationBarHidden = true
     //   self.emailAddress_txtField.text = "monday@gmail.com"
    //    self.password_txtField.text = "abc@123"
       // updateAppVersionPopup()
    }
    
    // MARK: Check AppVersion
      func updateAppVersionPopup() {
        guard let appStoreURL = URL(string: "http://itunes.apple.com/lookup?bundleId=com.riderRideshare.app") else {
            return
        }
        let task = URLSession.shared.dataTask(with: appStoreURL) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let appStoreVersion = results.first?["version"] as? String,
                   let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
                    
                    if appStoreVersion != currentVersion {
                        DispatchQueue.main.async {
                            self.showUpdatePopup()
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    func showUpdatePopup() {
        
        
        
        
        let refreshAlert = UIAlertController(title: "New Version Available" , message: "Please update to the latest version of the app.", preferredStyle: UIAlertController.Style.alert)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]
        let messageAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.white,
        ]

        let attributedTitle = NSAttributedString(string: "New Version Available", attributes: titleAttributes)
        let attributedMessage = NSAttributedString(string: "Please update to the latest version of the app.", attributes: messageAttributes)

        // Set the attributed title and message
        refreshAlert.setValue(attributedTitle, forKey: "attributedTitle")
        refreshAlert.setValue(attributedMessage, forKey: "attributedMessage")
        refreshAlert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.96)
        
        refreshAlert.addAction(UIAlertAction(title: "UPDATE", style: .cancel, handler: { (action: UIAlertAction!) in
            guard let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/rider-ridesharerates/id6476266125") else {
                return
            }
            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
//            DispatchQueue.main.async {
//                NavigationManager.pushToLoginVC(from: self)
//            }
           // self.DeleteAccount()
          //  self.updateStatus(updateStatus: "3")

        }))
//        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
//        }))
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(refreshAlert, animated: true, completion: nil)
        }
        
        
        
        
        
        
        
//        let alertController = UIAlertController(title: "New Version Available", message: "Please update to the latest version of the app.", preferredStyle: .alert)
//   // https://apps.apple.com/in/app/rider-ridesharerates/id6476266125
//        let updateAction = UIAlertAction(title: "Update", style: .cancel) { (_) in
//            guard let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/rider-ridesharerates/id6476266125") else {
//                return
//            }
//            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
//        }
//
//        alertController.addAction(updateAction)
//
////        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
////        alertController.addAction(cancelAction)
//
//        // Present the alert controller
//        DispatchQueue.main.async {
//            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .default
        }
    }
    //MARK:- Button Action
    @IBAction func tapEyePassword_btn(_ sender: UIButton) {
        password_txtField.isSecureTextEntry.toggle()
         if password_txtField.isSecureTextEntry {
             if let image = UIImage(systemName: "eye.slash.fill") {
                 sender.setImage(image, for: .normal)
             }
         } else {
             if let image = UIImage(systemName: "eye.fill") {
                 sender.setImage(image, for: .normal)
             }
         }
    }
    @IBAction func tapLogin_btn(_ sender: Any) {
        if self.emailAddress_txtField.text == ""{
            self.showAlert("Rider RideshareRates", message: "Please enter email address")
        }else if self.password_txtField.text == ""{
            
            self.showAlert("Rider RideshareRates", message: "Please enter password")
        }else{
            self.loginApi()
        }
    }
    @IBAction func tapSignUp_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        let transition = CATransition()
        transition.duration = 2.0
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController?.view.layer.add(transition, forKey: nil)
   //     self.navigationController?.pushViewController(viewController, animated: false)
        navigationController?.pushViewController(vc, animated: true)
        
        //  self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapForgotPass_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "SendOTPViewController") as! SendOTPViewController
        vc.modalPresentationStyle = .overFullScreen
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromTop
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: true, completion: nil)
    }
    //MARK:- User Defined Func
    func setView(){
        self.login_btn.layer.cornerRadius = 5
    }
}
//MARK:- Web Api
extension LoginViewController{
    // MARK:- login api
    func loginApi(){
        var deviceID =  UIDevice.current.identifierForVendor?.uuidString
        print(deviceID)
       // let gcm_token = AppDelegate.fcmToken
//        NSUSERDEFAULT.setValue(gcm_token, forKey: kFcmToken)
      //  NSUSERDEFAULT.setValue(fcmToken, forKey: kFcmToken)
        let param = ["email":self.emailAddress_txtField.text!,"password":self.password_txtField.text!,"device_token": deviceID ?? "", "device_type": "ios", "utype":1 , "gcm_token" :  AppDelegate.fcmToken as? String ?? ""] as [String : Any]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "login", params: param, outputBlock: { (value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                let msg = (value["message"] as? String ?? "")
                if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: value["data"] as? [String:Any] ?? "", requiringSecureCoding: false) {
                    UserDefaults.standard.set(savedData, forKey: "loginInfo")
                }
                if ((value["status"] as? Int ?? 0) == 1){
                    let token = (value["token"] as? String ?? "")
                    let data = (value["data"] as? [String:Any] ?? [:])
                    let userId = (data["user_id"] as? String ?? "")
                    let gcm = (data["gcm_token"] as? String ?? "")
                    let is_card = (data["is_card"] as? Int ?? 0)
                    let add_card = (data["add_card"] as? Int ?? 0)
                    NSUSERDEFAULT.setValue(gcm, forKey: kDeviceToken)
                    NSUSERDEFAULT.set(token, forKey: accessToken)
                    NSUSERDEFAULT.set(userId, forKey: kUserID)
                    NSUSERDEFAULT.setValue(self.password_txtField.text!, forKey: kPassword)
                    UserDefaults.standard.synchronize()
                    if add_card == 0{
                        NSUSERDEFAULT.set(true, forKey: kUserLogin)
                        self.loginlogoutAPI(statut: "1")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else if is_card == 1 && add_card == 1{
                        self.loginlogoutAPI(statut: "1")
                        NSUSERDEFAULT.set(true, forKey: kUserLogin)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        self.loginlogoutAPI(statut: "2")
                        NSUSERDEFAULT.set(false, forKey: kUserLogin)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupPaymentVC") as! SignupPaymentVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    self.showAlert("Rider RideshareRates", message: msg)
                }
            }
        })
    }
    // MARK:- update login logout status api 
    func loginlogoutAPI(statut: String){
        let param = ["status": statut] as [String : Any]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "updateloginlogout", params: param,authRequired: true) { (value) in
            print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                let msg = (value["status"] as? String ?? "")
                print(msg)
            }
        }
    }
}
