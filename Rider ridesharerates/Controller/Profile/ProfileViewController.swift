//
//  ProfileViewController.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//

import UIKit
import TOCropViewController
import SDWebImage
import Alamofire

class ProfileViewController: UIViewController {
    
    @IBOutlet var mLastName: UITextField!
    @IBOutlet var mNameTitle: UITextField!
    @IBOutlet var mCountryPicker: UITextField!
    //MARK:- OUTLETS
    @IBOutlet weak var mExpirydateTF: UITextField!
    @IBOutlet weak var mIssueDateTF: UITextField!
    @IBOutlet weak var mDocTF: SetTextField!
    @IBOutlet weak var userImg: SetImageView!
    @IBOutlet weak var name_txtField: SetTextField!
    @IBOutlet weak var email_txtField: SetTextField!
    @IBOutlet weak var mobile_txtField: SetTextField!
    @IBOutlet weak var mImgLBL: UILabel!
    @IBOutlet weak var mImg: SetImageView!
    var datePicker = UIDatePicker()
    var datePicker2 = UIDatePicker()
    //MARK:- Variables
    var imageData : Data?
    var imageName : String?
    lazy var imagePicker :ImagePickerViewControler  = {
        
        return ImagePickerViewControler()
        
    }()
    let conn = webservices()
    var profileDetails : ProfileData?
    var img : UIImage?
    var docimg : UIImage?
    var acceptedReqData = [RidesData]()
    var selectedservice: String?
    var pickerView1 = UIPickerView()
    var selectedID = String()
  //  var imagePickStatus =  imagePic.imageProfile
   var imagePick = ""
    var counPicker = CountryPicker()
    var pickerviewNAme = UIPickerView()
    var nametitleArr = ["Mr.","Ms.","Boss"]
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
        name_txtField.setLeftPaddingPoints(75)
        email_txtField.setLeftPaddingPoints(35)
        mobile_txtField.setLeftPaddingPoints(65)
        mIssueDateTF.setLeftPaddingPoints(35)
        mExpirydateTF.setLeftPaddingPoints(35)
        mLastName.setLeftPaddingPoints(35)
        mLastName.layer.borderWidth = 1
        mLastName.layer.borderColor = #colorLiteral(red: 1, green: 0.9715370536, blue: 0.65270257, alpha: 1)
        mCountryPicker.inputView = counPicker
        self.counPicker.countryPickerDelegate = self
        self.counPicker.showPhoneNumbers = true
        mobile_txtField.delegate = self
        mIssueDateTF.delegate = self
        mExpirydateTF.delegate = self
        mDocTF.delegate = self
        mDocTF.inputView = pickerView1
        pickerView1.delegate = self

