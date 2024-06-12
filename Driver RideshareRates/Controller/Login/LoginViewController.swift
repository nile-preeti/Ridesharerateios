//
//  LoginViewController.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit
import Alamofire
class LoginViewController: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var email_txtField: UITextField!
    @IBOutlet weak var password_txtField: UITextField!
    
    //MARK:- Variables
    let conn = webservices()
  //  var profileDetails : ProfileData?
    var customerData : userCustomerModal?

    override func viewDidLoad() {
        super.viewDidLoad()
        email_txtField.setLeftPaddingPoints(20)
        password_txtField.setLeftPaddingPoints(20)

        self.navigationController?.isNavigationBarHidden = true
        //   email_txtField.text = "testernile6@gmail.com"
        //    password_txtField.text = "abc@123"
        
        //   email_txtField.text = "saurabh.chaubey@niletechnologies.com"
        //   password_txtField.text = "pass@123"
        
        //        email_txtField.text = "ajaydd@gmail.com"
        //        password_txtField.text = "fsdfsdf"
        // email_txtField.text = "user@gmail.com"
        //   password_txtField.text = "test@123"
        //    email_txtField.text = "Testernile9@gmail.com"
        //    password_txtField.text = "abc@123"
        //  email_txtField.text = "userajay@gmail.com"
        // password_txtField.text = "test@123"
        //
        //      email_txtField.text = "mondaydriver@gmail.com"
        //     password_txtField.text = "abc@123"
     //   updateAppVersionPopup()
    }
    
    // MARK: Check AppVersion
      func updateAppVersionPopup() {
        guard let appStoreURL = URL(string: "http://itunes.apple.com/lookup?bundleId=com.driverchime.app") else {
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
            guard let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/driver-ridesharerates/id6462469475") else {
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
    
    //MARK:- Button Action
    @IBAction func tapForgetPass_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "SendOTPViewController") as! SendOTPViewController
        vc.modalPresentationStyle = .overFullScreen
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromTop
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func tapSignUp_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tapLogin_btn(_ sender: Any) {
        
      
        
        if self.email_txtField.text == ""{
            self.showAlert("Driver RideshareRates", message: "Please enter email address")
        }else if !(Validation().isValidEmail(self.email_txtField.text!)){
            self.showAlert("Driver RideshareRates", message: "Please enter valid email address")
        }else if self.password_txtField.text == ""{
            self.showAlert("Driver RideshareRates", message: "Please enter password")
        }else {
            self.loginApi()
        }
    }
}
//MARK:- Web Api
extension LoginViewController{
    //MARK:- login api
   
    func loginApi(){
        var deviceID =  UIDevice.current.identifierForVendor?.uuidString
        print(deviceID)
        let gcm_token = AppDelegate.fcmToken
        NSUSERDEFAULT.set(gcm_token, forKey: kFcmToken)
        let param = ["email":self.email_txtField.text!,"password":self.password_txtField.text!,"device_token": deviceID ?? "", "device_type": "ios", "utype":2 , "gcm_token" : NSUSERDEFAULT.value(forKey: kFcmToken) as? String ?? ""] as [String : Any]
        print(param)
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "login", params: param) { (value) in
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
                    NSUSERDEFAULT.setValue(gcm, forKey: kDeviceToken)
                    NSUSERDEFAULT.set(token, forKey: accessToken)
                    NSUSERDEFAULT.set(userId, forKey: kUserID)
                    NSUSERDEFAULT.setValue(self.password_txtField.text!, forKey: kPassword)
                    NSUSERDEFAULT.set(true, forKey: kUserLogin)
                    UserDefaults.standard.synchronize()
                   self.getDocexpiry()
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.showAlert("Driver RideshareRates", message: msg)
                }
            }
        }
    }
    //MARK:- check expiry document api 
    func getDocexpiry() {
        Indicator.shared.showProgressView(self.view)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? ""),
            "Content-type": "multipart/form-data"]
        
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "get_check_document_expiry",authRequired: true) { (value) in
            // print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print("Getting Profile Data Api  \(value)")
                let msg = (value["license_expiry"] as? Bool ?? true)
                if value["license_expiry"] as? Bool == false || value["insurance_expiry"] as? Bool == false || value["identification_expiry"] as? Bool == false || value["inspection_expiry"] as? Bool == false{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "welcomeVCID") as! welcomeVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                print("")
//                if (value["status"] as? Int ?? 0) == 1{
//                    var data = (value["data"] as? [String:Bool] ?? [:])
//                    do{
////                        let response = try? JSONDecoder().decode([String: Bool].self, from: data)
////                        if response?["license_expiry"] == true {
//
//                        let jsondata = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
//                        let encodedJson = try JSONDecoder().decode(userCustomerModal.self, from: jsondata)
//                        self.customerData = encodedJson
//
//                        if self.customerData?.license_expiry == true{
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewControllerID") as! HomeViewController
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }else{
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "welcomeVCID") as! welcomeVC
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
//                      //  self.servicesList.reloadData()
//                    }catch{
//                        print(error.localizedDescription)
//                    }
//                }
//                else{
//                    guard let stat = value["Error"] as? String, stat == "ok" else {
//                        // self.showToast(message: "\(String(describing: stat))")
//                        return
//                    }
//                }
            }
        }
    }
}
