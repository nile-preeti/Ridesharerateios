//
//  UploadDocVC.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//
import UIKit
import Alamofire

class UploadDocVC: UIViewController {
    @IBOutlet weak var mExpirydateTF: UITextField!
    @IBOutlet weak var mIssueDateTF: UITextField!
    @IBOutlet weak var mTitleLBL: UILabel!
    @IBOutlet weak var carRegistrationImageView: UIImageView!
    var datePicker = UIDatePicker()
    var datePicker2 = UIDatePicker()
    var registrationImg : UIImage?

    var TitleLBL = String()
    var params = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        mTitleLBL.text = "Upload " + TitleLBL + " identification"
        mExpirydateTF.setLeftPaddingPoints(20)
        mIssueDateTF.setLeftPaddingPoints(20)
        mIssueDateTF.delegate = self
        mExpirydateTF.delegate = self

        // Do any additional setup after loading the view.
    }
    //MARK:- show date picker
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
    @IBAction func mSubmitBTN(_ sender: Any) {
        
        if registrationImg == nil{
            
            
            if TitleLBL ==  "Car Registration"{
                self.showAlert("Driver RideshareRates", message: "Please upload the car registration identification image")
            }else if TitleLBL ==  "Driver's License"{
                self.showAlert("Driver RideshareRates", message: "Please upload the driver's license identification image")
                
            }else if TitleLBL ==  "TNC/INSURANCE"{
                self.showAlert("Driver RideshareRates", message: "Please upload the car TNC/INSURANCE identification image")
            }else if TitleLBL ==  "vehicle inspection"{
                self.showAlert("Driver RideshareRates", message: "Please upload the vehicle inspection identification image")
            }
            
          //  self.showAlert("Driver RideshareRates", message: "Please select image")
        }else if mIssueDateTF.text == ""{
            self.showAlert("Driver RideshareRates", message: "Please select issue date")
        }else if mExpirydateTF.text == ""{
            self.showAlert("Driver RideshareRates", message: "Please select expiry date")
        }else{
        
        if TitleLBL ==  "Car Registration"{
            let param = ["car_issue_date": mIssueDateTF.text ?? "","car_expiry_date": mExpirydateTF.text ?? ""] as [String : Any]
            self.updateProfileApi(imageOrVideo: registrationImg!, params: param)
            
        }else if TitleLBL ==  "Driver's License"{
            self.uploadPhotoGallaryNewSignup(media: registrationImg!)
            
            
        }else if TitleLBL ==  "TNC/INSURANCE"{
            let param = ["insurance_issue_date": mIssueDateTF.text ?? "","insurance_expiry_date": mExpirydateTF.text ?? ""] as [String : Any]
            
            self.updateProfileApi(imageOrVideo: registrationImg!, params: param)
            
        }else if TitleLBL ==  "vehicle inspection"{
            let param = ["inspection_issue_date": mIssueDateTF.text ?? "","inspection_expiry_date": mExpirydateTF.text ?? ""] as [String : Any]
            self.updateProfileApi(imageOrVideo: registrationImg!, params: param)
        }
    }
    }
    
    func uploadPhotoGallaryNewSignup(media: UIImage){
        
       // let savedDictionary = UserDefaults.standard.object(forKey: "SavedCurrentLocation") as? [String: Any] ?? [String: Any]()
        //print(savedDictionary)
     //   if TitleLBL ==  "Car Registration"{
            
            
            params["license"] =  media
            params["license_issue_date"] =  mIssueDateTF.text ?? ""
            params["license_expiry_date"] =  mExpirydateTF.text ?? ""
    //    }
        print(params)
        let imageData = media.jpegData(compressionQuality: 0.25)
      

        print("image data\(String(describing: imageData))")
        let url = URL(string: "\(baseurl)upload_document")!
        let headers: HTTPHeaders = [
           // "Content-type": "multipart/form-data",
            "Accept": "application/json",
            "authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as? String ?? "")"
        ]
        
        Indicator.shared.showProgressView(self.view)
        AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageData!,
                                         withName: "license" , fileName: "file.jpg", mimeType: "image/jpeg"
                )
            for p in self.params {
                multipartFormData.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
                print("KEY VALUE DATA===========\(p.key)"=="-----+++++----\(p.value)")
            }
        }, to: url, headers: headers)
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
               
                self.showAlertWithAction(Title: "Driver RideshareRates", Message: msg, ButtonTitle: "Ok") {
                    self.navigationController?.popViewController(animated: true)
                    
                }
             
                break;
            case .failure(let error):
                print(error)
                self.showAlert("Driver RideshareRates", message: "\(error.localizedDescription)")
                break
            }
        }
    }
    
    
    