        pickerviewNAme.delegate = self
        mNameTitle.inputView = pickerviewNAme
        kProfileInputStatus = false
        name_txtField.delegate = self
       // mobile_txtField.delegate = self
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "green")
        self.navigationController?.navigationBar.backgroundColor = .black
        self.setNavButton()
        self.setData()
        userImg.isUserInteractionEnabled = true
        name_txtField.isUserInteractionEnabled = true
        email_txtField.isUserInteractionEnabled = true
        mobile_txtField.isUserInteractionEnabled = true
        getdataApi()
    }
    //MARK:- Date Picker
    func showDatePicker(){
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker2.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
      
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        mIssueDateTF.inputView = datePicker
        
        datePicker2.datePickerMode = .date
        datePicker2.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        mExpirydateTF.inputView = datePicker2
        
    }
    @IBAction func editBtnAction( _ sender : UIButton){
        userImg.isUserInteractionEnabled = true
        name_txtField.isUserInteractionEnabled = true
        email_txtField.isUserInteractionEnabled = true
        mobile_txtField.isUserInteractionEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "Profile"
        self.getProfileDataApi()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    //MARK:- User Defined Func
    func setNavButton(){
        let logoBtn = UIButton(type: .custom)
        logoBtn.setImage(UIImage(named: "shape_28"), for: .normal)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = .black
        logoBtn.addTarget(self, action: #selector(tapNavButton), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: logoBtn)
        self.navigationItem.leftBarButtonItem = barButton
    }
    @objc func tapNavButton(){
        let presentedVC = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController")
        let nvc = UINavigationController(rootViewController: presentedVC)
        present(nvc, animated: false, pushing: true, completion: nil)
    }
    //MARK:- set data from model
    func setData(){
        
        if img != nil{
            self.userImg.image = img
        }else{
            self.userImg.sd_setImage(with:URL(string: (self.profileDetails?.profilePic) ?? ""), placeholderImage: nil, completed: nil)
        }
        if docimg != nil{
            self.mImg.image = docimg
        }else{
            mImg.sd_setImage(with:URL(string: (self.profileDetails?.verification_id) ?? ""), placeholderImage: nil, completed: nil)
        }
       
        self.name_txtField.text = self.profileDetails?.name
        self.mLastName.text = self.profileDetails?.last_name
        self.mNameTitle.text = self.profileDetails?.name_title
        self.email_txtField.text = self.profileDetails?.email
        self.mCountryPicker.text = self.profileDetails?.country_code

        if profileDetails?.identification_document_id != nil{
         //   var se
            selectedID =  (self.profileDetails?.identification_document_id)!
            for i in 0..<acceptedReqData.count{
                if acceptedReqData[i].id == selectedID{
                    mDocTF.text = acceptedReqData[i].document_name!
                    break
                }
            }
         //   mDocTF.text = acceptedReqData[Int(selectedID ?? "")!].document_name!
          
        }
        if profileDetails?.identification_issue_date != nil{
            mIssueDateTF.text = profileDetails?.identification_issue_date
        }
        if profileDetails?.identification_expiry_date != nil{
            mExpirydateTF.text = profileDetails?.identification_expiry_date
        }
        if profileDetails?.mobile != nil{
            self.mobile_txtField.text = self.profileDetails?.mobile ?? ""
        }
        kProfileEditMobile = self.profileDetails?.mobile ?? ""
        if kProfileInputStatus == true{
            self.mobile_txtField.text = kProfileEditMobile
        }
        else{
            self.mobile_txtField.text = self.profileDetails?.mobile ?? ""
        }
    }
    @IBAction func updateBtnAction( _ sender : UIButton){
        print(kProfileInputStatus)
    //    if kProfileInputStatus == true{
        if mLastName.text == ""{
            self.showAlert("Rider RideshareRates", message: "Please enter last name")
            return
        }
        
            let index = sender.tag
            let param = ["name":name_txtField.text ?? "", "name_title":self.mNameTitle.text!, "last_name":self.mLastName.text!,"country_code": mCountryPicker.text ?? "" , "mobile": mobile_txtField.text ?? "", "identification_document_id" : selectedID, "identification_issue_date" : mIssueDateTF.text ?? "","identification_expiry_date": mExpirydateTF.text ?? "","verification_id" : docimg] as [String : Any]
            print(param)
            if kProfileEditMobile.count >= 10 {
                if kProfileDOCImageUpdateStatus == true {
                    self.updateProfileApi(imageOrVideo: self.docimg, params: param)
                }else{
                    self.updateProfileApi(imageOrVideo: nil, params: param)
                }
                self.updateProfileApi(imageOrVideo: nil, params: param)
            }else{
                self.showAlert("Rider RideshareRates", message: "Phone number should be minimum 10 digit")
            }
    //    }
        if kProfileImageUpdateStatus == true {
       // self.uploadProfilePhotoAPI(image: self.img, params: [:])
            if img != nil{
                self.uploadPhotoGallaryNew(media: self.img!, params: [:])
            }
         //   self.uploadPhotoGallaryNewSignup(mediaLicense: self.docimg)

        }
//        if kProfileDOCImageUpdateStatus == true {
//       // self.uploadProfilePhotoAPI(image: self.img, params: [:])
//          //  self.uploadPhotoGallaryNew(media: self.img, params: [:])
//        //    self.updateProfileApi(imageOrVideo: docimg, params: param)
//         //   self.uploadPhotoGallaryNewSignup(imageData: self.docimg, params: [:])
//
//        }
        
    }
    //MARK:- Button Action
    @IBAction func tapChangePass_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "ChangePasswordViewController") as! ChangePasswordViewController
        vc.modalPresentationStyle = .overFullScreen
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromTop
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tapSelectImage_btn(_ sender: Any) {
       // self.imagePicker.imagePickerDelegete = self
        //self.imagePicker.showImagePicker(viewController: self)
        imagePick = "profile"
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    //MARK:- opend camera
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
    //MARK:- open gallery
    func openGallery()
    {
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
    @IBAction func mUploadImageBTN(_ sender: Any) {
        imagePick = "doc"
     //   imagePickStatus = .imageProfile
//        self.imagePicker.imagePickerDelegete = self
//        self.imagePicker.showImagePicker(viewController: self)
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    //MARK:- Get Documentidentity
    func getdataApi() {
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "get_documentidentity_get",authRequired: true) { (value) in
            print("Profile Data Api  \(value)")
            Indicator.shared.hideProgressView()
            let msg = (value["message"] as? String ?? "")
            if self.conn.responseCode == 1{
            //  let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                
                do{
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    self.acceptedReqData = try newJSONDecoder().decode(rides.self, from: jsonData)
                    print(self.acceptedReqData)
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
}

//MARK:- picker

extension ProfileViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of session
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerviewNAme{
            return nametitleArr.count
        }else{
            return acceptedReqData.count // number of dropdown items
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerviewNAme{
            return nametitleArr[row]
        }else{
            return acceptedReqData[row].document_name! // dropdown item
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerviewNAme{
            mNameTitle.text = nametitleArr[row]
        }else{
            selectedservice = acceptedReqData[row].document_name!
            selectedID = acceptedReqData[row].id!
        }
       
    }
}
extension ProfileViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("calling")
            
            if imagePick == "profile" {
                self.userImg.image = pickedImage
                self.img = pickedImage
                kProfileImageUpdateStatus = true
            }
            if imagePick == "doc"{
                self.mImg.image = pickedImage
                self.docimg = pickedImage
                kProfileDOCImageUpdateStatus = true
//                identificationProofImageView.image = pickedImage
//                self.identificationProofImg = pickedImage
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
  
}
//MARK:- Image Picker Delegate
//extension ProfileViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate , ImagePickerDelegete {
//    func disFinishPicking(imgData: Data, img: UIImage) {
//        self.imageData = imgData
//        self.imageName =  String.uniqueFilename(withSuffix: ".png")
//        self.userImg.image = img
//        self.img = img
//        kProfileImageUpdateStatus = true
//    }
//}
extension ProfileViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == mIssueDateTF{
            showDatePicker()
           
        }else if textField == mExpirydateTF{
            showDatePicker()
          //  mEndDateTXTFLD.text = ""
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
        }else if textField == mDocTF{
            if selectedservice == nil{
                if acceptedReqData.count != 0{
                    selectedservice = acceptedReqData[0].document_name!
                  //  IDselected = searchModel.first?.id! as! String
                    mDocTF.text = selectedservice
                }
            }else{
                mDocTF.text = selectedservice
            }
        }else if textField == mobile_txtField{
           
            kProfileEditMobile = mobile_txtField.text ?? ""
        }
        kProfileInputStatus = true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobile_txtField{
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            mobile_txtField.text = format(with: "(XXX) XXX-XXXX", phone: newString)
            return false
        }
        else{
            return true
        }
    }
    
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
extension ProfileViewController : CountryPickerDelegate{
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        //pick up anythink
        self.mCountryPicker.text = phoneCode
    }
}
