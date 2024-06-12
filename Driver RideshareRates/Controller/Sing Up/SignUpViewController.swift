//
//  SignUpViewController.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit
import iOSDropDown
import CoreLocation
import GoogleMaps
import GooglePlaces
//var baseurl = "https://app.ridesharerates.com/"
var baseurl = "https://app.ridesharerates.com/staging_ridesharerates/"

class SignUpViewController: UIViewController {
    //MARK:- OUTLETS
    @IBOutlet var mNameTitle: UITextField!

    @IBOutlet var mLastNameTF: NoPasteTextField!
    @IBOutlet var mAddressTF: UITextField!
    @IBOutlet weak var mDocumentTF: UITextField!
    @IBOutlet weak var mDOBTF: UITextField!
    @IBOutlet weak var mTextFLD: UITextView!
    @IBOutlet weak var name_txtField: UITextField!
    @IBOutlet weak var email_txtField: NoPasteTextField!
    @IBOutlet weak var password_txtField: UITextField!
    @IBOutlet weak var cnfPass_txtField: UITextField!
    @IBOutlet weak var mobile_txtField: UITextField!
    @IBOutlet weak var selectVehicleCompName_txtField: UITextField!
    @IBOutlet weak var selectVehicleModelName_txtField: UITextField!
    @IBOutlet weak var selectYear_txtField: UITextField!
    @IBOutlet weak var vehicleNo_txtField: UITextField!
    @IBOutlet weak var vehicleColor_txtField: UITextField!
  //  @IBOutlet weak var vehicleType_txtField: UITextField!
    @IBOutlet weak var mExpirydateTF: UITextField!
    @IBOutlet weak var mIssueDateTF: UITextField!
 //   @IBOutlet weak var insuranceImageView: UIImageView!
    @IBOutlet weak var ProfilePicIMG: UIImageView!
    @IBOutlet weak var carPicImageView: UIImageView!
    @IBOutlet weak var identityIMG: UIImageView!
    @IBOutlet weak var selectSeats_txtField: UITextField!
    @IBOutlet weak var SSNo_txtField: NoPasteTextField!
  //  @IBOutlet weak var mViewforCheckBoxTOP: NSLayoutConstraint!
    @IBOutlet weak var mViewforcheckbox: UIView!
    @IBOutlet weak var mLuxurySeatsBTN: UIButton!
    @IBOutlet weak var mTVBTN: UIButton!
    @IBOutlet weak var mWIFIBTN: UIButton!
    
    @IBOutlet var mCountryPTF: UITextField!
    
    var indexV : Int?
    let conn = webservices()
    var params = [String:Any]()
    var genderSelect = ["Male","Female"]
    var brandData = [BrandDetails]()
   // var brandData = [BrandDetails]()

    var modelData = [ModelDetails]()
    var vehicleTypeData = [vehicleDetail]()
    var docModel = [CompletedRidesData]()
  //  var brandId = 0
    var modalId = ""
    var vehicleTypeId = 0
    var imageData : Data?
    var imageName : String?
    var img : UIImage?
    var imageURLOne = ""
    var imageURLTwo = ""
    var imageURLThree = ""
    var imageURLFour = ""
    var vCarImg : UIImage?
    var vProfilePic : UIImage?
    var videntityIMG : UIImage?
    //var insuranceImg = UIImage()
    var YearTF = [String]()
    var selectSeatsTF = ["4","5","6","7","8","above 8"]
    var selectYearpickerView = UIPickerView()
    var selectSeatsPickerView = UIPickerView()
    
    var brandDataPickerView = UIPickerView()
    var modelDataPickerView = UIPickerView()
    var vehicleTyPickerView = UIPickerView()
    var DocumnetsPickerView = UIPickerView()
    var brandIdString = String()
    var selectedDocID = String()

