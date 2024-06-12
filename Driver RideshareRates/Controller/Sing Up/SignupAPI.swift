//
//  SignupAPI.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.

import UIKit
import Alamofire

//MARK:- Web Api
extension SignUpViewController{
    func uploadPhotoGallaryNewSignup(media: UIImage  ,mediaIdentity :UIImage ){
        let savedDictionary = UserDefaults.standard.object(forKey: "SavedCurrentLocation") as? [String: Any] ?? [String: Any]()
        //print(savedDictionary)
        params["email"] =  email_txtField.text ?? ""
        params["mobile"] =  mobile_txtField.text ?? ""
        params["country_code"] =  mCountryPTF.text ?? ""
        params["password"] =  password_txtField.text ?? ""
        params["name"] =  name_txtField.text ?? ""
        params["last_name"] =  mLastNameTF.text ?? ""
        params["name_title"] =  mNameTitle.text ?? ""

       
        params["latitude"] =  savedDictionary["latitude"]  ?? Alatitude
        params["longitude"] = savedDictionary["longitude"]  ?? Alongitude
        params["country"] =  savedDictionary["country"] as? String  ?? ""
        params["state"] =  savedDictionary["state"] as? String  ?? ""
        params["city"] =  savedDictionary["city"] as? String  ?? ""
        params["utype"] =  2
        params["year"] =  selectYear_txtField.text ?? ""
        params["vehicle_no"] =  vehicleNo_txtField.text ?? ""
        params["brand"] =  brandIdString
        params["model"] =  modalId
        params["dob"] = mDOBTF.text ?? ""
        params["home_address"] = self.mAddressTF.text ?? ""
      //  "home_address" : homeAddress.text ?? ""
      //  "model":modalId
        params["color"] =  vehicleColor_txtField.text ?? ""
       
//        var deviceID =  UIDevice.current.identifierForVendor?.uuidString
//        print(deviceID)
//      //  params["vehicle_type"] =  vehicleTypeId
        //params["rate"] =  ""
      //  params["permit"] =  ""
//        if selectSeats_txtField.text == "8"{
//            if mTVBTN.currentImage == UIImage(named: "check") || mWIFIBTN.currentImage == UIImage(named: "check") || mLuxurySeatsBTN.currentImage == UIImage(named: "check"){
//                var SeatArray = [String]()
//                if mTVBTN.currentImage == UIImage(named: "check"){
//                    SeatArray.append(" T.V.")
//                }
//                if mWIFIBTN.currentImage == UIImage(named: "check"){
//                    SeatArray.append("Wi-Fi")
//                }
//                if mLuxurySeatsBTN.currentImage == UIImage(named: "check"){
//                    SeatArray.append(" Luxury ")
//                }
//                let pFac = SeatArray.joined(separator: ",")
//                params["premium_facility"] = pFac
//                params["seat_no"] = "9"
//            }else{
//                params["seat_no"] = "8"
//            }
//        }else if selectSeats_txtField.text == "above 8"{
//            params["seat_no"] = "9"
//        }else{
//            params["seat_no"] = selectSeats_txtField.text ?? ""
//        }
        
        params["ssn"] = SSNo_txtField.text ?? ""
//        params["identification_document_id"] = selectedDocID
//        params["identification_issue_date"] = mIssueDateTF.text
//        params["identification_expiry_date"] = mExpirydateTF.text
//        params["car_pic"] =  media
        params["avatar"] =  mediaIdentity
        params["profile_image"] =  mediaIdentity
      //  params["license"] =  mediaLicense
    //    params["insurance"] =  imageURLOne
//        params["license"] =  imageURLTwo
//        params["car_pic"] =  imageURLThree
//        params["car_registration"] =  imageURLFour
        print(params)
        let imageData = media.jpegData(compressionQuality: 0.25)
   //     let imageDataLicence = mediaLicense.jpegData(compressionQuality: 0.25)
        let imageDataIdentity = mediaIdentity.jpegData(compressionQuality: 0.25)
    //    let imageDataRegistration = mediaRegistration.jpegData(compressionQuality: 0.25)

        print("image data\(String(describing: imageData))")
        let url = URL(string: "\(baseurl)register")!
        print(url)
//        let headers: HTTPHeaders = [
//           // "Content-type": "multipart/form-data",
//            "Accept": "application/json",
//            "authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as? String ?? "")"
//        ]
        Indicator.shared.showProgressView(self.view)
        
        AF.upload(multipartFormData: { multipartFormData in
            
            if imageDataIdentity != nil {
                multipartFormData.append(imageDataIdentity!,
                                         withName: "avatar" , fileName: "avatar.jpg", mimeType: "image/jpeg"
                )
            }
//            if imageDataLicence != nil {
//                multipartFormData.append(imageDataLicence!,
//                                         withName: "verification_id" , fileName: "verification_id.jpg", mimeType: "image/jpeg"
//                )
//            }
            if imageData != nil{
                multipartFormData.append(imageData!,
                                         withName: "car_pic" , fileName: "car_pic.jpg", mimeType: "image/jpeg"
                )
            }
            
            for p in self.params {
                multipartFormData.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
                print("KEY VALUE DATA===========\(p.key)"=="-----+++++----\(p.value)")
            }
        }, to: url)
        
        
//        AF.upload(multipartFormData: { multipartFormData in
//                multipartFormData.append(imageDataLicence!,
//                                         withName: "license" , fileName: "license.jpg", mimeType: "image/jpeg"
//                )
//
//            for p in self.params {
//                multipartFormData.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
//                print("KEY VALUE DATA===========\(p.key)"=="-----+++++----\(p.value)")
//            }
//        }, to: url)
//        AF.upload(multipartFormData: { multipartFormData in
//
//                multipartFormData.append(imageData!,
//                                         withName: "car_pic" , fileName: "car_pic.jpg", mimeType: "image/jpeg"
//                )
//
//            for p in self.params {
//                multipartFormData.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
//                print("KEY VALUE DATA===========\(p.key)"=="-----+++++----\(p.value)")
//            }
//        }, to: url)
//        AF.upload(multipartFormData: { multipartFormData in
//                multipartFormData.append(imageDataIdentity!,
//                                         withName: "profile_pic" , fileName: "profile_pic.jpg", mimeType: "image/jpeg"
//                )
//            for p in self.params {
//                multipartFormData.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
//                print("KEY VALUE DATA===========\(p.key)"=="-----+++++----\(p.value)")
//            }
//        }, to: url)
        .responseJSON { response in
          //  print("URL AND HEADERS==========\(headers)")
            print(response)
            Indicator.shared.hideProgressView()
            switch (response.result) {
            case .success(let JSON):
                print("JSON: \(JSON)")
                let responseString = JSON as! NSDictionary
                print(responseString)
                let msg = responseString["message"] as? String ?? ""
                if (responseString["status"] as? Int ?? 0) == 1 {
                    
                    //                    let token = (value["token"] as? String ?? "")
                    //                    let data = (value["data"] as? [String:Any] ?? [:])
                    //                    let userId = (data["user_id"] as? String ?? "")
                    //                    print(data)
                    //                    UserDefaults.standard.setValue(token, forKey: "token")
                    //                    UserDefaults.standard.setValue(userId, forKey: "userId")
                    //   UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    UserDefaults.standard.synchronize()
                    
                   // self.showAlert("Driver RideshareRates", message: "Signup successfully")
                    self.showAlertWithAction(Title: "Driver RideshareRates", Message: "Signup successfully done", ButtonTitle: "OK") {
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                        NSUSERDEFAULT.set(true, forKey: kIsComeFromSignup)
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
    //MARK:- regester api
    func hitSignUpApi(){
        
        let savedDictionary = UserDefaults.standard.object(forKey: "SavedCurrentLocation") as? [String: Any] ?? [String: Any]()
        //print(savedDictionary)
        params["email"] =  email_txtField.text ?? ""
        
        params["mobile"] =  mobile_txtField.text ?? ""
        params["password"] =  password_txtField.text ?? ""
        params["name"] =  name_txtField.text ?? ""
        params["latitude"] =  savedDictionary["latitude"]   ?? 0
        params["longitude"] = savedDictionary["longitude"]   ?? 0
        params["country"] =  savedDictionary["country"] as? String  ?? ""
        params["state"] =  savedDictionary["state"] as? String  ?? ""
        params["city"] =  savedDictionary["city"] as? String  ?? ""
        params["utype"] =  2
        params["gcm_token"] = NSUSERDEFAULT.value(forKey: kFcmToken) as? String ?? ""
        params["year"] =  selectYear_txtField.text ?? ""
        params["vehicle_no"] =  vehicleNo_txtField.text ?? ""
        params["brand"] =  brandIdString
        params["model"] =  modalId
        params["color"] =  vehicleColor_txtField.text ?? ""
        params["vehicle_type"] =  vehicleTypeId
        //params["rate"] =  ""
        params["permit"] =  ""
        params["seat_no"] = selectSeats_txtField.text ?? ""
        params["ssn"] = SSNo_txtField.text ?? ""
        params["insurance"] =  imageURLOne
        params["license"] =  imageURLTwo
      //  params["car_pic"] =  carImg
        params["profile_pic"] =  imageURLFour
   //     params["identification_document_id"] = mDocumentTF.text ?? ""


        print(params)
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "register", params: params) { (value) in
            
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                let msg = (value["message"] as? String ?? "")
                
                if ((value["status"] as? Int ?? 0) == 1){
                    
//                    let token = (value["token"] as? String ?? "")
//                    let data = (value["data"] as? [String:Any] ?? [:])
//                    let userId = (data["user_id"] as? String ?? "")
//                    print(data)
//                    UserDefaults.standard.setValue(token, forKey: "token")
//                    UserDefaults.standard.setValue(userId, forKey: "userId")
                  //  UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    UserDefaults.standard.synchronize()

                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    NSUSERDEFAULT.set(true, forKey: kIsComeFromSignup)
                    
                }else{
                    self.showAlert("Driver RideshareRates", message: msg)
                }
            }
        }
    }
    //MARK:- get brand api
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
               //         let arr = self.brandData.map({$0.brandName ?? ""})
                    
//                        self.selectVehicleCompName_txtField.optionArray = arr
//                        self.selectVehicleCompName_txtField.didSelect { (item, index, row)
//                            in
//
//                            print(index)
//                         //   self.brandId = index
//                            let brandIdString:String = self.brandData[index].id  ?? ""
//                            self.brandId = Int(brandIdString)!
//                            self.getModelApi()
//                        }
                        
                    }catch{
                        
                        print(error.localizedDescription)
                    }
                }else{
                    
                    self.showAlert("Driver RideshareRates", message: "msg")
                }
            }
        }
    }
    
    
    //MARK:- get document identity api
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
                        print(self.brandData)
                        self.mDocumentTF.text = self.docModel[0].document_name
                        self.selectedDocID = self.docModel[0].id!
                        
                    }catch{
                        
                        print(error.localizedDescription)
                    }
                }else{
                    
                    self.showAlert("Driver RideshareRates", message: msg)
                }
            }
        }
    }
    
    
    
    
    
    //MARK:- get vehicle api
    func getVehicleTypeApi(){
        Indicator.shared.showProgressView(self.view)
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
                        print(self.vehicleTypeData)
                        let arr = self.vehicleTypeData.map({$0.title ?? ""})
//                        self.vehicleType_txtField.optionArray = arr
//                        let arrNumber = self.modelData.map({$0.id ?? ""})
//                        print("The Item is here=====\(arrNumber)")
//                        self.vehicleType_txtField.didSelect { (item, index, row) in
//                            print(index)
//                            let vehicleTypeIdString:String = self.vehicleTypeData[index].id  ?? ""
//                            self.vehicleTypeId = Int(vehicleTypeIdString)!
//                            print(self.vehicleTypeId)
//
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
    
}
