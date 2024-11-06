//
//  SignUpViewController.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//


import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces

class SignUpViewController: UIViewController {

    @IBOutlet var mLastname: UITextField!
    @IBOutlet var mNameTitle: UITextField!
    @IBOutlet var mTnCBTN: UIButton!
    @IBOutlet var mCountryPicker: UITextField!
    @IBOutlet var mUIVie: UIView!
    //MARK:- OUTLETS
    @IBOutlet var mPassV: UIView!
    @IBOutlet var mCPAssV: UIView!
    @IBOutlet weak var mDrivingLicenceTXTFLD: UITextField!
    @IBOutlet weak var mExpirydateTF: UITextField!
    @IBOutlet weak var mIssueDateTF: UITextField!
    @IBOutlet weak var name_txtField: UITextField!
    @IBOutlet weak var emailAddress_txtField: UITextField!
    @IBOutlet weak var password_txtField: UITextField!
    @IBOutlet weak var confirmPass_txtField: UITextField!
    @IBOutlet weak var mobileNo_txtField: UITextField!
  //  @IBOutlet weak var SSNo_txtField: UITextField!
//    @IBOutlet weak var dOBTF: UITextField!
//    
//    @IBOutlet var homeAddress: UITextField!
    //  @IBOutlet weak var homeAddress: UITextView!
    @IBOutlet weak var signUp_btn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var identificationProofImageView: UIImageView!
    
    //MARK:- Variables
    
    let conn = webservices()
    var profileImg : UIImage?
    var identificationProofImg : UIImage?
    var datePicker = UIDatePicker()
    var datePicker2 = UIDatePicker()
    var document_Data = [RidesData]()
    var pickerView1 = UIPickerView()
   
    var selectedservice: String?
    var DOBdatePicker = UIDatePicker()
    var counPicker = CountryPicker()
    var pickerviewNAme = UIPickerView()
    var nametitleArr = ["Mr.","Ms.","Boss"]
    
