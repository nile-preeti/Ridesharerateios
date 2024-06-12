//
//  BankDetailVC.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit
import Alamofire
class BankDetailVC: UIViewController {
    let conn = webservices()
    @IBOutlet var mSubmitBTN: SetButton!
    @IBOutlet weak var bankName: UITextField!
    @IBOutlet weak var accountHolderName: UITextField!
    @IBOutlet weak var accountHolderNo: UITextField!
    @IBOutlet weak var routingNo: UITextField!
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    var isEdit = false
    var profileDetails : ProfileData?
    override func viewDidLoad() {
        super.viewDidLoad()
      //  accountHolderNo.delegate = self
        self.setTxtFieldRadius()
        self.setNavButton()
        self.getBankDetailsApi()
     //   self.setData()
   }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Bank Detail"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
    }
    func setNavButton(){
        let logoBtn = UIButton(type: .custom)
        logoBtn.setImage(UIImage(named: "shape_28"), for: .normal)
    
        logoBtn.addTarget(self, action: #selector(tapNavButton), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: logoBtn)
        self.navigationItem.leftBarButtonItem = barButton
    }
    @objc func tapNavButton(){
        let presentedVC = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController")
        let nvc = UINavigationController(rootViewController: presentedVC)
        present(nvc, animated: false, pushing: true, completion: nil)
    }
    func setTxtField(textField:UITextField){
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: "green")?.cgColor
    }
    func setTxtFieldRadius(){
        self.setTxtField(textField: self.bankName)
        self.setTxtField(textField: self.accountHolderName)
        self.setTxtField(textField: self.accountHolderNo)
        self.setTxtField(textField: self.routingNo)
        
    }
    
   
    
    func getBankDetailsApi() {
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "getBankDetails",authRequired: true) { (value) in
            print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                
                print(value)
                if (value["status"] as? Int ?? 0) == 1{
                    let data = (value["data"] as? [String:AnyObject] ?? [:])
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        self.profileDetails = try newJSONDecoder().decode(ProfileData.self, from: jsonData)
//                        kProfileName =    self.profileDetails?.name ?? ""
//                        kProfileMobile = self.profileDetails?.mobile ?? ""
                        self.setData()
                        
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func setData(){
        self.bankName.text = "Republic Bank & Trust"
        self.accountHolderName.text = self.profileDetails?.account_holder_name ?? ""
        self.accountHolderNo.text = self.profileDetails?.account_number ?? ""
        self.routingNo.text = "264171241"
//        if self.bankName.text != ""{
//            mSubmitBTN.setTitle("Update", for: .normal)
//        }
        bankName.isUserInteractionEnabled = false
        accountHolderName.isUserInteractionEnabled  = true
        accountHolderNo.isUserInteractionEnabled  = false
        routingNo.isUserInteractionEnabled  = false

    }
    
    //MARK:- Button Action
    @IBAction func tapSave_btn(_ sender: Any){
//        if isEdit == false {
//            self.showAlert(Singleton.shared!.title, message: "Please add correct card details")
//        }
//        else{
            self.validationsCheck()
    //    }
    }
    @IBAction func tapEdit_btn(_ sender: Any){
        bankName.isUserInteractionEnabled = true
        accountHolderName.isUserInteractionEnabled = true
        accountHolderNo.isUserInteractionEnabled = true
        routingNo.isUserInteractionEnabled = true
        self.isEdit = true
    }
}

extension BankDetailVC {
    //MARK:- OTHER FUNCTIONS
    func validationsCheck(){
        if self.bankName.text == ""{
            self.showAlert(Singleton.shared!.title, message: "Enter bank Name")
        }else if self.accountHolderName.text == ""{
            self.showAlert(Singleton.shared!.title, message: "Enter account Holder Name")
        }
//        else if self.accountHolderNo.text == ""{
//            self.showAlert(Singleton.shared!.title, message: "Enter account number")
//        }
        else if self.routingNo.text == ""{
            self.showAlert(Singleton.shared!.title, message: "Enter Rounting No")
        }
       else{
        self.bankDetailApi(accountHolderName: self.accountHolderName.text ?? "", bankName: self.bankName.text ?? "", routingNumber: self.routingNo.text ?? "", accountNumber: self.accountHolderNo.text ?? "")
        }
    }
    func bankDetailApi(accountHolderName:String ,bankName:String,routingNumber:String,accountNumber:String){
        let param : [String : Any] = ["account_holder_name": accountHolderName,"bank_name": bankName ,"routing_number": routingNumber ,"account_number": accountNumber ] as [String : Any]
        print(param)
        Indicator.shared.showProgressView(self.view)
                 self.conn.startConnectionWithPostType(getUrlString: "add_account", params: param ,authRequired: true) { (value) in
                     Indicator.shared.hideProgressView()
                    let msg = (value["message"] as? String ?? "")
                    if (value["status"] as? Int ?? 0) == 1{
                        print(value)
                        let data = (value["data"] as? [String:AnyObject] ?? [:])
                        print(data)
                        NSUSERDEFAULT.setValue(data["account_holder_name"] as? String ?? "", forKey: kAccountHolderName)
                        NSUSERDEFAULT.setValue(data["account_number"] as? String ?? "", forKey: kAccountNumber)
                        NSUSERDEFAULT.setValue(data["bank_name"] as? String ?? "", forKey: kBankName)
                        NSUSERDEFAULT.setValue(data["routing_number"] as? String ?? "", forKey: kRoutingNumber)
                        print(kAccountHolderName)
                        self.isEdit = false
                        self.showAlert("Driver RideshareRates", message: msg)
                        
                    }
                     else{
                         guard let stat = value["Error"] as? String, stat == "ok" else {
                             return
                         }
                     }
                 }
//        let url = URL.init(string: urlString)
//        var headers: HTTPHeaders = [:]
//        headers = ["Authorization" : "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? "")
//        ]
//        print(headers)
//        AF.request(urlString, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
//            .responseString { response in
//                print("responseString: \(response)")
//                Indicator.shared.hideProgressView()
//                switch (response.result) {
//                case .success(let JSON):
//                    print("JSON: \(JSON)")
//                    break;
//                case .failure(let error):
//                    print(error)
//                    break
//                }
//            }
    }
}

// MARK:--------TEXTFIELD DELEGATE-----------

//extension BankDetailVC : UITextFieldDelegate{
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == accountHolderNo {
//                  return formatCardNumber(textField: textField, shouldChangeCharactersInRange: range, replacementString: string)
//              }
//              return true
//    }
//    func formatCardNumber(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//          if textField == accountHolderNo {
//              let replacementStringIsLegal = string.rangeOfCharacter(from: NSCharacterSet(charactersIn: "0123456789").inverted) == nil
//
//              if !replacementStringIsLegal {
//                  return false
//              }
//
//              let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//              let components = newString.components(separatedBy: NSCharacterSet(charactersIn: "0123456789").inverted)
//              let decimalString = components.joined(separator: "") as NSString
//              let length = decimalString.length
//              let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
//
//              if length == 0 || (length > 16 && !hasLeadingOne) || length > 19 {
//                  let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
//
//                  return (newLength > 16) ? false : true
//              }
//              var index = 0 as Int
//              let formattedString = NSMutableString()
//
//              if hasLeadingOne {
//                  formattedString.append("1 ")
//                  index += 1
//              }
//              if length - index > 4 {
//                  let prefix = decimalString.substring(with: NSRange(location: index, length: 4))
//                  formattedString.appendFormat("%@ ", prefix)
//                  index += 4
//              }
//
//              if length - index > 4 {
//                  let prefix = decimalString.substring(with: NSRange(location: index, length: 4))
//                  formattedString.appendFormat("%@ ", prefix)
//                  index += 4
//              }
//              if length - index > 4 {
//                  let prefix = decimalString.substring(with: NSRange(location: index, length: 4))
//                  formattedString.appendFormat("%@ ", prefix)
//                  index += 4
//              }
//
//              let remainder = decimalString.substring(from: index)
//              formattedString.append(remainder)
//              textField.text = formattedString as String
//              return false
//          } else {
//              return true
//          }
//      }
//}
