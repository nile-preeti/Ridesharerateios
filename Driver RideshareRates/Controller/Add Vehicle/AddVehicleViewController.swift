//
//  AddVehicleViewController.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit
import iOSDropDown
import Alamofire

class AddVehicleViewController: UIViewController {
    //MARK:- OUTLETS
    @IBOutlet weak var selectVehicleCompName_txtField: UITextField!
    @IBOutlet weak var selectVehicleModelName_txtField: UITextField!
    @IBOutlet weak var selectYear_txtField: UITextField!
    @IBOutlet weak var notKnow_txtField: UITextField!
    @IBOutlet weak var vehicleNo_txtField: UITextField!
    @IBOutlet weak var vehicleColor_txtField: UITextField!
    @IBOutlet weak var mAbove8View: UIView!
    @IBOutlet weak var mToptohideView: NSLayoutConstraint!
    @IBOutlet weak var mCInspectionIMG: SetImageView!
    @IBOutlet weak var mLicenceIssuDate: SetTextField!
  //  @IBOutlet weak var mCRegistrationIMG: UILabel!
    @IBOutlet weak var mCInsuranceIMG: SetImageView!
    @IBOutlet weak var mLicenceExpDate: SetTextField!
    
    @IBOutlet weak var mVInspectionEXPDate: SetTextField!
    @IBOutlet weak var mVInspectionISsueDate: SetTextField!
    
    @IBOutlet weak var mCarInsuranceIssueDAte: SetTextField!
    
    @IBOutlet weak var mCArRegistrationExpriyDate: SetTextField!
    @IBOutlet weak var mCArRegistrIssueDate: SetTextField!
    @IBOutlet weak var mCarInsuranceExpDAte: SetTextField!
    
    
    
    @IBOutlet weak var insuranceImageView: UIImageView!
    @IBOutlet weak var licenseImageView: UIImageView!
    @IBOutlet weak var carPicImageView: UIImageView!
    @IBOutlet weak var carRegistrationImageView: UIImageView!
    
    @IBOutlet weak var mLuxurySeatsBTN: UIButton!
    @IBOutlet weak var mTVBTN: UIButton!
    @IBOutlet weak var mWIFIBTN: UIButton!
    //MARK:- Variables
  
    var vehicleTyPickerView = UIPickerView()
    var modelDataPickerView = UIPickerView()
    var selectYearpickerView = UIPickerView()
    
    
    var indexV : Int?
    var vechileDetails : VehicleDetail?
    let conn = webservices()
    var brandData = [BrandDetails]()
    var modelData = [ModelDetails]()
    var YearTF = [String]()
    var vehicleTypeData = [vehicleDetail]()
   // var brandId = 0
    var modalId = ""
    var brandIdString = ""
    var vehicleTypeId = 0
    var vehicleTypeIdString = ""
    var img : UIImage?
    var carImg = UIImage()
    var licenseImg = UIImage()
    var registrationImg = UIImage()
    var insuranceImg = UIImage()
    var mInspectionImg = UIImage()
    weak var updateDelegate: EditProfileViewControllerDelegate?
    var imageURLOne = ""
    var imageURLTwo = ""
    var imageURLThree = ""
    var imageURLFour = ""
    var datePicker = UIDatePicker()
    var datePicker2 = UIDatePicker()
    var screen = ""
    enum imagePic {
        case imageInsurance
        case imageInspection
        case imageLicense
        case imageCarPic
        case imageCarRegistration
    }
    var imagePickStatus =  imagePic.imageInsurance
    lazy var imagePicker :ImagePickerViewControler  = {
        return ImagePickerViewControler()
    }()
   
    var imageData : Data?
    var imageName : String?
    
