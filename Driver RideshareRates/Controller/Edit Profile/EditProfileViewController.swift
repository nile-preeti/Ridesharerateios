//
//  EditProfileViewController.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit
import iOSDropDown
import Alamofire
protocol EditProfileViewControllerDelegate : AnyObject {
    func updateStatus(flag : Bool)
}
class EditProfileViewController: UIViewController {
    //MARK:- OUTLETS
    @IBOutlet weak var insuranceImageView: UIImageView!
    @IBOutlet weak var brandName_txtField: DropDown!
    @IBOutlet weak var selectVehicleModelName_txtField: DropDown!
    @IBOutlet weak var selectYear_txtField: DropDown!
    @IBOutlet weak var notKnow_txtField: DropDown!
    @IBOutlet weak var vehicleNo_txtField: UITextField!
    @IBOutlet weak var vehicleColor_txtField: UITextField!
    weak var updateDelegate: EditProfileViewControllerDelegate?
    //MARK:- Variables
    var vechileDetails : VehicleDetail?
    let conn = webservices()
    var brandData = [BrandDetails]()
    var modelData = [ModelDetails]()
    var vehicleTypeData = [vehicleDetail]()
    var profileDetails : ProfileData?
    var brandId = 0
    var modalId = 0
    var vehicleTypeId = 0
    var imageData : Data?
    var imageName : String?
    var img : UIImage?
    var imageURLOne = ""
    enum imagePic {
        case imageInsurance
    }
    var imagePickStatus =  imagePic.imageInsurance
    lazy var imagePicker :ImagePickerViewControler  = {
        return ImagePickerViewControler()
    }()
    var insuranceImg = UIImage()
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notKnow_txtField.optionArray = ["Select Number of Seats","2","4","6","8"]
        self.setTxtFieldRadius()
        self.setDropDownData()
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.white
        self.navigationItem.title = "Edit Vehicle Details"

        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setData()
      //  self.getVehicleTypeApi()
        self.getBrandsApi()
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func insuranceBtnAction(){
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
    //MARK:-  open camera
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
    //MARK:-  open gallery
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
    //MARK:- User Defined Func
    func setData(){
        self.brandName_txtField.text = self.vechileDetails?.vehicle_type ?? "Select Vehicle Make"
        self.selectVehicleModelName_txtField.text = self.vechileDetails?.model_name ?? "Select Vehicle Model"
        self.selectYear_txtField.text = self.vechileDetails?.year ?? ""
        self.notKnow_txtField.text = self.vechileDetails?.seat_no ?? ""
        self.vehicleNo_txtField.text = self.vechileDetails?.vehicle_no ?? ""
        self.vehicleColor_txtField.text = self.vechileDetails?.color ?? ""
        self.brandId =  Int(self.vechileDetails?.brand_id ?? "") ?? 0
        self.modalId = Int(self.vechileDetails?.model_id ?? "") ?? 0
        self.vehicleTypeId = Int(self.vechileDetails?.vehicle_type ?? "") ?? 0
        self.insuranceImageView.sd_setImage(with:URL(string: self.vechileDetails?.insurance ?? "" ), placeholderImage: nil, completed: nil)
    }
    //MARK:-  set drop down
    func setDropDownData(){
        self.selectYear_txtField.optionArray = ["Select Vehicle Year","2022","2021","2022","2019","2018","2017","2016","2015","2014","2013","2012"]
    }
    //MARK:-  test field setuo
    func setTxtField(textField:UITextField){
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: "green")?.cgColor
    }
    func setTxtFieldRadius(){
        self.setTxtField(textField: brandName_txtField)
        self.setTxtField(textField: self.selectVehicleModelName_txtField)
        self.setTxtField(textField: self.selectYear_txtField)
        self.setTxtField(textField: self.notKnow_txtField)
    }
    //MARK:- Button Action
    @IBAction func tapSubmit_btn(_ sender: UIButton) {
        print(brandId)
        //updateDriverDetails(vehicleID: self.vechileDetails?.vehicle_detail_id ?? "")
        self.updateDriverDetailsPhotoGallary(vehicleID: self.vechileDetails?.vehicle_detail_id ?? "", mediaInsurance: self.insuranceImg)
    }
    @IBAction func tapCancel_btn(_ sender: Any) {
       // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)

    }
}
//MARK:- Web Api
extension EditProfileViewController{
    //MARK:-  get brand api
    func getBrandsApi(){
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetType(getUrlString: "getCategory",authRequired: true) { (Value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                let msg = (Value["message"] as? String ?? "")
                if (Value["status"] as? Int ?? 0) == 1{
                    let data = (Value["data"] as? [[String:Any]])
                    print(data ?? [[]])
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: data as Any, options: .prettyPrinted)
                        self.brandData = try newJSONDecoder().decode(brand.self, from: jsonData)
                        let arr = self.brandData.map({$0.brandName ?? ""})
                        self.brandName_txtField.optionArray = arr
                        self.brandName_txtField.didSelect { (item, index, row) in
                            let brandIdString:String = self.brandData[index].id  ?? ""
                            self.brandId = Int(brandIdString)!
                            self.getModelApi()
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }else{
                    self.showAlert("Driver RideshareRates", message: msg)
                }
            }
        }
    }
    //MARK:-  get model api
    func getModelApi(){
        Indicator.shared.showProgressView(self.view)
        let param = ["category_id":self.brandId]
        
        self.conn.startConnectionWithPostType(getUrlString: "getSubcategory", params: param,authRequired: true) { (Value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                let msg = (Value["message"] as? String ?? "")
                if (Value["status"] as? Int ?? 0) == 1{
                    let data = (Value["data"] as? [[String:Any]])
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: data as Any, options: .prettyPrinted)
                        self.modelData = try newJSONDecoder().decode(model.self, from: jsonData)
                        let arr = self.modelData.map({$0.modelName ?? ""})
                        self.selectVehicleModelName_txtField.optionArray = arr
                        let arrNumber = self.modelData.map({$0.id ?? ""})
                        self.selectVehicleModelName_txtField.didSelect { (item, index, row) in
                            let modalIdString:String = self.modelData[index].id  ?? ""
                            self.modalId = Int(modalIdString)!
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }else{
                    
                    self.showAlert("Driver RideshareRates", message: msg)
                }
            }
        }
    }
    //MARK:-  get vehicle api
    func getVehicleTypeApi(){
        Indicator.shared.showProgressView(self.view)
        let param = ["pickup_address": kPickAddress,
                     "drop_address": kDropAddress]
        print(param)
        self.conn.startConnectionWithPostType(getUrlString: "getVehicleType", params: param,authRequired: true) { (Value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                let msg = (Value["message"] as? String ?? "")
                if (Value["status"] as? Int ?? 0) == 1{
                    let data = (Value["data"] as? [[String:Any]])
                    print(data ?? [[]])
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: data as Any, options: .prettyPrinted)
                        self.vehicleTypeData = try newJSONDecoder().decode(vehicleType.self, from: jsonData)
                        let arr = self.vehicleTypeData.map({$0.title ?? ""})
                        self.notKnow_txtField.optionArray = arr
                        let arrNumber = self.modelData.map({$0.id ?? ""})
                        self.notKnow_txtField.didSelect { (item, index, row) in
                            let vehicleTypeIdString:String = self.vehicleTypeData[index].id  ?? ""
                            self.vehicleTypeId = Int(vehicleTypeIdString)!
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }else{
                    self.showAlert("Driver RideshareRates", message: msg)
                }
            }
        }
    }
    //MARK:- api to update vehicle detail
    func updateDriverDetails(vehicleID : String){
        let param = [ "vehicle_no": self.vehicleNo_txtField.text ?? "" ,
                      "color": self.vehicleColor_txtField.text ?? "" ,
                      "model": modalId ,
                      "brand": brandId,
                      "year":     Int(self.selectYear_txtField.text   ?? "")  ?? 0 ,
                      "vehicle_type": vehicleTypeId ,
                      "car_pic": ""   ,
                      "vehicle_detail_id": vehicleID
        ] as [String : Any]
        print(param)
        self.conn.startConnectionWithPostType(getUrlString: "update_vehicle_detail", params: param,authRequired: true) { (value) in
            print(value)
            let msg = (value["message"] as? String ?? "")
            if ((value["status"] as? Int ?? 0) == 1){
                self.showPopVCAlert(message: msg)
                self.updateDelegate?.updateStatus(flag: true)
            }else{
                self.showAlert("Driver RideshareRates", message: msg)
            }
        }
    }
    //MARK:- update vehicle detail
    func updateDriverDetailsPhotoGallary(vehicleID : String,mediaInsurance :UIImage){
        let param = [ "vehicle_no": self.vehicleNo_txtField.text ?? "" ,
                      "color": self.vehicleColor_txtField.text ?? "" ,
                      "model": modalId ,
                      "brand": brandId,
                      "year":     Int(self.selectYear_txtField.text   ?? "")  ?? 0 ,
                      "vehicle_type": "" ,
                      "car_pic": ""   ,
                      "vehicle_detail_id": vehicleID,
                      "seat_no" : self.notKnow_txtField.text ?? ""
        ] as [String : Any]
        print(param)
        let imageDataInsurance = mediaInsurance.jpegData(compressionQuality: 0.15)
        print("image data\(String(describing: imageData))")
        let url = URL(string: "\(baseurl)update_vehicle_detail")!
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
            for p in param {
                multipartFormData.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
                print("KEY VALUE DATA===========\(p.key)"=="-----+++++----\(p.value)")
            }
        }, to: url, headers: headers)
        .responseJSON { response in
            print("URL AND HEADERS==========\(headers)")
            print(response)
            Indicator.shared.hideProgressView()
            switch (response.result) {
            case .success(let JSON):
                print("JSON: \(JSON)")
                let responseString = JSON as! NSDictionary
                print(responseString)
                let msg = responseString["message"] as? String ?? ""
                if (responseString["status"] as? Int ?? 0) == 1 {
                    self.showAlert("Driver RideshareRates", message: msg)
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
    
    //    func addVechileApi(imageOrVideo : UIImage?,params: [String: Any]){
    //
    //        let headers: HTTPHeaders = [
    //            "Authorization": "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? ""),
    //            "Content-type": "multipart/form-data"]
    //        print(params)
    //        AF.upload(multipartFormData: { multipartFormData in
    //
    //            for (key, value) in params {
    //                if let temp = value as? String {
    //                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
    //                }
    //                if let temp = value as? Int {
    //                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
    //                }
    //                if let temp = value as? NSArray {
    //                    temp.forEach({ element in
    //                        let keyObj = key + "[]"
    //                        if let string = element as? String {
    //                            multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
    //                        } else
    //                        if let num = element as? Int {
    //                            let value = "\(num)"
    //                            multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
    //                        }
    //                    })
    //                }
    //            }
    //
    //            if imageOrVideo != nil{
    //
    //                multipartFormData.append(imageOrVideo!.jpegData(compressionQuality: 0.5)!, withName: "car_pic" , fileName: "file.jpeg", mimeType: "image/jpeg")
    //            }
    //        },
    //
    //        .responseJSON(completionHandler: { (data) in
    //
    //            let d = data.value
    //            let value = (d as? [String:Any] ?? [:])
    //            print(value)
    //            let msg = (value["message"] as? String ?? "")
    //            if (value["status"] as? Int ?? 0) == 1{
    //
    //               
    //                    self.dismiss(animated: true, completion: nil)
    //                }
    //            }else{
    //
    //             
    //            }
    //        })
    //
    //    }
    //MARK:-  popup alert
    func showPopVCAlert(message : String) {
        let alert = UIAlertController(title: "Driver RideshareRates!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }

}

//MARK:- Image Picker Delegate


extension EditProfileViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    
    //MARK:-  image picker 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("calling")
           
            if imagePickStatus == .imageInsurance {
                insuranceImageView.image = pickedImage
                self.insuranceImg = pickedImage
                
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
  
}
//extension EditProfileViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate , ImagePickerDelegete {
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
//
//            }
//        }
//    }
//}
