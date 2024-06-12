//
//  ProfileAPI.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit
import Alamofire
//MARK:- Web Api

extension ProfileViewController{
    //MARK:- get profile api
    func getProfileDataApi() {
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "get_profile",authRequired: true) { (value) in
            print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                
                print(value)
                if (value["status"] as? Int ?? 0) == 1{
                    let data = (value["data"] as? [String:AnyObject] ?? [:])
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        self.profileDetails = try newJSONDecoder().decode(ProfileData.self, from: jsonData)
                        kProfileName =    self.profileDetails?.name ?? ""
                        kProfileMobile = self.profileDetails?.mobile ?? ""
                        self.setData()
                        self.profileTableView.reloadData()
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    //MARK:- uplade profile api
    func updateProfileApi(imageOrVideo : UIImage?,params: [String: Any]){
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? ""),
            "Content-type": "multipart/form-data"
        ]
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
//                multipartFormData.append(imageOrVideo!.jpegData(compressionQuality: 0.5)!,
//                                         withName: "verification_id" , fileName: "verification_id.jpg", mimeType: "image/jpeg"
//                )
//            }
        },
        to: "\(baseurl)update_profile_of_user", method: .post , headers: headers )
        .responseJSON(completionHandler: { (data) in
            Indicator.shared.hideProgressView()
            let d = data.value
            let value = (d as? [String:Any] ?? [:])
            print(value)
            let msg = (value["message"] as? String ?? "")
            if (value["status"] as? Int ?? 0) == 1{
                self.showAlertWithAction(Title: "Driver RideshareRates", Message: msg, ButtonTitle: "Ok")
                {
                    self.getProfileDataApi()
                }
            }else{
                self.showAlert("Driver RideshareRates", message: msg)
            }
        })
        
    }
//    func uploadPhotozzzzzz( image: UIImage, params: [String : Any]){
//        let headers: HTTPHeaders = [
//            "Content-type": "multipart/form-data",
//            "Accept": "application/json",
//            "authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as? String ?? "")"
//        ]
//        Indicator.shared.showProgressView(self.view)
//        AF.upload(multipartFormData: { multiPart in
//            for p in params {
//                multiPart.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
//            }
//            multiPart.append(image.jpegData(compressionQuality: 0.4)!, withName: "profile_pic", fileName: "profile_pic.jpg", mimeType: "image/jpg")
//        }, to: "https://www.Drive RideshareRates.com/upload_profile_pic", method: .post, headers: headers) .uploadProgress(queue: .main, closure: { progress in
//            print("Upload Progress: \(progress.fractionCompleted)")
//        }).responseJSON(completionHandler: { data in
//            print("upload finished: \(data)")
//            Indicator.shared.hideProgressView()
//            let d = data.value
//            let value = (d as? [String:Any] ?? [:])
//            print(value)
//            let msg = (value["message"] as? String ?? "")
//            if (value["status"] as? Int ?? 0) == 1{
//                self.showAlertWithAction(Title: "Driver RideshareRates", Message: msg, ButtonTitle: "Ok")
//                {
//                    self.getProfileDataApi()
//                }
//            }else{
//                self.showAlert("Driver RideshareRates", message: msg)
//            }
//        }).response { (response) in
//            switch response.result {
//            case .success(let resut):
//                print("upload success result: \(resut)")
//            case .failure(let err):
//                print("upload err: \(err)")
//            }
//        }
//    }
    //MARK:- upload profile pic
    func uploadPhotoGallaryNew(media: UIImage, params: [String:Any]){
        let imageData = media.jpegData(compressionQuality: 0.20)
              print("image data\(String(describing: imageData))")
        let url = URL(string: "\(baseurl)upload_profile_pic")!
        let headers: HTTPHeaders = [
           // "Content-type": "multipart/form-data",
            "Accept": "application/json",
            "authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as? String ?? "")"
        ]
        Indicator.shared.showProgressView(self.view)
        AF.upload(multipartFormData: { multipartFormData in
            
            if imageData != nil{
                multipartFormData.append(imageData!,
                                         withName: "profile_pic" , fileName: "profile_pic.jpg", mimeType: "image/jpeg"
                                     )
            }
          
            for (key, value) in params {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                print("KEY VALUE DATA===========\(key)"=="-----+++++----\(value)")
            }
        }, to: url, headers: headers).responseJSON { response in
            print(url)
            print(headers)
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
                    self.getProfileDataApi()
                 
                }
                else{
                    Indicator.shared.hideProgressView()
                    self.showAlert("Driver RideshareRates", message: msg)
                }
                break;
            case .failure(let error):
                print(error)
                self.showAlert("Driver RideshareRates", message: "\(error.localizedDescription)")
                Indicator.shared.hideProgressView()
                break
            }
        }
    }