    var selectedID = String()
    enum imagePic {
        case imageProfile
        case imageIdentificationProof
    }
    var imagePickStatus =  imagePic.imageProfile
    lazy var imagePicker :ImagePickerViewControler  = {
        return ImagePickerViewControler()
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        getdataApi()
        mUIVie.fadeIn()
        mobileNo_txtField.delegate = self
        mCountryPicker.inputView = counPicker
        self.counPicker.countryPickerDelegate = self
        self.counPicker.showPhoneNumbers = true
        pickerView1.delegate = self
        pickerviewNAme.delegate = self
        self.signUp_btn.layer.cornerRadius = 5
        setui()
        //  homeAddress.delegate = self
        mDrivingLicenceTXTFLD.delegate = self
        mDrivingLicenceTXTFLD.inputView = pickerView1
        mNameTitle.inputView = pickerviewNAme
        mIssueDateTF.delegate = self
        mExpirydateTF.delegate = self
        //        dOBTF.delegate = self
        
      //  updateAppVersionPopup()
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
            let alertController = UIAlertController(title: "New Version Available", message: "Please update to the latest version of the app.", preferredStyle: .alert)
       // https://apps.apple.com/in/app/rider-ridesharerates/id6476266125
            let updateAction = UIAlertAction(title: "Update", style: .cancel) { (_) in
                guard let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/rider-ridesharerates/id6476266125") else {
                    return
                }
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
            
            alertController.addAction(updateAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            
            // Present the alert controller
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true

    }
    func setui(){
        name_txtField.setLeftPaddingPoints(82)
        emailAddress_txtField.setLeftPaddingPoints(42)
        password_txtField.setLeftPaddingPoints(42)
        confirmPass_txtField.setLeftPaddingPoints(42)
        mobileNo_txtField.setLeftPaddingPoints(92)
        mLastname.setLeftPaddingPoints(42)
        mLastname.layer.borderWidth = 1
        mLastname.layer.borderColor = #colorLiteral(red: 1, green: 0.9715370536, blue: 0.65270257, alpha: 1)
        name_txtField.layer.borderWidth = 1
        name_txtField.layer.borderColor = #colorLiteral(red: 1, green: 0.9715370536, blue: 0.65270257, alpha: 1)
        emailAddress_txtField.layer.borderWidth = 1
        emailAddress_txtField.layer.borderColor = #colorLiteral(red: 1, green: 0.9715370536, blue: 0.65270257, alpha: 1)
        mobileNo_txtField.layer.borderWidth = 1
        mobileNo_txtField.layer.borderColor = #colorLiteral(red: 1, green: 0.9715370536, blue: 0.65270257, alpha: 1)
        mPassV.layer.borderWidth = 1
        mPassV.layer.borderColor = #colorLiteral(red: 1, green: 0.9715370536, blue: 0.65270257, alpha: 1)
        mCPAssV.layer.borderWidth = 1
        mCPAssV.layer.borderColor = #colorLiteral(red: 1, green: 0.9715370536, blue: 0.65270257, alpha: 1)
        
        //  homeAddress.setLeftPaddingPoints(35)
        //        dOBTF.setLeftPaddingPoints(42)
                mDrivingLicenceTXTFLD.setLeftPaddingPoints(42)
                mExpirydateTF.setLeftPaddingPoints(42)
                mIssueDateTF.setLeftPaddingPoints(42)
        //        dOBTF.layer.borderWidth = 1
        //        dOBTF.layer.borderColor = #colorLiteral(red: 1, green: 0.9715370536, blue: 0.65270257, alpha: 1)
                mDrivingLicenceTXTFLD.layer.borderWidth = 1
                mDrivingLicenceTXTFLD.layer.borderColor = #colorLiteral(red: 1, green: 0.9715370536, blue: 0.65270257, alpha: 1)
                mExpirydateTF.layer.borderWidth = 1
                mExpirydateTF.layer.borderColor = #colorLiteral(red: 1, green: 0.9715370536, blue: 0.65270257, alpha: 1)
                mIssueDateTF.layer.borderWidth = 1
                mIssueDateTF.layer.borderColor = #colorLiteral(red: 1, green: 0.9715370536, blue: 0.65270257, alpha: 1)
        
        
        //        homeAddress.layer.borderWidth = 1
        //        homeAddress.layer.borderColor = #colorLiteral(red: 1, green: 0.9715370536, blue: 0.65270257, alpha: 1)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .default
        }
    }
    func showDatePicker(){
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker2.preferredDatePickerStyle = .wheels
            DOBdatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        DOBdatePicker.datePickerMode = .date
        DOBdatePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        DOBdatePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -83, to: Date())

//        dOBTF.inputView = DOBdatePicker
//        
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        mIssueDateTF.inputView = datePicker
        
        datePicker2.datePickerMode = .date
        datePicker2.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        mExpirydateTF.inputView = datePicker2
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:- User Defined Func
    @IBAction func dateOfBirthBtn(_ sender: Any) {
        print("press")
    }
    
      @objc
      func cancelAction() {
        //  self.dOBTF.resignFirstResponder()
      }

    
    //MARK:- Button Action
    @IBAction func back_btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tapEyePassword_btn(_ sender: UIButton) {
        password_txtField.isSecureTextEntry.toggle()
         if password_txtField.isSecureTextEntry {
             if let image = UIImage(systemName: "eye.slash.fill") {
                 sender.setImage(image, for: .normal)
             }
         }else{
             if let image = UIImage(systemName: "eye.fill") {
                 sender.setImage(image, for: .normal)
             }
         }
    }
    
