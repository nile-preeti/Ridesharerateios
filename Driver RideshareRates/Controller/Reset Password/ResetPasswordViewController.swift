//
//  ResetPasswordViewController.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit

class ResetPasswordViewController: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var registeredEmail_txtField: SetTextField!
    @IBOutlet weak var enterOTP_txtField: SetTextField!
    @IBOutlet weak var newPass_txtField: SetTextField!
    @IBOutlet weak var cnfPass_txtField: SetTextField!
    
    //MARK:- Variables
    let conn = webservices()
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapResetPass_btn(_ sender: Any) {
        if self.registeredEmail_txtField.text == ""{
            self.showAlert("Driver RideshareRates", message: "Please enter registered email")
        }else if !(Validation().isValidEmail(self.registeredEmail_txtField.text!)){
            self.showAlert("Driver RideshareRates", message: "Please enter valid email id")
        }else if self.enterOTP_txtField.text == ""{
            self.showAlert("Driver RideshareRates", message: "Please enter OTP")
        }else if self.newPass_txtField.text == ""{
            self.showAlert("Driver RideshareRates", message: "Please enter new password")
        }else if ((self.newPass_txtField.text!.count) < 6){
            self.showAlert("Driver RideshareRates", message: "Please enter six character password")
        }else if self.cnfPass_txtField.text == ""{
            self.showAlert("Driver RideshareRates", message: "Please enter confirm password")
        }else if !(self.newPass_txtField.text! == self.cnfPass_txtField.text!){
            self.showAlert("Driver RideshareRates", message: "Please enter same password in new password and confirm password")
        }else{
            self.resetPassApi()
        }
    }
    @IBAction func tapCancel_btn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
//MARK:- Web Api
extension ResetPasswordViewController{
    //MARK:-  reset pass api 
    func resetPassApi(){
        let param = ["email":self.registeredEmail_txtField.text!,"otp":self.enterOTP_txtField.text!,"password":self.newPass_txtField.text!]
        print(param)
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "forgot-password", params: param) { (value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                let msg = (value["message"] as? String ?? "")
                if (value["status"] as? Int ?? 0) == 1{
                    self.showAlertWithAction(Title: "Driver RideshareRates", Message: msg, ButtonTitle: "Ok") {
                        self.dismiss(animated: true, completion: nil)
                        NotificationCenter.default.post(name: .dismissForget, object: nil)
                    }
                }else{
                    self.showAlert("Driver RideshareRates", message: msg)
                }
            }
        }
    }
}
