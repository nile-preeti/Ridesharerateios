//
//  ProfileViewController.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit

class ProfileViewController: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet var mNameTitle: UITextField!
    @IBOutlet var mCountryPTF: UITextField!
    
    @IBOutlet var mLAstname: SetTextField!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var mDocumentTF: UITextField!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var mViewHEight: NSLayoutConstraint!
    @IBOutlet weak var mExpirydateTF: UITextField!
    @IBOutlet weak var mIssueDateTF: UITextField!
    @IBOutlet weak var licenseImageView: UIImageView!
    @IBOutlet weak var mPhoneNoLBL: UILabel!
    @IBOutlet weak var mEmailLBL: UILabel!
    @IBOutlet weak var mNameLBL: UILabel!
    @IBOutlet weak var tblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var userProfileImg: SetImageView!
    @IBOutlet weak var name_txtField: UITextField!
   // @IBOutlet weak var email_txtField: SetTextField!
    @IBOutlet weak var mobileNo_txtField: SetTextField!
    //MARK:- Variables
    var  checkBtnStatus = false
    let conn = webservices()
    var profileDetails : ProfileData?
    var imageData : Data?
    var imageName : String?
    var img : UIImage?
    var docImg : UIImage?
    var section = ["","",""]
    var imageView = ""
    lazy var imagePicker :ImagePickerViewControler  = {
        return ImagePickerViewControler()
    }()
    var isSelected = false
    var selectedIndex  = 0
    var datePicker = UIDatePicker()
    var datePicker2 = UIDatePicker()
    var DocumnetsPickerView = UIPickerView()
    var docModel = [CompletedRidesData]()
    var selectedDocID = String()
    var counPicker = CountryPicker()
    var pickerviewNAme = UIPickerView()
    var nametitleArr = ["Mr.","Ms.","Boss"]
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
        mCountryPTF.inputView = counPicker
        mobileNo_txtField.delegate = self
        self.counPicker.countryPickerDelegate = self
        self.counPicker.showPhoneNumbers = true
        mViewHEight.constant = 0
        mView.isHidden = true
        kProfileInputStatus = false
        self.setNav()
       // self.profileTableView.delegate = self
        self.profileTableView.dataSource = self
        self.registerCell()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "green")
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
      
        pickerviewNAme.delegate = self
        mNameTitle.inputView = pickerviewNAme
        mDocumentTF.inputView = DocumnetsPickerView
        DocumnetsPickerView.delegate = self
        mExpirydateTF.setLeftPaddingPoints(20)
        mIssueDateTF.setLeftPaddingPoints(20)
        name_txtField.setLeftPaddingPoints(50)
        mLAstname.setLeftPaddingPoints(20)
        mDocumentTF.setLeftPaddingPoints(20)
        mobileNo_txtField.setLeftPaddingPoints(80)
     
        pickerviewNAme.delegate = self
        mIssueDateTF.delegate = self
        mExpirydateTF.delegate = self
        getdoc()
    }
    override func viewWillAppear(_ animated: Bool) {
       // NavigationManager.pushToLoginVC(from: self)
        self.getProfileDataApi()
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
    }
    
    //MARK:- get documentidentity api
    func getdoc(){
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetType(getUrlString: "get_documentidentity_get",authRequired: false) { (Value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                
                let msg = (Value["message"] as? String ?? "")
                if (Value["status"] as? Int ?? 0) == 1{
                    
                    let data = (Value["data"] as? [[String:Any]])
                    print(data ?? [[]])
                    do{
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        self.docModel = try newJSONDecoder().decode(completed.self, from: jsonData)
                     //   print(self.brandData)
                        
                    }catch{
                        
                        print(error.localizedDescription)
                    }
                }else{
                    
                    self.showAlert("Driver RideshareRates", message: msg)
                }
            }
        }
    }
    //MARK:-  date picker
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
    //MARK:- set data
    func setData(){
        if self.img != nil{
            self.userProfileImg.image = self.img
        }else{
            let pic = self.profileDetails?.profile_pic ?? ""
            self.userProfileImg.sd_setImage(with:URL(string: pic ), placeholderImage: nil, completed: nil)
        }
       // if
        NSUSERDEFAULT.set((self.profileDetails?.profile_pic ?? ""), forKey: kProfilePic)
//        let pic =   NSUSERDEFAULT.value(forKey: kProfilePic) as? String ?? ""
//        self.userProfileImg.sd_setImage(with:URL(string: pic ), placeholderImage: nil, completed: nil)
        self.name_txtField.text = self.profileDetails?.name ?? ""
        self.mLAstname.text = self.profileDetails?.last_name ?? ""
        self.mNameTitle.text = self.profileDetails?.name_title
        self.mNameLBL.text = self.profileDetails?.name ?? ""
        self.mIssueDateTF.text = self.profileDetails?.identification_issue_date ?? ""
        self.mExpirydateTF.text = self.profileDetails?.identification_expiry_date ?? ""
     //   self.mNameLBL.setLeftPaddingPoints(50)
        
        if docImg != nil{
            self.licenseImageView.image = self.docImg
        }else{
            let licenseImage =   self.profileDetails?.verification_id ?? ""
            self.licenseImageView.sd_setImage(with:URL(string: licenseImage ), placeholderImage: nil, completed: nil)
        }
           
        mDocumentTF.text = profileDetails?.identification_document_name
//        if profileDetails?.identification_document_id != nil{
         //   selectedDocID =  (self.profileDetails?.identification_document_id)!
//            for i in 0..<docModel.count{
//                if docModel[i].id == selectedDocID{
//                    mDocumentTF.text = docModel[i].document_name!
//                    break
//                }
//            }
//        }
     //   identification_issue_date =
        self.mEmailLBL.text = self.profileDetails?.email ?? ""
       // self.mCountryPTF.text = self.profileDetails?.country ?? ""
        self.mPhoneNoLBL.text =  (self.profileDetails?.country_code ?? "")! + " " + (self.profileDetails?.mobile)!
        self.mCountryPTF.text = self.profileDetails?.country_code
     //   self.email_txtField.text = self.profileDetails?.email ?? ""
        if kProfileInputStatus == true{
            self.mobileNo_txtField.text = kProfileEditMobile
        }
        else{
            self.mobileNo_txtField.text = self.profileDetails?.mobile ?? ""
        }
    }
    
    
    @IBAction func tapProfileImg_btnAction(_ sender: Any) {
        if mView.isHidden == false{
            imageView = "profile"
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
    @IBAction func addVechile_btnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AddVehicleViewController") as! AddVehicleViewController
        vc.img = self.img
        vc.modalPresentationStyle = .overFullScreen
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.type = CATransitionType.fade
//        transition.subtype = CATransitionSubtype.fromTop
//        view.window!.layer.add(transition, forKey: kCATransition)
        vc.updateDelegate = self
        //self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func update_btnAction(_ sender: UIButton) {
        print(kProfileInputStatus)
        if mobileNo_txtField.text!.count < 10{
            self.showAlert("Driver RideshareRates", message: "Mobile should contain at least 10 digits")
        }else{
            let index = sender.tag
            let param = ["name": name_txtField.text as! String , "name_title": self.mNameTitle.text!, "last_name" : mLAstname.text as! String, "mobile":mobileNo_txtField.text as! String , "country_code": mCountryPTF.text ?? ""]
            //, "identification_issue_date" : mIssueDateTF.text as! String, "identification_expiry_date" : mExpirydateTF.text as! String]
            print(param)
            self.updateProfileApi(imageOrVideo: nil, params: param)
        }
       
        if self.img != nil{
            self.uploadPhotoGallaryNew(media: self.img!, params: [:])
        }
      
        
        //        }
//        if kProfileImageUpdateStatus == true {
//            //            //self.uploadPhotozzzzzz(image: self.img, params: [:])
//            self.uploadPhotoGallaryNew(media: self.img, params: [:])
//        }
    }
    
    @IBAction func changePass_btnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "ChangePasswordViewController") as! ChangePasswordViewController
        vc.modalPresentationStyle = .overFullScreen
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromTop
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: true, completion: nil)
    }
    
   
    override func viewDidLayoutSubviews() {
        profileTableView.frame = CGRect(x: profileTableView.frame.origin.x, y: profileTableView.frame.origin.y, width: profileTableView.frame.size.width, height: profileTableView.contentSize.height)
        profileTableView.reloadData()

    }
    //MARK:- User Defined Func
    func registerCell(){
//        let imgNib = UINib(nibName: "UserDetailsTableViewCell", bundle: nil)
//        self.profileTableView.register(imgNib, forCellReuseIdentifier: "UserDetailsTableViewCell")
//        let btnNib = UINib(nibName: "ButtonTableViewCell", bundle: nil)
//        self.profileTableView.register(btnNib, forCellReuseIdentifier: "ButtonTableViewCell")
        let vechileDetails = UINib(nibName: "VechileDetailsTableViewCell", bundle: nil)
        self.profileTableView.register(vechileDetails, forCellReuseIdentifier: "VechileDetailsTableViewCell")
      
    }
    func setNav(){
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
        self.navigationItem.title = "Profile"
        self.setNavButton()
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
    //MARK:- Button Action
    
    @objc func tapVechileEdit( _ sender : UIButton){
//        let vc = self.storyboard?.instantiateViewController(identifier: "EditProfileViewController") as! EditProfileViewController
//        vc.modalPresentationStyle = .overFullScreen
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.type = CATransitionType.fade
//        transition.subtype = CATransitionSubtype.fromTop
//        view.window!.layer.add(transition, forKey: kCATransition)
//        vc.vechileDetails = self.profileDetails?.vehicleDetail?[sender.tag]
//        vc.updateDelegate = self
//        self.present(vc, animated: true, completion: nil)
        
        let vc = self.storyboard?.instantiateViewController(identifier: "AddVehicleViewController") as! AddVehicleViewController
        vc.vechileDetails = self.profileDetails?.vehicleDetail?[sender.tag]
        vc.screen = "edit"
       // vc.updateDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func tapProfileImage_btn( _ sender : UIButton){
      
    }
    @objc func tapAddVechile( _ sender : UIButton){
      
    }
    @objc func tapChangePass( _ sender : UIButton){
       
    }
    @objc func updateBtnAction( _ sender : UIButton){
      
    }
    
    
    @IBAction func mImagUploadbtn(_ sender: Any) {
        imageView = "Doc"
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
    @IBAction func mEditBTN(_ sender: Any) {
        
        
        mViewHEight.constant = 260
        mView.isHidden = false
    }
    @IBAction func mCloseBTN(_ sender: Any) {
        mViewHEight.constant = 0
        mView.isHidden = true
    }
}
//MARK:- picker for documents
extension ProfileViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of session
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
     // if pickerView == DocumnetsPickerView{
        if pickerView == pickerviewNAme{
            return nametitleArr.count
        }else{
            return docModel.count
        }
  //      }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //   if pickerView == DocumnetsPickerView{
        if pickerView == pickerviewNAme{
            return nametitleArr[row]
        }else{
            return docModel[row].document_name
        }
  //      }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     //    if pickerView == DocumnetsPickerView{
        if pickerView == pickerviewNAme{
            mNameTitle.text = nametitleArr[row]
        }else{
            mDocumentTF.text = docModel[row].document_name
            selectedDocID = docModel[row].id!
        }
     //   }
    }
}
//MARK:- text field delegate
extension ProfileViewController: UITextFieldDelegate{
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
//MARK:- Image Picker Delegate
//extension ProfileViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate , ImagePickerDelegete {
//    func disFinishPicking(imgData: Data, img: UIImage) {
//        self.imageData = imgData
//      //  self.imageName =  String.uniqueFilename(withSuffix: ".png")
//        self.img = img
//        kProfileImageUpdateStatus = true
//    }
//}

extension ProfileViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    //MARK:-image picker 
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("calling")
            // imageViewPic.contentMode = .scaleToFill
            if imageView == "Doc"{
                self.licenseImageView.image = pickedImage
                self.docImg = pickedImage
             //   kProfileImageUpdateStatus = true
            }else{
                self.userProfileImg.image = pickedImage
                self.img = pickedImage
             //   kProfileImageUpdateStatus = true
            }
           
        }
        picker.dismiss(animated: true, completion: nil)
    }
  
}
extension ProfileViewController : EditProfileViewControllerDelegate{
    func updateStatus(flag: Bool) {
        if flag == true{
            print("text chnge")
          //  self.getProfileDataApi()
        }
    }
}
extension ProfileViewController : CountryPickerDelegate{
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        //pick up anythink
        self.mCountryPTF.text = phoneCode
    }
}