    @IBAction func tapEyeConfirmPassword_btn(_ sender: UIButton) {
        confirmPass_txtField.isSecureTextEntry.toggle()
         if confirmPass_txtField.isSecureTextEntry {
             if let image = UIImage(systemName: "eye.slash.fill") {
                 sender.setImage(image, for: .normal)
             }
         } else {
             if let image = UIImage(systemName: "eye.fill") {
                 sender.setImage(image, for: .normal)
             }
         }
    }
    @IBAction func profilePicBtnAction(){
        imagePickStatus = .imageProfile
//        self.imagePicker.imagePickerDelegete = self
//        self.imagePicker.showImagePicker(viewController: self)
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

//        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
//            self.openGallery()
//        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func identificationProofBtnAction(){
        imagePickStatus = .imageIdentificationProof
//        self.imagePicker.imagePickerDelegete = self
//        self.imagePicker.showImagePicker(viewController: self)
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

//        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
//            self.openGallery()
//        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    //MARK:- open camera
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
  //  MARK:- open gallery
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func tapSignUp_btn(_ sender: Any) {
        
        if self.name_txtField.text == ""{
            self.showAlert("Rider RideshareRates", message: "Please enter first name")
        }else if self.mLastname.text == ""{
            self.showAlert("Rider RideshareRates", message: "Please enter last name")
        }else if self.emailAddress_txtField.text == ""{
            self.showAlert("Rider RideshareRates", message: "Please enter email address")
        }else if !(Validation().isValidEmail(self.emailAddress_txtField.text!)){
            self.showAlert("Rider RideshareRates", message: "Please enter valid email address")
        }else if self.password_txtField.text == "" {
            self.showAlert("Rider RideshareRates", message: "Please enter password")
        }else if (self.password_txtField.text?.count ?? 0) < 6{
            self.showAlert("Rider RideshareRates", message: "Please enter six charcter password")
        }else if self.confirmPass_txtField.text == "" {
            self.showAlert("Rider RideshareRates", message: "Please enter confirm password")
        }else if !(self.password_txtField.text == self.confirmPass_txtField.text){
            self.showAlert("Rider RideshareRates", message: "Password and confirm password does not match")
        }else  if self.mCountryPicker.text == ""{
            self.showAlert("Rider RideshareRates", message: "Please select country code")
        }else if self.mobileNo_txtField.text == ""{
            self.showAlert("Rider RideshareRates", message: "Please enter mobile number")
        }else if self.mobileNo_txtField.text!.count < 14{
            self.showAlert("Rider RideshareRates", message: "Please enter correct mobile number")
        }else if self.profileImg == nil{
            self.showAlert("Rider RideshareRates", message: "Please select profile pic")
        }else if self.mDrivingLicenceTXTFLD.text == ""{
            self.showAlert("Rider RideshareRates", message: "Please select identity")
        }else if self.mIssueDateTF.text == ""{
            self.showAlert("Rider RideshareRates", message: "Please enter issue date")
        }else if self.mExpirydateTF.text == ""{
            self.showAlert("Rider RideshareRates", message: "Please enter expiry date")
        }else if self.identificationProofImg == nil{
            self.showAlert("Rider RideshareRates", message: "Please select identification proof pic")
        }else if mTnCBTN.currentImage == UIImage(systemName: "square") {
            self.showAlert("Rider RideshareRates", message: "Please read and accept Terms&Conditions by click on checkbox.")
        }else{
           // signup()
            self.uploadPhotoGallaryNewSignup(media: self.profileImg!, mediaLicense: self.identificationProofImg!)
        }
    }
    
    func uploadPhotoGallaryNewSignup(media: UIImage ,mediaLicense: UIImage ){
        
        let params = ["email":self.emailAddress_txtField.text!,"name_title":self.mNameTitle.text!, "name":self.name_txtField.text!,"last_name":self.mLastname.text!, "country_code": mCountryPicker.text ?? "" , "mobile": self.mobileNo_txtField.text!,"password":self.password_txtField.text!,"utype":1,"country":"","city":"","state":"","latitude":kCurrentLocaLat,"longitude":kCurrentLocaLong , "gcm_token" :  NSUSERDEFAULT.value(forKey: kFcmToken) as? String ?? "","identification_document_id" : selectedID,"identification_issue_date" : mIssueDateTF.text ?? "","identification_expiry_date": mExpirydateTF.text ?? ""] as [String : Any]
        print(params)
        let imageData = media.jpegData(compressionQuality: 0.25)
        let imageDataLicence = mediaLicense.jpegData(compressionQuality: 0.25)
        print("image data\(String(describing: imageData))")
        let url = URL(string: "\(baseURL)register")!
//        let headers: HTTPHeaders = [
//           // "Content-type": "multipart/form-data",
//            "Accept": "application/json",
//            "authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as? String ?? "")"
//        ]
        Indicator.shared.showProgressView(self.view)
        AF.upload(multipartFormData: { multipartFormData in
            if imageData != nil{
                multipartFormData.append(imageData!,
                                         withName: "avatar" , fileName: "avatar.jpg", mimeType: "image/jpeg"
                )
            }
            if imageDataLicence != nil{
                multipartFormData.append(imageDataLicence!,
                                         withName: "verification_id" , fileName: "verification_id.jpg", mimeType: "image/jpeg"
                )
            }
            for p in params {
                multipartFormData.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
                print("KEY VALUE DATA===========\(p.key)"=="-----+++++----\(p.value)")
            }
        }, to: url)
        .responseJSON { response in
           print("URL AND HEADERS==========\(url)")
            print(response)
            Indicator.shared.hideProgressView()
            switch (response.result) {
            case .success(let JSON):
                print("JSON: \(JSON)")
                let responseString = JSON as! NSDictionary
                print(responseString)
                let msg = responseString["message"] as? String ?? ""
                if ((responseString["status"] as? Int ?? 0) == 1){
                    
                    let token = (responseString["token"] as? String ?? "")
                    let data = (responseString["data"] as? [String:Any] ?? [:])
                    let card1 = (data["is_card"] as? Int ?? 0)
                    let addCard = (data["add_card"] as? Int ?? 0)

                    print(data)
                    UserDefaults.standard.setValue(token, forKey: "token")
                    self.showAlertWithAction(Title: "Rider RideshareRates", Message: msg, ButtonTitle: "OK") {
                        self.navigationController?.popViewController(animated: false)
//                        if addCard == 1 &&  card1 == 1{
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
//                        else{
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupPaymentVC") as! SignupPaymentVC
//                            self.navigationController?.pushViewController(vc, animated: true)
//
//                        }
                    }
                }else{
                    
                    self.showAlert("Rider RideshareRates", message: msg)
                }
                break;
            case .failure(let error):
                print(error)
                self.showAlert("Rider RideshareRates", message: "\(error.localizedDescription)")
                break
            }
        }
    }
    func signup(){
       
        let params = ["email":self.emailAddress_txtField.text!, "name":self.name_txtField.text!, "country_code": mCountryPicker.text ?? "" , "mobile": self.mobileNo_txtField.text!,"password":self.password_txtField.text!,"utype":1,"country":"","city":"","state":"","latitude":kCurrentLocaLat,"longitude":kCurrentLocaLong , "gcm_token" :  NSUSERDEFAULT.value(forKey: kFcmToken) as? String ?? ""] as [String : Any]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "register", params: params, outputBlock: { (value) in
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
                    let card1 = (data["is_card"] as? Int ?? 0)
                    let addCard = (data["add_card"] as? Int ?? 0)

                    print(data)
                    UserDefaults.standard.setValue(token, forKey: "token")
                    self.showAlertWithAction(Title: "Rider RideshareRates", Message: msg, ButtonTitle: "OK") {
                        self.navigationController?.popViewController(animated: false)
                    }
               
                }else{
                    self.showAlert("Rider RideshareRates", message: msg)
                }
            }
        })
    }
    @IBAction func tapSignIn_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
   // MARK:- getdocumentidentity data
    
    func getdataApi() {
       // Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "get_documentidentity_get",authRequired: false) { (value) in
            print("Profile Data Api  \(value)")
           // Indicator.shared.hideProgressView()
            let msg = (value["message"] as? String ?? "")
            if self.conn.responseCode == 1{
            //  let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    self.document_Data = try newJSONDecoder().decode(rides.self, from: jsonData)
                    print(self.document_Data)
                    
                    self.selectedservice = self.document_Data[0].document_name!
                    self.selectedID = self.document_Data[0].id!
                   // self.pendingReq_tableView.reloadData()
                }catch{
                    print(error.localizedDescription)
                }
            }else{
                guard let stat = value["Error"] as? String, stat == "ok" else {
                   
                    return
                }
            }
        }
    }
    
    @IBAction func mCheckBTN(_ sender: Any) {
        if mTnCBTN.currentImage == UIImage(systemName: "square"){
            mTnCBTN.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
         }else{
             mTnCBTN.setImage(UIImage(systemName: "square"), for: .normal)
         }
    }
    
    @IBAction func mTCBTN(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(identifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        vc.screen = "signup"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension SignUpViewController: CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        print("Place placeID: \(String(describing: place.placeID))")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place address: \(String(describing: place.addressComponents))")
        
     //   homeAddress.textColor = UIColor.black
      //  homeAddress.text = place.formattedAddress
        dismiss(animated: true, completion: nil)
    }
}
extension SignUpViewController : UITextFieldDelegate{


//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
////        if textView == homeAddress{
////            let autocompleteController = GMSAutocompleteViewController()
////            autocompleteController.delegate = self
////            present(autocompleteController, animated: true, completion: nil)
////            return
////        }
//
//        if homeAddress.textColor == UIColor.lightGray {
//            let autocompleteController = GMSAutocompleteViewController()
//            autocompleteController.delegate = self
//            present(autocompleteController, animated: true, completion: nil)
//
//            homeAddress.text = ""
//            homeAddress.textColor = UIColor.black
//        }
//    }
//    private func textFieldDidEndEditing(_ textField: UITextField) {
//        if homeAddress.text!.isEmpty {
//            homeAddress.text = "Home Address"
//            homeAddress.textColor = UIColor.lightGray
//        }
//    }
}
//MARK:- picker