    var DOBdatePicker = UIDatePicker()
    var datePicker = UIDatePicker()
    var datePicker2 = UIDatePicker()
    var imagePickStatus =  ""
    var counPicker = CountryPicker()
    var pickerviewNAme = UIPickerView()
    var nametitleArr = ["Mr.","Ms.","Boss"]
    var Alatitude = String()
    var Alongitude = String()
    lazy var imagePicker :ImagePickerViewControler  = {
        return ImagePickerViewControler()
    }()
    //MARK:- Variables
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getBrandsApi()
        self.getdoc()
        picker()
        mCountryPTF.text = "+1"
        mCountryPTF.inputView = counPicker
        self.counPicker.countryPickerDelegate = self
        self.counPicker.showPhoneNumbers = true
        mNameTitle.inputView = pickerviewNAme
        pickerviewNAme.delegate = self
        SSNo_txtField.delegate = self
        SSNo_txtField.textContentType = .none
        selectYear_txtField.delegate = self
        mobile_txtField.delegate = self
        name_txtField.setLeftPaddingPoints(50)
        print("FCM TOKEN IS HERE \(String(describing: NSUSERDEFAULT.value(forKey: kFcmToken) as? String ?? ""))")
//        self.selectYear_txtField.optionArray = ["Select Vehicle Year","2022","2021","2020","2019","2018","2017","2016","2015","2014","2013","2012"]
//        self.selectSeats_txtField.optionArray = ["Select Number of Seats","2","4","6","8"]
        mAddressTF.delegate = self
      //  mAddressTF.addTarget(self, action: #selector(locationTextFieldTapped(_:)), for: .touchDown)
    //    updateAppVersionPopup()
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
    
    
    // Selector Method
//    @objc func locationTextFieldTapped(_ textField: UITextField) {
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
//        present(autocompleteController, animated: true, completion: nil)
//       // }
////        let storyboard = GTStoryboard.dashboard.storyboard
////        guard let searchLocationVC = storyboard.instantiateViewController(withIdentifier: GTStoryboardId.searchLocationViewController) as? SearchLocationViewController else {
////            return
////        }
////        searchLocationVC.delegate = self
////        searchLocationVC.modalPresentationStyle = .fullScreen
////        self.navigationController?.present(searchLocationVC, animated: true, completion: nil)
//    }
    
    
    //MARK picker
    func picker(){
        selectYearpickerView.delegate = self
        selectSeatsPickerView.delegate = self
        brandDataPickerView.delegate = self
        modelDataPickerView.delegate = self
        vehicleTyPickerView.delegate = self
        DocumnetsPickerView.delegate = self
        mTextFLD.text = "Home Address"
        mTextFLD.textColor = UIColor.lightGray
        mTextFLD.delegate = self
        mWIFIBTN.setImage(UIImage(named: "uncheck"), for: .normal)
        mTVBTN.setImage(UIImage(named: "uncheck"), for: .normal)
        mLuxurySeatsBTN.setImage(UIImage(named: "uncheck"), for: .normal)
        mViewforcheckbox.isHidden = true
      //  mViewforCheckBoxTOP.constant = -40
        
        selectVehicleModelName_txtField.inputView = vehicleTyPickerView
     //   selectSeats_txtField.inputView = selectSeatsPickerView
        selectSeats_txtField.isEnabled = false
        selectVehicleCompName_txtField.inputView = modelDataPickerView
        selectYear_txtField.inputView = selectYearpickerView
        mDocumentTF.inputView = DocumnetsPickerView
        mobile_txtField.setLeftPaddingPoints(60)

        selectVehicleModelName_txtField.setLeftPaddingPoints(20)
        selectSeats_txtField.setLeftPaddingPoints(20)
        selectVehicleCompName_txtField.setLeftPaddingPoints(20)
        selectYear_txtField.setLeftPaddingPoints(20)
        mExpirydateTF.setLeftPaddingPoints(20)
        mIssueDateTF.setLeftPaddingPoints(20)
        
        mDOBTF.delegate = self
        mIssueDateTF.delegate = self
        mExpirydateTF.delegate = self
        selectVehicleCompName_txtField.delegate = self
        selectVehicleModelName_txtField.delegate = self
        selectSeats_txtField.delegate = self
    }
    //MARK:- date picker
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
        DOBdatePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -65, to: Date())

        mDOBTF.inputView = DOBdatePicker
        
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        mIssueDateTF.inputView = datePicker
        
        datePicker2.datePickerMode = .date
        datePicker2.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        mExpirydateTF.inputView = datePicker2
    }
    
    
    //MARK:- User Defined Func
    @IBAction func tapSignIn_btn(){

        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func tapGoBack(){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func tapSignUp_btn(){
        self.validationsCheck()
    }
    //MARK:- Button Action
    @IBAction func  identityBTNAC(){
        imagePickStatus = "identity"
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
    @IBAction func ProfilePicBTNAC(){
        imagePickStatus = "profile"
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
    @IBAction func carPicBtnAction(){
        imagePickStatus = "carPic"
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
    override func viewDidAppear(_ animated: Bool) {
        self.getBrandsApi()
    }
    
    
    @IBAction func mWIFIbtn(_ sender: Any) {
        if mWIFIBTN.currentImage == UIImage(named: "uncheck"){
            mWIFIBTN.setImage(UIImage(named: "check"), for: .normal)
//            mTVBTN.setImage(UIImage(named: "uncheck"), for: .normal)
//            mLuxurySeatsBTN.setImage(UIImage(named: "uncheck"), for: .normal)

        }else{
            mWIFIBTN.setImage(UIImage(named: "uncheck"), for: .normal)

        }
    }
    
    @IBAction func aTVbtn(_ sender: Any) {
        if mTVBTN.currentImage == UIImage(named: "uncheck"){
          //  mWIFIBTN.setImage(UIImage(named: "uncheck"), for: .normal)
            mTVBTN.setImage(UIImage(named: "check"), for: .normal)
        //    mLuxurySeatsBTN.setImage(UIImage(named: "uncheck"), for: .normal)

        }else{
            mTVBTN.setImage(UIImage(named: "uncheck"), for: .normal)

        }
    }
    
    @IBAction func aluxuryseats(_ sender: Any) {
        if mLuxurySeatsBTN.currentImage == UIImage(named: "uncheck"){
            mLuxurySeatsBTN.setImage(UIImage(named: "check"), for: .normal)
        }else{
            mLuxurySeatsBTN.setImage(UIImage(named: "uncheck"), for: .normal)
        }
    }
}
extension SignUpViewController: UITextViewDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //  if textField == mCardNumTF{
        
        if textField == SSNo_txtField{
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            SSNo_txtField.text = format(with: "XXX-XX-XXXX", phone: newString)
            return false
        }else if textField == mobile_txtField{
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            mobile_txtField.text = format(with: "(XXX) XXX-XXXX", phone: newString)
            return false
        }
        return true
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
    func textViewDidBeginEditing(_ textView: UITextView) {
        if mTextFLD.textColor == UIColor.lightGray {
            mTextFLD.text = nil
            mTextFLD.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if mTextFLD.text.isEmpty {
            mTextFLD.text = "Home Address"
            mTextFLD.textColor = UIColor.lightGray
        }
    }
}
extension SignUpViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if textField == selectVehicleModelName_txtField || textField == selectYear_txtField{
            if self.indexV == nil{
                self.showAlert("Driver RideshareRates", message: "Please select vehicle make")
                return false
            }else{
                return true
            }
        }
//        if textField == selectYear_txtField {
//            if modelData.count == 0{
//                self.showAlert("Driver RideshareRates", message: "Please select vehicle make")
//                return false
//            }else{
//                return true
//            }
//        }
        // Do not add a line break
        return true
     }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == mIssueDateTF{
            showDatePicker()
        }else if textField == mExpirydateTF{
            showDatePicker()
          //  mEndDateTXTFLD.text = ""
        }else if textField == mDOBTF{
            showDatePicker()
        }else if textField == selectVehicleCompName_txtField{
            selectVehicleModelName_txtField.text = ""
            selectYear_txtField.text = ""
        }else if textField == selectVehicleModelName_txtField{
          //  selectVehicleModelName_txtField.text = ""
          //  self.getModelApi()
        }else if textField == mAddressTF{
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            autocompleteController.primaryTextColor = UIColor.lightGray
            autocompleteController.primaryTextHighlightColor = UIColor.white
            autocompleteController.secondaryTextColor = UIColor.white
            autocompleteController.tableCellSeparatorColor = UIColor.lightGray
            autocompleteController.tableCellBackgroundColor = UIColor.lightBlackThemeColor()
            
            let searchBarTextAttributes: [NSAttributedString.Key : AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white, NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont.systemFont(ofSize: UIFont.systemFontSize)]
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
            present(autocompleteController, animated: true, completion: nil)
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
        }else if textField == mDOBTF {
            let selectedDate = DOBdatePicker.date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.mDOBTF.text = formatter.string(from: selectedDate)
        }else if textField == selectVehicleCompName_txtField{
        //    let brandIdString:String = self.brandData[index].id  ?? ""
            if selectVehicleCompName_txtField.text != "Select Vehicle Make"{
                
//                if brandIdString == ""{
//                    brandIdString = brandData[0].id!
//                    selectVehicleCompName_txtField.text =  brandData[0].brandName
//                }
                
               
              //  self.brandId = Int(brandIdString)!
//                self.getYearApi()
//                self.getModelApi()
            }
        }else if textField == selectVehicleModelName_txtField{
//            if selectVehicleModelName_txtField.text == ""{
//                selectVehicleModelName_txtField.text =   modelData[0].modelName
//                selectSeats_txtField.text =   modelData[0].seat
//                modalId = modelData[0].id!
//            }
           
        }else if textField == selectSeats_txtField{
            if selectSeats_txtField.text == "8" {
                mViewforcheckbox.isHidden = false
              //  mViewforCheckBoxTOP.constant = 20
            }else{
                
                mViewforcheckbox.isHidden = true
              //  mViewforCheckBoxTOP.constant = -40
            }
        }
    }
}
extension SignUpViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of session
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerviewNAme{
            return nametitleArr.count
        }else if pickerView == selectYearpickerView{
            return brandData[self.indexV!].year!.count
        }else if pickerView == modelDataPickerView{
            return brandData.count
        }else if pickerView == vehicleTyPickerView{
            return brandData[self.indexV!].Subcategory!.count
        }else if pickerView == DocumnetsPickerView{
            return docModel.count
        }else{
            return selectSeatsTF.count
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerviewNAme{
            return nametitleArr[row]
        }else if pickerView == selectYearpickerView{
            return brandData[self.indexV!].year![row]
        }else if pickerView == modelDataPickerView{
            brandIdString =  brandData[row].id!
            print(brandIdString)
            return brandData[row].brandName
            
        }else if pickerView == vehicleTyPickerView{
            modalId = brandData[self.indexV!].Subcategory![row].subcat_id!
            print(modalId)
            return brandData[self.indexV!].Subcategory![row].subcat_title
          //  return modelData[row].modelName
            
        }else if pickerView == DocumnetsPickerView{
            return docModel[row].document_name
        }else{
            return selectSeatsTF[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerviewNAme{
            mNameTitle.text = nametitleArr[row]
        }else if pickerView == selectYearpickerView{
            selectYear_txtField.text = brandData[self.indexV!].year![row]
        }else if pickerView == modelDataPickerView{
            selectVehicleCompName_txtField.text =  brandData[row].brandName
            brandIdString =  brandData[row].id!
            print(brandIdString)
            self.indexV = row
          
        }else if pickerView == vehicleTyPickerView{
         
            modalId = brandData[self.indexV!].Subcategory![row].subcat_id!
            print(modalId)
                selectVehicleModelName_txtField.text =  brandData[self.indexV!].Subcategory![row].subcat_title
             
        }else if pickerView == DocumnetsPickerView{
            mDocumentTF.text = docModel[row].document_name
            selectedDocID = docModel[row].id!
          //  print(selectedDocID)
        }else if pickerView == selectSeatsPickerView{
            selectSeats_txtField.text = selectSeatsTF[row]
        }
    }
}
extension SignUpViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("calling")
           
//            if imagePickStatus == .imageInsurance {
//                insuranceImageView.image = pickedImage
//                self.insuranceImg = pickedImage
//
//            }
            if imagePickStatus == "profile"{
                ProfilePicIMG.image = pickedImage
                self.vProfilePic = pickedImage
                
            }
            if imagePickStatus == "carPic"{
                self.carPicImageView.image = pickedImage
                self.vCarImg = pickedImage
                
            }
            if imagePickStatus == "identity"{
                identityIMG.image = pickedImage
                self.videntityIMG = pickedImage
              
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
  
}
////MARK:- Image Picker Delegate
//extension SignUpViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate , ImagePickerDelegete {
//    func disFinishPicking(imgData: Data, img: UIImage) {
//        self.imageData = imgData
//        self.imageName =  String.uniqueFilename(withSuffix: ".png")
//        self.img = img
//        if self.img != nil{
//            let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
//            let userDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
//            let paths             = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
//            if let dirPath        = paths.first
//            {
//                if imagePickStatus == .imageInsurance {
//                    insuranceImageView.image = self.img
//                     imageURLOne = "\(URL(fileURLWithPath: dirPath).appendingPathComponent("name1.jpg"))"
//                }
//                if imagePickStatus == .imageLicense{
//                    licenseImageView.image = self.img
//                     imageURLTwo = "\(URL(fileURLWithPath: dirPath).appendingPathComponent("name2.jpg"))"
//                }
//                if imagePickStatus == .imageCarPic{
//                    carPicImageView.image = self.img
//                    imageURLThree = "\(URL(fileURLWithPath: dirPath).appendingPathComponent("name3.jpg"))"
//                }
//                if imagePickStatus == .identityIMG{
//                    carRegistrationImageView.image = self.img
//                    imageURLFour = "\(URL(fileURLWithPath: dirPath).appendingPathComponent("name4.jpg"))"
//                }
//            }
//        }
//    }
//}

extension SignUpViewController {
    //MARK:- valodation check 
    func validationsCheck(){
        
       
       
        
        if name_txtField.text == ""  {
            self.showAlert(Singleton.shared!.title, message: "Enter First Name")
          
        }else  if mLastNameTF.text == ""  {
            self.showAlert(Singleton.shared!.title, message: "Enter Last Name")
          
        }else if email_txtField.text == "" {
            self.showAlert(Singleton.shared!.title, message: "Enter Email")
            return
        }else if password_txtField.text == ""  {
            self.showAlert(Singleton.shared!.title, message: "Enter Password")
            return
        }else if cnfPass_txtField.text == ""  {
            self.showAlert(Singleton.shared!.title, message: "Enter Confirm Password")
            return
        }else if password_txtField.text!.count < 5{
            self.showAlert(Singleton.shared!.title, message: "Password should contain at least 6 characters")
            return
        }else if password_txtField.text != cnfPass_txtField.text {
            self.showAlert(Singleton.shared!.title, message: "Password and Confirm Password does not match")
            return
        }else if mobile_txtField.text == "" {
            self.showAlert(Singleton.shared!.title, message: "Enter Mobile Number")
            return
        }else if mobile_txtField.text!.count < 14{
            self.showAlert(Singleton.shared!.title, message: "Mobile should contain at least 10 digits")
            return
        }else if containsCharactersOtherThanNumbersAndDash(input: mobile_txtField.text!) {
            self.showAlert(Singleton.shared!.title, message: "Enter correct Mobile Number")
            return
        }else if SSNo_txtField.text == ""  {
            self.showAlert(Singleton.shared!.title, message: "Enter SSN Number")
            return
        }else if SSNo_txtField.text!.count < 11{
            self.showAlert(Singleton.shared!.title, message: "SSN Number should contain at least 9 characters")
            return
        }else if containsCharactersOtherThanNumbersAndDash(input: SSNo_txtField.text!) {
            self.showAlert(Singleton.shared!.title, message: "Enter correct SSN Number")
            return
        }else if mDOBTF.text == ""  {
            self.showAlert(Singleton.shared!.title, message: "Enter Date of birth")
            return
        }else if mAddressTF.text == ""  {
            self.showAlert(Singleton.shared!.title, message: "Select Address")
            return
        }else if selectVehicleCompName_txtField.text == ""  {
            self.showAlert(Singleton.shared!.title, message: "Select Vehicle Make")
            return
        }else if selectVehicleModelName_txtField.text == ""  {
            self.showAlert(Singleton.shared!.title, message: "Select Vehicle Model")
            return
        }else if selectYear_txtField.text == "" {
            self.showAlert(Singleton.shared!.title, message: "Select Vehicle Year")
            return
        }else if let vehicleColor = vehicleColor_txtField.text, vehicleColor == ""  {
            self.showAlert(Singleton.shared!.title, message: "Select Vehicle Color")
            return
        }else if let vehicleSeats = selectSeats_txtField.text, vehicleSeats == "Select Number of Seats"  {
            self.showAlert(Singleton.shared!.title, message: "Select Number of Seats")
            return
        }else if let vehicleNumber = vehicleNo_txtField.text, vehicleNumber == ""  {
            self.showAlert(Singleton.shared!.title, message: "Select Vehicle Number plate")
            return
        }else if vProfilePic == nil{
            self.showAlert(Singleton.shared!.title, message: "Please select profile pic")
            return
        }else if vCarImg == nil{
            self.showAlert(Singleton.shared!.title, message: "Please select car pic")
            return
//        }else if mDocumentTF.text == ""{
//            self.showAlert(Singleton.shared!.title, message: "Please select identity document")
//            return
//        }else if videntityIMG == nil{
//            self.showAlert(Singleton.shared!.title, message: "Please select identity pic")
//            return
//        }else if mIssueDateTF.text == "" {
//            self.showAlert(Singleton.shared!.title, message: "Please select issue date")
//            return
//        }else if mExpirydateTF.text == "" {
//            self.showAlert(Singleton.shared!.title, message: "Please select expiry date")
//            return
        }else{
            print("hit api")
            self.uploadPhotoGallaryNewSignup(media: self.vCarImg!, mediaIdentity:  self.vProfilePic!)
          //  self.hitSignUpApi()
        }
    }
    func containsCharactersOtherThanNumbersAndDash(input: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[0-9-) (]+$")
        let range = NSRange(location: 0, length: input.utf16.count)
        return regex.firstMatch(in: input, options: [], range: range) == nil
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
        Alatitude =  "\(place.coordinate.latitude)"
        Alongitude = "\(place.coordinate.longitude)"
        
      //  mAddressTF.textColor = UIColor.black
        mAddressTF.text = place.formattedAddress
        
        dismiss(animated: true, completion: nil)
    }
}
extension SignUpViewController : CountryPickerDelegate{
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        //pick up anythink
        self.mCountryPTF.text = phoneCode
    }
}
