//
//  SendOTPViewController.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit

class SendOTPViewController: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var registeredMail_txtField: SetTextField!
    //MARK:- Variables
    var conn = webservices()
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
     //   NotificationCenter.default.addObserver(self, selector: #selector(dismissSelf), name: .dismissForget, object: nil)
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.dismiss(animated: true, completion: nil)
//    }
    //MARK:- User Defined Func
//    @objc func dismissSelf(){
//        self.dismiss(animated: true, completion: nil)
//    }
    //MARK:- Button Action
    @IBAction func tapSendOTP_btn(_ sender: Any) {
        if self.registeredMail_txtField.text == ""{
            self.showAlert("Driver RideshareRates", message: "Please enter registered email")
        }else if !(Validation().isValidEmail(self.registeredMail_txtField.text!)){
            self.showAlert("Driver RideshareRates", message: "Please enter valid email address")
        }else{
            self.sendOTPApi()
        }
    }
    @IBAction func tapCancel_btn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
//MARK:- Web Api
extension SendOTPViewController{
    //MARK:- resend otp api
    func sendOTPApi(){
        Indicator.shared.showProgressView(self.view)
        let param = ["email":self.registeredMail_txtField.text!]
        self.conn.startConnectionWithPostType(getUrlString: "resend", params: param) { (value) in
            print(value)
            let msg = (value["message"] as? String ?? "")
            Indicator.shared.hideProgressView()
            if ((value["status"] as? Int ?? 0) == 1){
                self.showAlertWithAction(Title: "Driver RideshareRates", Message: msg, ButtonTitle: "OK") {
                    let vc = self.storyboard?.instantiateViewController(identifier: "ResetPasswordViewController") as! ResetPasswordViewController
                    vc.modalPresentationStyle = .overFullScreen
                    let transition = CATransition()
                    transition.duration = 0.5
                    transition.type = CATransitionType.fade
                    transition.subtype = CATransitionSubtype.fromTop
                    self.view.window!.layer.add(transition, forKey: kCATransition)
                    self.present(vc, animated: true, completion: nil)
                }
            }else{
                
                self.showAlert("Driver RideshareRates", message: msg)
            }
        }
    }
}
extension Notification.Name{
    static let dismissForget = Notification.Name("dismissForget")
}