extension SignUpViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of session
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerviewNAme{
            return nametitleArr.count
        }else{
            return document_Data.count // number of dropdown items
        }
       
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerviewNAme{
            return nametitleArr[row]
        }else{
            return document_Data[row].document_name! // dropdown item
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerviewNAme{
            mNameTitle.text = nametitleArr[row]
        }else{
            selectedservice = document_Data[row].document_name!
            selectedID = document_Data[row].id!
        }
       // mDrivingLicenceTXTFLD.text = document_Data[row].document_name!
    //    IDselected = searchModel[row].id!
    }
}


//MARK:- Web Api
extension SignUpViewController{
    // MARK:- signup api 
//    func registerApi(){
//
//        let param = ["email":self.emailAddress_txtField.text!,"name":self.name_txtField.text!,"mobile":self.mobileNo_txtField.text!,"password":self.password_txtField.text!,"utype":1,"country":"India","city":"Noida","state":"U.P","latitude":0.0,"longitude":0.0 , "gcm_token" :  NSUSERDEFAULT.value(forKey: kFcmToken) as? String ?? ""] as [String : Any]
//        Indicator.shared.showProgressView(self.view)
//        self.conn.startConnectionWithPostType(getUrlString: "register", params: param) { (value) in
//
//            Indicator.shared.hideProgressView()
//            if self.conn.responseCode == 1{
//
//                print(value)
//                let msg = (value["message"] as? String ?? "")
//
//                if ((value["status"] as? Int ?? 0) == 1){
//
//                    let token = (value["token"] as? String ?? "")
//                    let data = (value["data"] as? [String:Any] ?? [:])
//                    let card1 = (data["is_card"] as? Int ?? 0)
//                    let addCard = (data["add_card"] as? Int ?? 0)
//
//                    print(data)
//                    UserDefaults.standard.setValue(token, forKey: "token")
//                    self.showAlertWithAction(Title: "Rider RideshareRates", Message: msg, ButtonTitle: "OK") {
//
////                        if addCard == 1 &&  card1 == 0{
////                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
////                            self.navigationController?.pushViewController(vc, animated: true)
////                        }
////                        else{
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                            self.navigationController?.pushViewController(vc, animated: true)
////
//  //                      }
//                    }
//                }else{
//
//                    self.showAlert("Rider RideshareRates", message: msg)
//                }
//
//            }
//        }
//    }
    
//    func uploadPhotoGallaryNewSignup(media: UIImage ,mediaLicense: UIImage ){
//        
//        let params = ["email":self.emailAddress_txtField.text!, "name":self.name_txtField.text!, "country_code": mCountryPicker.text ?? "" , "mobile": self.mobileNo_txtField.text!,"password":self.password_txtField.text!,"utype":1,"country":"","city":"","state":"","latitude":kCurrentLocaLat,"longitude":kCurrentLocaLong , "gcm_token" :  NSUSERDEFAULT.value(forKey: kFcmToken) as? String ?? ""] as [String : Any]
//        print(params)
//        let imageData = media.jpegData(compressionQuality: 0.25)
//        let imageDataLicence = mediaLicense.jpegData(compressionQuality: 0.25)
//        print("image data\(String(describing: imageData))")
//        let url = URL(string: "\(baseURL)register")!
//        Indicator.shared.showProgressView(self.view)
////        AF.upload(multipartFormData: { multipartFormData in
////            if imageData != nil{
////                multipartFormData.append(imageData!,
////                                         withName: "avatar" , fileName: "avatar.jpg", mimeType: "image/jpeg"
////                )
////            }
////            if imageDataLicence != nil{
////                multipartFormData.append(imageDataLicence!,
////                                         withName: "verification_id" , fileName: "verification_id.jpg", mimeType: "image/jpeg"
////                )
////            }
////            for p in params {
////                multipartFormData.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
////                print("KEY VALUE DATA===========\(p.key)"=="-----+++++----\(p.value)")
////            }
////        }, to: url)
//        .responseJSON { response in
//           print("URL AND HEADERS==========\(url)")
//            print(response)
//            Indicator.shared.hideProgressView()
//            switch (response.result) {
//            case .success(let JSON):
//                print("JSON: \(JSON)")
//                let responseString = JSON as! NSDictionary
//                print(responseString)
//                let msg = responseString["message"] as? String ?? ""
//                if ((responseString["status"] as? Int ?? 0) == 1){
//                    
//                    let token = (responseString["token"] as? String ?? "")
//                    let data = (responseString["data"] as? [String:Any] ?? [:])
//                    let card1 = (data["is_card"] as? Int ?? 0)
//                    let addCard = (data["add_card"] as? Int ?? 0)
//
//                    print(data)
//                    UserDefaults.standard.setValue(token, forKey: "token")
//                    self.showAlertWithAction(Title: "Rider RideshareRates", Message: msg, ButtonTitle: "OK") {
//                        self.navigationController?.popViewController(animated: false)
//                    }
//                }else{
//                    
//                    self.showAlert("Rider RideshareRates", message: msg)
//                }
//                break;
//            case .failure(let error):
//                print(error)
//                self.showAlert("Rider RideshareRates", message: "\(error.localizedDescription)")
//                break
//            }
//        }
//    }
}