//    func updateProfileApi(imageOrVideo : UIImage?,params: [String: Any]){
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? ""),
//            "Content-type": "multipart/form-data"
//        ]
//        print(params)
//        AF.upload(multipartFormData: { multipartFormData in
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
//            if imageOrVideo != nil{
//                if self.TitleLBL ==  "Car Registration"{
//                    multipartFormData.append(imageOrVideo!.jpegData(compressionQuality: 0.5)!, withName: "car_registration_doc" , fileName: "file.jpeg", mimeType: "image/jpeg")
//
//                }else if self.TitleLBL ==  "Driving Licence"{
//                    multipartFormData.append(imageOrVideo!.jpegData(compressionQuality: 0.5)!, withName: "license" , fileName: "file.jpeg", mimeType: "image/jpeg")
//
//                }else if self.TitleLBL ==  "Car Insurance"{
//                    multipartFormData.append(imageOrVideo!.jpegData(compressionQuality: 0.5)!, withName: "insurance_doc" , fileName: "file.jpeg", mimeType: "image/jpeg")
//
//                }else if self.TitleLBL ==  "vehicle inspection"{
//                    multipartFormData.append(imageOrVideo!.jpegData(compressionQuality: 0.5)!, withName: "inspection_document" , fileName: "file.jpeg", mimeType: "image/jpeg")
//
//                }
//
//
//            }
//        },
//        .responseJSON(completionHandler: { (data) in
//            let d = data.value
//            let value = (d as? [String:Any] ?? [:])
//            print(value)
//            let msg = (value["message"] as? String ?? "")
//            if (value["status"] as? Int ?? 0) == 1{
//                self.showAlertWithAction(Title: "Driver RideshareRates", Message: msg, ButtonTitle: "Ok")
//                {
//                  //  self.getProfileDataApi()
//                }
//            }else{
//                self.showAlert("Driver RideshareRates", message: msg)
//            }
//        })
//
//    }
    
    
    
    func updateProfileApi(imageOrVideo: UIImage,  params: [String:Any]){
        let imageData = imageOrVideo.jpegData(compressionQuality: 0.25)
        print("image data\(String(describing: imageData))")
        var url = URL(string:"\(baseurl)upload_document")
     
        let headers: HTTPHeaders = [
           // "Content-type": "multipart/form-data",
            "Accept": "application/json",
            "authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as? String ?? "")"
        ]
        Indicator.shared.showProgressView(self.view)
        AF.upload(multipartFormData: { multipartFormData in
            if imageData != nil{
                if self.TitleLBL ==  "Car Registration"{
                    multipartFormData.append(imageOrVideo.jpegData(compressionQuality: 0.5)!, withName: "car_registration" , fileName: "file.jpg", mimeType: "image/jpeg")
                }else if self.TitleLBL ==  "Driver's License"{
                    multipartFormData.append(imageOrVideo.jpegData(compressionQuality: 0.5)!, withName: "license" , fileName: "file.jpg", mimeType: "image/jpeg")
                }else if self.TitleLBL ==  "TNC/INSURANCE"{
                    multipartFormData.append(imageOrVideo.jpegData(compressionQuality: 0.5)!, withName: "insurance" , fileName: "file.jpg", mimeType: "image/jpeg")
                }else if self.TitleLBL ==  "vehicle inspection"{
                    multipartFormData.append(imageOrVideo.jpegData(compressionQuality: 0.5)!, withName: "inspection_document" , fileName: "file.jpg", mimeType: "image/jpeg")
                }
            }
            for p in params{
                multipartFormData.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
                print("KEY VALUE DATA===========\(p.key)"=="-----+++++----\(p.value)")
            }
        }, to: url!, headers: headers)
        .responseJSON { response in
            print("URL \(url) AND HEADERS==========\(headers)")
            print(params)
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
    
    
    
    @IBAction func mUploadIMGBTN(_ sender: Any) {
       
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
    @IBAction func mBackBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension UploadDocVC: UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("calling")
           
            carRegistrationImageView.image = pickedImage
            self.registrationImg = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
  
}
extension UploadDocVC: UITextFieldDelegate{
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
}
