//
//  ChangePasswordViewController.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit

class ChangePasswordViewController: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var oldPass_txtField: SetTextField!
    @IBOutlet weak var newPass_txtField: SetTextField!
    @IBOutlet weak var cnfPass_txtField: SetTextField!
    
    //MARK:- Variables
    
    let conn = webservices()
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backBTN(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }
    @IBAction func tapChangePass_btn(_ sender: Any) {
        
        let oldPass = NSUSERDEFAULT.value(forKey: kPassword) ?? ""
        if self.oldPass_txtField.text == ""{
            self.showAlert("Driver RideshareRates", message: "Please enter old password")
        }
        else if self.oldPass_txtField.text !=  oldPass as? String {
            self.showAlert("Driver RideshareRates", message: "Old password is wrong")
        }
        else if self.newPass_txtField.text == ""{
            self.showAlert("Driver RideshareRates", message: "Please enter new password")
        }else if ((self.newPass_txtField.text!.count) < 6){
            self.showAlert("Driver RideshareRates", message: "Please enter six character password")
        }else if self.cnfPass_txtField.text == ""{
            self.showAlert("Driver RideshareRates", message: "Please enter confirm password")
        }else if !(self.newPass_txtField.text! == self.cnfPass_txtField.text!){
            self.showAlert("Driver RideshareRates", message: "Please enter same password in new password and confirm password")
        }else{
            self.changePassApi()
        }
    }
}
//MARK:- Web Api
extension ChangePasswordViewController{
    //MARK:-  change pass api 
    func changePassApi(){
        let param = ["new_password":self.newPass_txtField.text!,"confirm_password":self.cnfPass_txtField.text!]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "change_password", params: param,authRequired: true) { (Value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                let msg = (Value["message"] as? String ?? "")
                if (Value["status"] as? Int ?? 0) == 1{
                    print(Value)
                    NSUSERDEFAULT.removeObject(forKey: kPassword)
                    NSUSERDEFAULT.setValue(self.newPass_txtField.text!, forKey: kPassword)
                    self.showAlertWithAction(Title: "Driver RideshareRates", Message: msg, ButtonTitle: "OK") {
                        self.dismiss(animated: true, completion: nil)
                    }
                }else{
                    self.showAlert("Driver RideshareRates", message: msg)
                }
            }
        }
    }
}