    var selectSeatsPickerView = UIPickerView()
    var selectSeatsTF = ["4","5","6","7","8","above 8"]
    var pFac = ""
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
        picker()
        notKnow_txtField.isEnabled = false
        selectVehicleCompName_txtField.placeHolderColor = .lightGray
        selectVehicleModelName_txtField.placeHolderColor = .lightGray
        selectYear_txtField.placeHolderColor = .lightGray
      //  selectSeatsPickerView.delegate = self
        notKnow_txtField.inputView = selectSeatsPickerView
        notKnow_txtField.delegate = self
        mWIFIBTN.setImage(UIImage(named: "uncheck"), for: .normal)
        mTVBTN.setImage(UIImage(named: "uncheck"), for: .normal)
        mLuxurySeatsBTN.setImage(UIImage(named: "uncheck"), for: .normal)
        mAbove8View.isHidden = true
        mToptohideView.constant = 10
        mLicenceIssuDate.delegate = self
        mCArRegistrIssueDate.delegate = self
        mCarInsuranceIssueDAte.delegate = self
        mVInspectionISsueDate.delegate = self
        mLicenceExpDate.delegate = self
        mVInspectionEXPDate.delegate = self
        mCarInsuranceExpDAte.delegate = self
        mCArRegistrationExpriyDate.delegate = self
        mLicenceExpDate.setLeftPaddingPoints(20)
        mVInspectionEXPDate.setLeftPaddingPoints(20)
        mVInspectionISsueDate.setLeftPaddingPoints(20)
        mCarInsuranceIssueDAte.setLeftPaddingPoints(20)
        mCArRegistrationExpriyDate.setLeftPaddingPoints(20)
        mCArRegistrIssueDate.setLeftPaddingPoints(20)
        mCarInsuranceExpDAte.setLeftPaddingPoints(20)
        mLicenceIssuDate.setLeftPaddingPoints(20)
        self.setTxtFieldRadius()
    //    self.setDropDownData()
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.white
      //  if self.screen == "edit"{
            setData()
            self.navigationItem.title = "Edit Vehicle"
//        }else{
//            self.navigationItem.title = "Add Vehicle"
//        }
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
       
    }
    
    func picker(){
        selectVehicleModelName_txtField.delegate = self
        selectVehicleCompName_txtField.delegate = self
        selectYear_txtField.delegate = self
        selectYear_txtField.delegate = self
        vehicleTyPickerView.delegate = self
        modelDataPickerView.delegate = self
        selectYearpickerView.delegate = self
        vehicleTyPickerView.dataSource = self
        modelDataPickerView.dataSource = self
        selectYearpickerView.dataSource = self
        selectVehicleModelName_txtField.inputView = vehicleTyPickerView
        selectVehicleCompName_txtField.inputView = modelDataPickerView
        selectYear_txtField.inputView = selectYearpickerView
     
    }
    //MARK:- date picker
    func showDatePicker(){
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker2.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        mLicenceIssuDate.inputView = datePicker
        mCArRegistrIssueDate.inputView = datePicker
        mCarInsuranceIssueDAte.inputView = datePicker
        mVInspectionISsueDate.inputView = datePicker
        
        datePicker2.datePickerMode = .date
        datePicker2.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        
        mLicenceExpDate.inputView = datePicker2
        mVInspectionEXPDate.inputView = datePicker2
        mCarInsuranceExpDAte.inputView = datePicker2
        mCArRegistrationExpriyDate.inputView = datePicker2
    }
    //MARK:- set data Func
    func setData(){
        self.selectVehicleCompName_txtField.text = self.vechileDetails?.vehicle_type ?? "Select Vehicle Make"
        self.selectVehicleModelName_txtField.text = self.vechileDetails?.model_name ?? "Select Vehicle Model"
        self.selectYear_txtField.text = self.vechileDetails?.year ?? ""
        if self.vechileDetails?.seat_no == "9"{
            var arrayy = [String]()
            if self.vechileDetails?.premium_facility != "" && self.vechileDetails?.premium_facility != nil{
                arrayy = self.vechileDetails?.premium_facility!.components(separatedBy: ",") ?? [""]
                mAbove8View.isHidden = false
                mToptohideView.constant = 70
                self.notKnow_txtField.text = "8"
                if arrayy.contains("Wi-Fi"){
                    mWIFIBTN.setImage(UIImage(named: "check"), for: .normal)
                }
                if arrayy.contains(" T.V."){
                    mTVBTN.setImage(UIImage(named: "check"), for: .normal)
                }
                if arrayy.contains(" Luxury "){
                    mLuxurySeatsBTN.setImage(UIImage(named: "check"), for: .normal)
                }
            }else{
                self.notKnow_txtField.text = "above 8"
            }
        }else{
            self.notKnow_txtField.text = self.vechileDetails?.seat_no ?? ""
        }
        self.vehicleNo_txtField.text = self.vechileDetails?.vehicle_no ?? ""
        self.vehicleColor_txtField.text = self.vechileDetails?.color ?? ""
        self.brandIdString =  self.vechileDetails?.brand_id ?? ""
        self.modalId = self.vechileDetails?.model_id ?? ""
        self.vehicleTypeId = Int(self.vechileDetails?.vehicle_type ?? "") ?? 0
       self.carPicImageView.sd_setImage(with:URL(string: self.vechileDetails?.car_pic ?? "" ), placeholderImage: nil, completed: nil)
        self.mCArRegistrIssueDate.text = vechileDetails?.car_issue_date
        self.mCArRegistrationExpriyDate.text = vechileDetails?.car_expiry_date
        self.carRegistrationImageView.sd_setImage(with:URL(string: self.vechileDetails?.car_registration_doc ?? "" ), placeholderImage: nil, completed: nil)
        self.mVInspectionISsueDate.text = vechileDetails?.inspection_issue_date
        self.mVInspectionEXPDate.text = vechileDetails?.inspection_expiry_date
        self.mCInspectionIMG.sd_setImage(with:URL(string: self.vechileDetails?.inspection_document ?? "" ), placeholderImage: nil, completed: nil)
        self.mCarInsuranceIssueDAte.text = vechileDetails?.insurance_issue_date
        self.mCarInsuranceExpDAte.text = vechileDetails?.insurance_expiry_date
        self.mCInsuranceIMG.sd_setImage(with:URL(string: self.vechileDetails?.insurance_doc ?? "" ), placeholderImage: nil, completed: nil)
        self.mLicenceIssuDate.text = vechileDetails?.license_issue_date
        self.mLicenceExpDate.text = vechileDetails?.license_expiry_date
        self.licenseImageView.sd_setImage(with:URL(string: self.vechileDetails?.license_doc ?? "" ), placeholderImage: nil, completed: nil)

    }
    //MARK:- Button Action
    @IBAction func carIMGBtnAction(){
        imagePickStatus = .imageCarPic
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
    @IBAction func  caRegistrationBtnAction(){
        imagePickStatus = .imageCarRegistration
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
    @IBAction func drivingLicenseBtnAction(){
        imagePickStatus = .imageLicense
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
    
    @IBAction func mCarInspectionBTN(_ sender: Any) {
        imagePickStatus = .imageInspection
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
    
    @IBAction func mCarInsuranceBTN(_ sender: Any) {
        imagePickStatus = .imageInsurance
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
    //MARK:- camera open
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
    //MARK:- fun to open gallery
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
    override func viewWillAppear(_ animated: Bool) {
        self.getBrandsApi()
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
       // self.getVehicleTypeApi()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //MARK:- User Defined Func
//    func setDropDownData(){
//        self.selectYear_txtField.optionArray = ["Select Vehicle Year","2022","2021","2020","2019","2018","2017","2016","2015","2014","2013","2012"]
//    }
    //MARK:- txt field setup
    func setTxtField(textField:UITextField){
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: "green")?.cgColor
    }
    //MARK:- text field radius set
    func setTxtFieldRadius(){
        self.setTxtField(textField: self.selectVehicleCompName_txtField)
        self.setTxtField(textField: self.selectVehicleModelName_txtField)
        self.setTxtField(textField: self.selectYear_txtField)
        self.setTxtField(textField: self.notKnow_txtField)
    }
    //MARK:- Button Action
    @IBAction func tapSave_btn(_ sender: Any) {
        self.validationsCheck()
    }
    @IBAction func tapCancel_btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func mWIFIbtn(_ sender: Any) {
        if mWIFIBTN.currentImage == UIImage(named: "uncheck"){
            mWIFIBTN.setImage(UIImage(named: "check"), for: .normal)
        }else{
            mWIFIBTN.setImage(UIImage(named: "uncheck"), for: .normal)
        }
    }
    @IBAction func aTVbtn(_ sender: Any) {
        if mTVBTN.currentImage == UIImage(named: "uncheck"){
            mTVBTN.setImage(UIImage(named: "check"), for: .normal)

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
//MARK:- ui picker
extension AddVehicleViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return 1 // number of session
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == selectYearpickerView{
            return brandData[self.indexV!].year!.count
        }else if pickerView == modelDataPickerView{
            return brandData.count
        }else{
            return brandData[self.indexV!].Subcategory!.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == selectYearpickerView{
            return brandData[self.indexV!].year![row]
        }else if pickerView == modelDataPickerView{
            brandIdString =  brandData[row].id!
            
            return brandData[row].brandName
        }else {
          //  modalId = modelData[row].id!
            modalId = brandData[self.indexV!].Subcategory![row].subcat_id!
            return brandData[self.indexV!].Subcategory![row].subcat_title
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == selectYearpickerView{
            selectYear_txtField.text = brandData[self.indexV!].year![row]
        }else if pickerView == modelDataPickerView{
            self.indexV = row
            selectVehicleCompName_txtField.text =  brandData[row].brandName
            brandIdString =  brandData[row].id!
            
        }else if pickerView == vehicleTyPickerView{
            modalId = brandData[self.indexV!].Subcategory![row].subcat_id!
        //    return brandData[self.indexV!].Subcategory![row].subcat_title
                selectVehicleModelName_txtField.text =  brandData[self.indexV!].Subcategory![row].subcat_title
        }
    }
}
//MARK:- TextFieldDelegate
extension AddVehicleViewController: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if textField == selectVehicleModelName_txtField || textField == selectYear_txtField{
            if indexV == nil{
                self.showAlert("Driver RideshareRates", message: "Please select vehicle make first")
                return false
            }else{
//                self.getModelApi()
//                self.getYearApi()
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
         if textField == selectVehicleCompName_txtField{
            selectVehicleModelName_txtField.text = ""
            selectYear_txtField.text = ""
        }else if textField == selectVehicleModelName_txtField{
          //  selectVehicleModelName_txtField.text = ""
          //  self.getModelApi()
        }else if textField == selectYear_txtField{
            //  selectVehicleModelName_txtField.text = ""
          //    self.getYearApi()
          }else{
            showDatePicker()
        }
       
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == mLicenceIssuDate {
            let selectedDate = datePicker.date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.mLicenceIssuDate.text = formatter.string(from: selectedDate)
        }else if textField == mCArRegistrIssueDate {
            let selectedDate = datePicker.date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.mCArRegistrIssueDate.text = formatter.string(from: selectedDate)
        }else if textField == mCarInsuranceIssueDAte {
            let selectedDate = datePicker.date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.mCarInsuranceIssueDAte.text = formatter.string(from: selectedDate)
        }else if textField == mVInspectionISsueDate {
            let selectedDate = datePicker.date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.mVInspectionISsueDate.text = formatter.string(from: selectedDate)
        }else if textField == mLicenceExpDate {
            let selectedDate = datePicker2.date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.mLicenceExpDate.text = formatter.string(from: selectedDate)
        }else if textField == mVInspectionEXPDate {
            let selectedDate = datePicker2.date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.mVInspectionEXPDate.text = formatter.string(from: selectedDate)
        }else if textField == mCarInsuranceExpDAte {
            let selectedDate = datePicker2.date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.mCarInsuranceExpDAte.text = formatter.string(from: selectedDate)
        }else if textField == mCArRegistrationExpriyDate {
            let selectedDate = datePicker2.date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.mCArRegistrationExpriyDate.text = formatter.string(from: selectedDate)
        }else if textField == notKnow_txtField{
            if notKnow_txtField.text == "8" {
                mAbove8View.isHidden = false
                mToptohideView.constant = 70
            }else{
                mAbove8View.isHidden = true
                mToptohideView.constant = 10
            }
        }else if textField == selectVehicleCompName_txtField{
            //    let brandIdString:String = self.brandData[index].id  ?? ""
                if selectVehicleCompName_txtField.text != "Select Vehicle Make"{
                    
                    if brandIdString == ""{
                        brandIdString = brandData[0].id!
                        selectVehicleCompName_txtField.text =  brandData[0].brandName
                    }
                }
        }else if textField == selectVehicleModelName_txtField{
            if selectVehicleModelName_txtField.text == ""{
                modalId = brandData[self.indexV!].Subcategory![0].subcat_id!
                selectVehicleModelName_txtField.text =  brandData[self.indexV!].Subcategory![0].subcat_title
                
            }
            
        }
    }
}
//MARK:- Web Api
extension AddVehicleViewController{
    //MARK:-  get brand api
    func getBrandsApi(){
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetType(getUrlString: "getAllCategory",authRequired: false) { (Value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                
                let msg = (Value["message"] as? String ?? "")
                if (Value["status"] as? Int ?? 0) == 1{
                    
                    let data = (Value["data"] as? [[String:Any]])
                    print(data ?? [[]])
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        self.brandData = try newJSONDecoder().decode(brand.self, from: jsonData)
                        print(self.brandData)
               
                        
                    }catch{
                        
                        print(error.localizedDescription)
                    }
                }else{
                    
                    self.showAlert("Driver RideshareRates", message: "msg")
                }
            }
        }
    }
    //MARK:-  get model api
//    func getModelApi(){
//        Indicator.shared.showProgressView(self.view)
//        let param = ["category_id":self.brandIdString]
//        
//        self.conn.startConnectionWithPostType(getUrlString: "getSubcategory", params: param,authRequired: true) { (Value) in
//            Indicator.shared.hideProgressView()
//            if self.conn.responseCode == 1{
//                
//                let msg = (Value["message"] as? String ?? "")
//                if (Value["status"] as? Int ?? 0) == 1{
//                    
//                    let data = (Value["data"] as? [[String:Any]])
//                    print(data ?? [[]])
//                    do{
//                        self.modelData.removeAll()
//                        let jsonData = try JSONSerialization.data(withJSONObject: data as Any, options: .prettyPrinted)
//                        self.modelData = try newJSONDecoder().decode(model.self, from: jsonData)
//                        print(self.modelData)
//                        OperationQueue.main.addOperation {
//                            self.vehicleTyPickerView.reloadAllComponents()
//                        }
//                        DispatchQueue.main.async {
//                            self.vehicleTyPickerView.reloadAllComponents()
//                            // Code to be executed on the main thread
//                        }
//                       // let arr = self.modelData.map({$0.modelName ?? ""})
////                        DispatchQueue.main.async {
////                            
////                            self.modelDataPickerView.reloadAllComponents()
////                            
////                        }
//                       // self.modelDataPickerView.reloadAllComponents()
////                        self.selectVehicleModelName_txtField.optionArray = arr
////                        self.selectVehicleModelName_txtField.didSelect { (item, index, row) in
////                            print(index)
////                            self.modalId = index
////                            let modalIdString:String = self.modelData[index].id  ?? ""
////                            self.modalId = Int(modalIdString)!
////                           // self.getVehicleTypeApi()
////
////                        }
//                    }catch{
//                        
//                        print(error.localizedDescription)
//                    }
//                    
//                }else{
//                    
//                    self.showAlert("Driver RideshareRates", message: msg)
//                }
//            }
//        }
//    }
    
    //MARK:- get Year api
//    func getYearApi(){
//        Indicator.shared.showProgressView(self.view)
//        let param = ["category_id":self.brandIdString]
//        
//        self.conn.startConnectionWithPostType(getUrlString: "get-vehicle-year", params: param,authRequired: false) { (Value) in
//            
//            Indicator.shared.hideProgressView()
//            if self.conn.responseCode == 1{
//                
//                let msg = (Value["message"] as? String ?? "")
//                if (Value["status"] as? Int ?? 0) == 1{
//                    
//                    let data = (Value["data"] as? [[String:Any]])
//                    print(data ?? [[]])
//                    do{
//                        self.YearTF.removeAll()
//                        self.modelData.removeAll()
//                        let jsonData = try JSONSerialization.data(withJSONObject: data as Any, options: .prettyPrinted)
//                        self.modelData = try newJSONDecoder().decode(model.self, from: jsonData)
//                        print(self.modelData)
//                        let arr = self.modelData.map({$0.category_year ?? ""})
//                        
//                        self.YearTF.append(contentsOf: arr)
////                        DispatchQueue.main.async {
////                            self.selectYearpickerView.reloadAllComponents()
////                        }
//                      //  self.selectYearpickerView.reloadAllComponents()
////                        self.selectVehicleModelName_txtField.optionArray = arr
////                        self.selectVehicleModelName_txtField.didSelect { (item, index, row) in
////                            print(index)
////                            self.modalId = index
////                            let modalIdString:String = self.modelData[index].id  ?? ""
////                            self.modalId = Int(modalIdString)!
////                           // self.getVehicleTypeApi()
////
////                        }
//                    }catch{
//                        
//                        print(error.localizedDescription)
//                    }
//                    
//                }else{
//                    
//                    self.showAlert("Driver RideshareRates", message: msg)
//                }
//            }
//        }
//    }
    //MARK:-  get vehicle  type api
    func getVehicleTypeApi(){
        Indicator.shared.showProgressView(self.view)
        let param = ["pickup_address": kPickAddress,
                     "drop_address": kDropAddress]
        print(param)
        self.conn.startConnectionWithPostType(getUrlString: "getVehicleType", params: [:],authRequired: true) { (Value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                let msg = (Value["message"] as? String ?? "")
                if (Value["status"] as? Int ?? 0) == 1{
                    let data = (Value["data"] as? [[String:Any]])
                    print(data ?? [[]])
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: data as Any, options: .prettyPrinted)
                        self.vehicleTypeData = try newJSONDecoder().decode(vehicleType.self, from: jsonData)
//                        let arr = self.vehicleTypeData.map({$0.title ?? ""})
//                        self.notKnow_txtField.optionArray = arr
                        let arrNumber = self.modelData.map({$0.id ?? ""})
//                        self.notKnow_txtField.didSelect { (item, index, row) in
//                            self.vehicleTypeIdString = self.vehicleTypeData[index].id  ?? ""
//                            self.vehicleTypeId = Int(self.vehicleTypeIdString)!
//                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }else{
                    self.showAlert("Driver RideshareRates", message: msg)
                }
            }
        }
    }
    // imageOrVideo : UIImage?,
    func addVechileApi(params: [String: Any]){
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? ""),
            "Content-type": "multipart/form-data"]
        print(params)
        Indicator.shared.showProgressView(self.view)
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in params {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
//            if imageOrVideo != nil{
//                multipartFormData.append(imageOrVideo!.jpegData(compressionQuality: 0.5)!, withName: "car_pic" , fileName: "file.jpeg", mimeType: "image/jpeg")
//            }
        },
        to: "\(baseurl)add_vehicle_detail", method: .post , headers: headers)
        .responseJSON(completionHandler: { (data) in
            Indicator.shared.hideProgressView()
            let d = data.value
            let value = (d as? [String:Any] ?? [:])
            print(value)
            let msg = (value["message"] as? String ?? "")
            if (value["status"] as? Int ?? 0) == 1{
                self.updateDelegate?.updateStatus(flag: true)
                self.showAlertWithAction(Title: "Driver RideshareRates", Message: msg, ButtonTitle: "Ok") {
                   // self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)

                }
            }else{
                self.showAlert("Driver RideshareRates", message: msg)
            }
        })
    }
    
    
    //MARK:-  upload photo
    func uploadPhoto(media: UIImage, params: [String:Any], fileName: String){
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(media.jpegData(
                    compressionQuality: 0.5)!,
                    withName: "upload_data",
                    fileName: "\(fileName).jpeg", mimeType: "image/jpeg"
                )
                for p in params {
                    multipartFormData.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
                }
//                for param in params {
//                    let value = (param.value as AnyObject).data(using: String.Encoding.utf8.rawValue)!
//                    multipartFormData.append(value, withName: param.key)
//                }
            },
            to: "\(baseurl)add_vehicle_detail",
            method: .post ,
            headers: headers
        )
        .response { response in
            print(response)
        }
    }
    //MARK:-  upload photo from gallary
    func uploadPhotoGallaryNew(media: UIImage ,mediaLicense:UIImage, inspection_document:UIImage,  mediaInsurance :UIImage,mediaRegistration : UIImage , params: [String:Any]){
        let imageData = media.jpegData(compressionQuality: 0.25)
        let imageDataLicence = mediaLicense.jpegData(compressionQuality: 0.25)
        let imageDataInsurance = mediaInsurance.jpegData(compressionQuality: 0.25)
        let imageDataRegistration = mediaRegistration.jpegData(compressionQuality: 0.25)

        let inspection_document = inspection_document.jpegData(compressionQuality: 0.25)
        print("image data\(String(describing: imageData))")
        var url = URL(string:"")
        if screen == "edit"{
            url = URL(string: "\(baseurl)update_vehicle_detail")
        }else{
            url = URL(string: "\(baseurl)add_vehicle_detail")
        }
        let headers: HTTPHeaders = [
           // "Content-type": "multipart/form-data",
            "Accept": "application/json",
            "authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as? String ?? "")"
        ]
        Indicator.shared.showProgressView(self.view)
        AF.upload(multipartFormData: { multipartFormData in
            if imageDataInsurance != nil {
                multipartFormData.append(imageDataInsurance!,
                                         withName: "insurance" , fileName: "insurance.jpg", mimeType: "image/jpeg"
                )
            }
            if imageDataLicence != nil {
                multipartFormData.append(imageDataLicence!,
                                         withName: "license" , fileName: "license.jpg", mimeType: "image/jpeg"
                )
            }
            if imageData != nil{
                multipartFormData.append(imageData!,
                                         withName: "car_pic" , fileName: "car_pic.jpg", mimeType: "image/jpeg"
                )
            }
            if inspection_document != nil{
                multipartFormData.append(inspection_document!,
                                         withName: "inspection_document" , fileName: "inspection_document.jpg", mimeType: "image/jpeg"
                )
            }
            if imageDataRegistration != nil{
                multipartFormData.append(imageDataRegistration!,
                                         withName: "car_registration" , fileName: "car_registration.jpg", mimeType: "image/jpeg"
                )
            }
   
            
            for p in params {
                multipartFormData.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
                print("KEY VALUE DATA===========\(p.key)"=="-----+++++----\(p.value)")
            }
        }, to: url!, headers: headers)
        .responseJSON { response in
            print("URL \(url) AND HEADERS==========\(headers)")
            print(response)
            Indicator.shared.hideProgressView()
            switch (response.result) {
            case .success(let JSON):
                print("JSON: \(JSON)")
                let responseString = JSON as! NSDictionary
                print(responseString)
                let msg = responseString["message"] as? String ?? ""
                if (responseString["status"] as? Int ?? 0) == 1 {
                    self.showAlertWithAction(Title: "Driver RideshareRates", Message: msg, ButtonTitle: "Ok") {
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                }
                else{
                    self.showAlert("Driver RideshareRates", message: msg)
                }
                break;
            case .failure(let error):
                print(error)
                self.showAlert("Driver RideshareRates", message: "\(error.localizedDescription)")
                break
            }
        }
      
    }
    
}
extension AddVehicleViewController {
    //MARK:- validation check
    func validationsCheck(){
        guard let brand = selectVehicleCompName_txtField.text, brand != "Select Vehicle Make",selectVehicleCompName_txtField.text != ""  else {
            self.showAlert(Singleton.shared!.title, message: "Select Vehicle Make")
            return
        }
        guard let model = selectVehicleModelName_txtField.text, model != "Select Vehicle Model",selectVehicleModelName_txtField.text != "" else {
            self.showAlert(Singleton.shared!.title, message: "Select Vehicle Model")
            return
        }
        guard let year = selectYear_txtField.text, year != "Select Vehicle Year",selectYear_txtField.text != "" else {
            self.showAlert(Singleton.shared!.title, message: "Select Vehicle Year")
            return
        }
        guard let vehicle_type = notKnow_txtField.text, vehicle_type != "Select Number of Seats" else {
            self.showAlert(Singleton.shared!.title, message: "Select Number of Seats")
            return
        }
        guard let vehicleNumber = vehicleNo_txtField.text, vehicleNumber != "" else {
            self.showAlert(Singleton.shared!.title, message: "Please Select Vehicle Number")
            return
        }
        guard let vehicleColor = vehicleColor_txtField.text, vehicleColor != "" else {
            self.showAlert(Singleton.shared!.title, message: "Please Select Vehicle Color")
            return
        }
        var param : [String : Any]?
        
        var seats = String()
        
        if notKnow_txtField.text == "8"{
            
            if mTVBTN.currentImage == UIImage(named: "check") || mWIFIBTN.currentImage == UIImage(named: "check") || mLuxurySeatsBTN.currentImage == UIImage(named: "check"){
                var SeatArray = [String]()
                if mTVBTN.currentImage == UIImage(named: "check"){
                    SeatArray.append(" T.V.")
                }
                if mWIFIBTN.currentImage == UIImage(named: "check"){
                    SeatArray.append("Wi-Fi")
                }
                if mLuxurySeatsBTN.currentImage == UIImage(named: "check"){
                    SeatArray.append(" Luxury ")
                }
                pFac = SeatArray.joined(separator: ",")
                seats = "9"
            }else{
                seats = "8"
            }
           
        }else if notKnow_txtField.text == "above 8"{
            seats = "9"
        }else{
            seats = notKnow_txtField.text ?? ""
        }
        
        
        
//        if notKnow_txtField.text == "above 8"{
//            seats = "9"
//        }else{
//            seats = notKnow_txtField.text ?? ""
//        }
        
        if screen == "edit"{
            param = ["vehicle_no":vehicleNumber,"color":vehicleColor,"brand":brandIdString,"model":modalId,"year":String(self.selectYear_txtField.text   ?? "")  ?? 0, "seat_no" : seats ,"premium_facility" : pFac, "permit" : "","license_issue_date" : mLicenceIssuDate.text ?? "", "license_expiry_date": mLicenceExpDate.text ?? "",  "insurance_issue_date": mCarInsuranceIssueDAte.text ?? "","insurance_expiry_date":mCarInsuranceExpDAte.text ?? "","inspection_issue_date":mVInspectionISsueDate.text ?? "","inspection_expiry_date":mVInspectionEXPDate.text ?? "","car_issue_date": mCArRegistrIssueDate.text ?? "","car_expiry_date" : mCArRegistrationExpriyDate.text ?? "", "vehicle_detail_id" : vechileDetails?.vehicle_detail_id ?? ""
           ] as [String : Any]
        }else{
            param = ["vehicle_no":vehicleNumber,"color":vehicleColor,"brand":brandIdString,"model":modalId,"year":Int(self.selectYear_txtField.text   ?? "")  ?? 0, "seat_no" : seats, "permit" : "","license_issue_date" : mLicenceIssuDate.text ?? "", "license_expiry_date": mLicenceExpDate.text ?? "",  "insurance_issue_date": mCarInsuranceIssueDAte.text ?? "","insurance_expiry_date":mCarInsuranceExpDAte.text ?? "","inspection_issue_date":mVInspectionISsueDate.text ?? "","inspection_expiry_date":mVInspectionEXPDate.text ?? "","car_issue_date": mCArRegistrIssueDate.text ?? "","car_expiry_date" : mCArRegistrationExpriyDate.text ?? ""
           ] as [String : Any]
        }
        
        
      //  let
        print(param)
      //  self.addVechileApi( params: param)
       // self.carPicImageView.image = self.carImg
   // self.uploadPhotozzzzzz(image: self.carImg!, params: param)
       
      //  self.uploadPhoto(media: self.img!, params: param, fileName: "file.jpg")
//        self.uploadPhotoGallaryNew(media: self.carImg, mediaLicense: <#UIImage#>, params: param)
        self.uploadPhotoGallaryNew(media: self.carImg,mediaLicense: licenseImg, inspection_document: self.mInspectionImg, mediaInsurance: self.insuranceImg, mediaRegistration: self.registrationImg, params: param!)
        }
}

extension AddVehicleViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    //MARK:- image picker 
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("calling")
           
            if imagePickStatus == .imageInsurance {
                mCInsuranceIMG.image = pickedImage
                self.insuranceImg = pickedImage
                
            }
            if imagePickStatus == .imageLicense{
                licenseImageView.image = pickedImage
                self.licenseImg = pickedImage
                
            }
            if imagePickStatus == .imageCarPic{
                self.carPicImageView.image = pickedImage
                self.carImg = pickedImage
                
            }
            if imagePickStatus == .imageCarRegistration{
                carRegistrationImageView.image = pickedImage
                self.registrationImg = pickedImage
              
            }
            if imagePickStatus == .imageInspection{
                mCInspectionIMG.image = pickedImage
                self.mInspectionImg = pickedImage
              
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
  
}
////MARK:- Image Picker Delegate
//extension AddVehicleViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate , ImagePickerDelegete {
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
//                  //  imageURLThree = "\(URL(fileURLWithPath: dirPath).appendingPathComponent("name3.jpg"))"
//                }
//                if imagePickStatus == .imageCarRegistration{
//                    carRegistrationImageView.image = self.img
//                    imageURLFour = "\(URL(fileURLWithPath: dirPath).appendingPathComponent("name4.jpg"))"
//                }
//            }
//        }
//    }
//}
extension UIImageView {
    var isEmpty: Bool { image == nil }
}