extension SignUpViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("calling")
           
            if imagePickStatus == .imageProfile {
                profileImageView.image = pickedImage
                self.profileImg = pickedImage
            }
            if imagePickStatus == .imageIdentificationProof{
                identificationProofImageView.image = pickedImage
                self.identificationProofImg = pickedImage
                
            }
          
        }
        picker.dismiss(animated: true, completion: nil)
    }
  
}
extension UITextField {
    func datePicker<T>(target: T,
                       doneAction: Selector,
                       cancelAction: Selector,
                       datePickerMode: UIDatePicker.Mode = .date) {
        let screenWidth = UIScreen.main.bounds.width
        
        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()
            
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                target: buttonTarget,
                                                action: action)
            
            return barButtonItem
        }
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: screenWidth,
                                                    height: 216))
        datePicker.datePickerMode = datePickerMode
        self.inputView = datePicker
        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: screenWidth,
                                              height: 44))
        toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                          buttonItem(withSystemItemStyle: .flexibleSpace),
                          buttonItem(withSystemItemStyle: .done)],
                         animated: true)
        self.inputAccessoryView = toolBar
    }
}
extension SignUpViewController{

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
//        if textField == homeAddress{
//          
//            let autocompleteController = GMSAutocompleteViewController()
//            autocompleteController.delegate = self
//            autocompleteController.primaryTextColor = UIColor.lightGray
//            autocompleteController.primaryTextHighlightColor = UIColor.white
//            autocompleteController.secondaryTextColor = UIColor.white
//            autocompleteController.tableCellSeparatorColor = UIColor.lightGray
//            autocompleteController.tableCellBackgroundColor = UIColor.lightBlackThemeColor()
//            
//            let searchBarTextAttributes: [NSAttributedString.Key : AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white, NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont.systemFont(ofSize: UIFont.systemFontSize)]
//            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
//            
//            
//            present(autocompleteController, animated: true, completion: nil)
//         
////            homeAddress.text = ""
////            homeAddress.textColor = UIColor.black
//        }else 
        if textField == mIssueDateTF{
            showDatePicker()
           
        }else if textField == mExpirydateTF{
            showDatePicker()
          //  mEndDateTXTFLD.text = ""
//        }else if textField == dOBTF{
//            showDatePicker()
//          
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        if textField == mIssueDateTF {
            let selectedDate = datePicker.date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.mIssueDateTF.text = formatter.string(from: selectedDate)
        }else if textField == mExpirydateTF {
            let selectedDate = datePicker2.date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.mExpirydateTF.text = formatter.string(from: selectedDate)
//        }else if textField == dOBTF {
//            let selectedDate = DOBdatePicker.date
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            self.dOBTF.text = formatter.string(from: selectedDate)
        }else if textField == mDrivingLicenceTXTFLD{
            if selectedservice == nil{
                if document_Data.count != 0{
                    selectedservice = document_Data[0].document_name!
                  //  IDselected = searchModel.first?.id! as! String
                    mDrivingLicenceTXTFLD.text = selectedservice
                }
            }else{
                mDrivingLicenceTXTFLD.text = selectedservice
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileNo_txtField{
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            mobileNo_txtField.text = format(with: "(XXX) XXX-XXXX", phone: newString)
            return false
        }
        else{
            return true
        }
    }
//    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}
public extension UIView {

/**
 Fade in a view with a duration
 
 - parameter duration: custom animation duration
 */
 func fadeIn(duration: TimeInterval = 1.0) {
     UIView.animate(withDuration: duration, animations: {
        self.alpha = 1.0
     })
 }

/**
 Fade out a view with a duration
 
 - parameter duration: custom animation duration
 */
func fadeOut(duration: TimeInterval = 1.0) {
    UIView.animate(withDuration: duration, animations: {
        self.alpha = 0.0
    })
  }

}
extension SignUpViewController : CountryPickerDelegate{
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        //pick up anythink
        self.mCountryPicker.text = phoneCode
    }
}