//    func uploadPhotoGallaryNew(media: UIImage, params: [String:Any]){
//        let imageData = media.jpegData(compressionQuality: 0.10)
//              print("image data\(String(describing: imageData))")
//        let url = URL(string: "https://www.Drive RideshareRates.com/upload_profile_pic")!
//        let headers: HTTPHeaders = [
//           // "Content-type": "multipart/form-data",
//            "Accept": "application/json",
//            "authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as? String ?? "")"
//        ]
//        Indicator.shared.showProgressView(self.view)
//        AF.upload(multipartFormData: { multipartFormData in
//            multipartFormData.append(imageData!,
//                                     withName: "profile_pic" , fileName: "profile_pic.jpg", mimeType: "image/jpeg"
//                                 )
//            for (key, value) in params {
//                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
//                print("KEY VALUE DATA===========\(key)"=="-----+++++----\(value)")
//            }
//        }, to: url, headers: headers)
//        .responseJSON { response in
//            print("URL AND HEADERS==========\(headers)")
//            print(response)
//            Indicator.shared.hideProgressView()
//            switch (response.result) {
//            case .success(let JSON):
//                print("JSON: \(JSON)")
//                let responseString = JSON as! NSDictionary
//                print(responseString)
//                let msg = responseString["message"] as? String ?? ""
//                if (responseString["status"] as? Int ?? 0) == 1 {
//                    self.showAlert("Driver RideshareRates", message: msg)
//                }
//                else{
//                    self.showAlert("Driver RideshareRates", message: msg)
//                }
//                break;
//            case .failure(let error):
//                print(error)
//                self.showAlert("Driver RideshareRates", message: "\(error.localizedDescription)")
//                break
//            }
//        }
//
//    }
    //MARK:- update user's profile pic
    func uploadDocImg(media: UIImage, params: [String:Any]){
        let imageData = media.jpegData(compressionQuality: 0.10)
              print("image data\(String(describing: imageData))")
        let url = URL(string: "\(baseurl)update_profile_of_user")!
        let headers: HTTPHeaders = [
           // "Content-type": "multipart/form-data",
            "Accept": "application/json",
            "authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as? String ?? "")"
        ]
        Indicator.shared.showProgressView(self.view)
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData!,
                                     withName: "verification_id" , fileName: "verification_id.jpg", mimeType: "image/jpeg"
            )
            for (key, value) in params {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                print("KEY VALUE DATA===========\(key)"=="-----+++++----\(value)")
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
    //MARK:- update vehicle status api 
    func activeInactiveVehicleApi(vehicleId : String ,activeInactiveStatus : String){
        
        let param = ["vehicle_detail_id": vehicleId  , "status" :  activeInactiveStatus] as [String : Any]
        print(param)
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "update_vehicle_status", params: param ,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                self.profileTableView.reloadData()
                let msg = (value["message"] as? String ?? "")
                
                if ((value["status"] as? Int ?? 0) == 1){

                    self.showAlert("Driver RideshareRates", message: msg)
                    self.profileTableView.reloadData()

                   
                  //  self.showToast(message: msg)
                    //                    if activeInactiveStatus == true {
                    //                        self.showToast(message: "Vehicle Is Active")
                    //                    }
                    //                    else{
                    //                        self.showToast(message: "Vehicle Is InActive")
                    //
                    //                    }
                }else{
                   self.showToast(message: msg)
                }
            }
        }
    }
}
