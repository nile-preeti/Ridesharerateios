//
//  HomeAPI.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit
import CoreLocation
import Alamofire
import GoogleMaps
import CoreLocation
extension HomeViewController {
    //MARK:- mark payment recived api
    func markReceivedApi(rideId : String,updateDriverStatus :String){
        let param = ["ride_id":rideId,"driver_status": updateDriverStatus]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "payment_as_recieved", params: param,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            print("Updating Driver Online Status Data Api  \(value)")
            let msg = (value["message"] as? String ?? "")
            if ((value["status"] as? Int ?? 0) == 1){
                self.showToast(message: "Payment received in cash")
                self.paymentView.isHidden = true
            }else{
                self.showAlert("Driver RideshareRates", message: msg)
            }
        }
    }
    func updateCurrentLocation(lat: String?, long: String? ){
        let param = ["latitude":lat,"longitude": long]
      //  Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "driverCurrentLocation", params: param,authRequired: true) { (value) in
           // Indicator.shared.hideProgressView()
         //   print("Updating Driver Online Status Data Api  \(value)")
            let msg = (value["message"] as? String ?? "")
            if ((value["status"] as? Int ?? 0) == 1){
//                self.showToast(message: "Payment received in cash")
//                self.paymentView.isHidden = true
            }else{
                self.showAlert("Driver RideshareRates", message: msg)
            }
        }
    }
    //MARK:-  get earning
    func getearning(){
      //  Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "earn?year=2024",authRequired: true) { (value) in
            print(value)
          //  Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                let amount = value["current_day_earning"] as? String
                var totalAmount  = " " + String(amount ?? "0" )
                self.mTotalEarning.setTitle(totalAmount as! String, for: .normal)
            }
        }
    }
    //MARK:-  update status
    func updateStatus(updateStatus : String){
        let param = ["is_online":updateStatus]
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "update_driver_status", params: param,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            print("Updating Driver Status Data Api  \(value)")
            let msg = (value["message"] as? String ?? "")
            if ((value["status"] as? Int ?? 0) == 1){
             //   self.mOnoffToggalBTN.setTitle("online", for: .normal)
                if updateStatus == "1"{
                    if self.selectServicesStatus == .isSelected
                    {
                        self.getSelectServicesApi()
                        self.ServicesView.isHidden = false
                        NSUSERDEFAULT.set("yes", forKey: checknotifi)
                    }else{
                        self.arrSelectedRowsStatus.removeAll()
                        self.servicesList.reloadData()
                        self.ServicesView.isHidden = true
                    }
                    NSUSERDEFAULT.set(("online"), forKey: KOnOffStatus)
                    
                }else if updateStatus == "3"{
                    NSUSERDEFAULT.set(("offline"), forKey: KOnOffStatus)
                }
                if self.Doc_Pend != "yes"{
                    self.mDocumentPendingView.isHidden = true
                }
                self.toggalBTN = ""
                self.updateDriverLocation(lat: kCurrentLocaLat, long: kCurrentLocaLong)
               // self.updateDriverLocation(lat: "44.4942892", long: "-73.19008699999999")
                if self.selectServicesStatus == .isSelected {
                    self.showToast(message: "Hello Boss! BUSINESS CASUAL ATTIRE ONLY \n You're now LIVE!")
                }
                let total_working_hour = (value["total_working_hour"] as? Int ?? 0)
              //  self.settime(secTime: total_working_hour)
            }else{
//                let total_working_hour = (value["total_working_hour"] as? Int ?? 0)
//                self.settime(secTime: total_working_hour)
//                
//                self.toggalBTN = msg
//                if self.Doc_Pend != "yes"{
//                    self.mDocumentPendingView.isHidden = false
//                }
//                self.offline()
//                self.showAlert("Driver RideshareRates", message: msg)
            }
        }
    }
    //MARK:-  set timer in side menu
    func settime(secTime:Int){
        if  secTime > 43200{
            print("12 hour done")
            NSUSERDEFAULT.set((43200), forKey: Ktimer)
            if my_switch.isOn == true{
                self.updateStatus(updateStatus: "3")
            }
        }else{
            NSUSERDEFAULT.set((secTime), forKey: Ktimer)
        }
//        if secTime > 61200{
//            logoutt()
//        }
       
    }
    
//     func checkdevicetokenAPI(){
//        self.conn.startConnectionWithPostType(getUrlString: "checkdevicetoken", params: ["":""], authRequired: true) { (value) in
//            Indicator.shared.hideProgressView()
//            if self.conn.responseCode == 1{
//                print(value)
//               // let device_type = (value["device_type"] as? String ?? "")
//                let device_token = (value["device_token"] as? String ?? "")
//                let deviceID =  UIDevice.current.identifierForVendor?.uuidString
//                if device_token != deviceID{
//                    NavigationManager.pushToLoginVC(from: self)
//                }
//            }
//        }
//    }
    
    //MARK:- get approval document status
    func getdocumentaApi() {
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "get_approval_document_status",authRequired: true) { (value) in
            print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                if ((value["data"] as? [String:Any]) != nil){
                    var model = [String:Any]()
                    model = value["data"] as! [String : Any]
                    if model["car_registration_approve_status"] as? String == "1" {
                        self.arr[0] = "Approved"
                    }
                    if model["license_approve_status"] as? String == "1"{
                        self.arr[1] = "Approved"
                    }
                    if model["insurance_approve_status"] as? String == "1" {
                        self.arr[2] = "Approved"
                    }
                    if model["inspection_approval_status"] as? String == "1" {
                        self.arr[5] = "Approved"
                    }
                    if model["car_expiry"] as? Bool == true{
                        self.arr[0] = "Expired"
                    }
                    if model["license_expiry"] as? Bool == true{
                        self.arr[1] = "Expired"
                    }
                    if model["insurance_expiry"] as? Bool == true{
                        self.arr[2] = "Expired"
                    }
                    if model["identification_expiry"] as? Bool == true{
                        self.arr[3] = "Expired"
                    }else{
                        self.arr[3] = "Approved"
                    }
                    if model["inspection_expiry"] as? Bool == true{
                        self.arr[4] = "Expired"
                    }
                }
                if value["background_approval_status"] as? String == "1" {
                    self.arr[4] = "Approved"
                }
              //  self.mTableV.reloadData()
                if self.arr.contains("Pending"){
                    self.Doc_Pend = "yes"
                    self.mDocumentPendingView.isHidden = false
                    self.updateStatus(updateStatus: "3")
                    self.offline()
                }else{
                    self.Doc_Pend = ""
                    self.mDocumentPendingView.isHidden = true
                }
                if self.arr.contains("Expired"){
                    self.Doc_Exp = "yes"
                    self.updateStatus(updateStatus: "3")
                    self.offline()
                    self.mactionRLBL.text = "Upload required docs to go online."
                    self.mExpireVehicle.isHidden = false
                }else{
                    self.Doc_Exp = ""
                    self.mExpireVehicle.isHidden = true
                }
                
                
            }
        }
    }
    //MARK:-  make driver offline
    func offline(){
        print("Offline")
        // sender.backgroundColor = UIColor.red
        NSUSERDEFAULT.set("3", forKey: kUpdateDriveStatus)
        offlineOnlineLabel.text = "Offline"
        onOffStatus = onOff.offline
        my_switch.tintColor = UIColor.red
        offlineOnlineBtn.setTitle("Offline", for: .normal)
        offlineOnlineBtn.backgroundColor = UIColor.red
        my_switch.isOn = false
        selectServicesStatus = .isNotSelected
        // self.updateStatus(updateStatus: "3")
        UIApplication.shared.isIdleTimerDisabled = false
    }
//    {
//        print( "The switch is now false!" )
//        NSUSERDEFAULT.set("3", forKey: kUpdateDriveStatus)
//        offlineOnlineLabel.text = "Offline"
//        onOffStatus = onOff.offline
//        my_switch.onTintColor = UIColor.clear
//        offlineOnlineBtn.setTitle("Offline", for: .normal)
//        offlineOnlineBtn.backgroundColor = UIColor.red
//        selectServicesStatus = .isNotSelected
//        self.updateStatus(updateStatus: "3")
//        UIApplication.shared.isIdleTimerDisabled = false
//    }
    
//    func timeGapBetweenDates(previousDate : String,currentDate1 : String)
//    {
//        if previousDate != "" && currentDate1 != ""{
//            let dateString1 = previousDate
//            let dateString2 = currentDate1
//            let Dateformatter = DateFormatter()
//            Dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            let date1 = Dateformatter.date(from: dateString1)
//            let date2 = Dateformatter.date(from: dateString2)
//            let distanceBetweenDates: TimeInterval? = date2?.timeIntervalSince(date1!)
//            let secBetweenDates = Int((distanceBetweenDates! / 1))
//            if  secBetweenDates > 43200{
//                print("12 hour done")
//                if my_switch.isOn == true{
//                    self.updateStatus(updateStatus: "3")
//                }
//            }
//            if secBetweenDates > 61200{
//              //  logoutt()
//            }
//            NSUSERDEFAULT.set((secBetweenDates), forKey: Ktimer)
//        }
//
//    }
    //MARK:-  logout api
    func logoutt(){
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "logout", params: [String : String](), authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                NavigationManager.pushToLoginVC(from: self)
            }
        }
    }
//    //MARK:- offline user
//    func logO(){
//        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
//        if let appDomain = Bundle.main.bundleIdentifier {
//            UserDefaults.standard.removePersistentDomain(forName: appDomain)
//        }
//        UserDefaults.standard.synchronize()
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
//        NavigationManager.pushToLoginVC(from: self)
////
//    }
    
    //MARK:-  accept reject ride api
    func start(confirmStatus : String , acceptRejectView : acceptReject){
        print("ACCEPT REJECT API")
        let param = [ "ride_id" : self.lastRideData?.ride_id  ?? "","status" : kConfirmationStatus, "location_status" : "YES","waitingtime" : self.count] as [String : Any]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "accept_ride", params: param,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            print(value)
            let msg = (value["message"] as? String ?? "")
            if ((value["status"] as? Int ?? 0) == 1){
               
                //  kNotificationAction = ""
                if kConfirmationStatus == "CANCELLED"{
                    self.confirmationView.isHidden = true
                    self.showToast(message: msg)
                }
                else if kConfirmationStatus == "START_RIDE"{
                    self.getLastRideDataApi()
                   // self.offlineOnlineBtn.isUserInteractionEnabled = false
                 //   self.my_switch.isUserInteractionEnabled = false
                }
                else if kConfirmationStatus == "COMPLETED"{
                 //   self.offlineOnlineBtn.isUserInteractionEnabled = false
                 //   self.my_switch.isUserInteractionEnabled = false
                    self.confirmationView.isHidden = true
                //    self.updateStatus(updateStatus: "3")
                    self.showToast(message: msg)
                    self.getLastRideDataApi()
                }
                else{
                    self.getLastRideDataApi()
                    self.confirmationView.isHidden = false
                    self.paymentView.isHidden = true
                    self.showToast(message: msg)
                }
            }else{
                self.showAlert("Driver RideshareRates", message: msg)
            }
        }
    }
    //MARK:-  accept reject ride api
    func acceptRejectStatus(confirmStatus : String , acceptRejectView : acceptReject){
        print("ACCEPT REJECT API")
        let param = [ "ride_id" : self.lastRideData?.ride_id  ?? "","status" : kConfirmationStatus]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "accept_ride", params: param,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            print(value)
            let msg = (value["message"] as? String ?? "")
            if ((value["status"] as? Int ?? 0) == 1){
               
                //  kNotificationAction = ""
                if kConfirmationStatus == "CANCELLED"{
                    self.confirmationView.isHidden = true
                    self.showToast(message: msg)
                }
                else if kConfirmationStatus == "START_RIDE"{
                    self.getLastRideDataApi()
                   // self.offlineOnlineBtn.isUserInteractionEnabled = false
                 //   self.my_switch.isUserInteractionEnabled = false
                }
                else if kConfirmationStatus == "COMPLETED"{
                 //   self.offlineOnlineBtn.isUserInteractionEnabled = false
                 //   self.my_switch.isUserInteractionEnabled = false
                    self.confirmationView.isHidden = true
                //    self.updateStatus(updateStatus: "3")
                    self.showToast(message: msg)
                    self.getLastRideDataApi()
                }
                else{
                    self.getLastRideDataApi()
                    self.confirmationView.isHidden = false
                    self.paymentView.isHidden = true
                    self.showToast(message: msg)
                }
            }else{
                self.showAlert("Driver RideshareRates", message: msg)
            }
        }
    }
    
    
    //MARK:-  accept reject ride api
    func Reachedapi(status: String,location_status : String){
        print("ACCEPT REJECT API")
        let param = [ "ride_id" : self.lastRideData?.ride_id  ?? "","status" : status, "location_status" : location_status]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "accept_ride", params: param,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            print(value)
            let msg = (value["message"] as? String ?? "")
            if ((value["status"] as? Int ?? 0) == 1){
            
                if status == "ACCEPTED"{
                    self.reachedatpickup.isHidden = true

                }else{
                    self.reachedatdropBTN.isHidden = true

                }
                
                //  kNotificationAction = ""
                if kConfirmationStatus == "CANCELLED"{
                    self.confirmationView.isHidden = true
                    self.showToast(message: msg)
                }
                else if kConfirmationStatus == "START_RIDE"{
                    
                    self.getLastRideDataApi()
                   // self.offlineOnlineBtn.isUserInteractionEnabled = false
                 //   self.my_switch.isUserInteractionEnabled = false
                }
                else if kConfirmationStatus == "COMPLETED"{
                 //   self.offlineOnlineBtn.isUserInteractionEnabled = false
                 //   self.my_switch.isUserInteractionEnabled = false
                    self.confirmationView.isHidden = true
                //    self.updateStatus(updateStatus: "3")
                    self.showToast(message: msg)
                    self.getLastRideDataApi()
                }
                else{
                    self.getLastRideDataApi()
                    self.confirmationView.isHidden = false
                    self.paymentView.isHidden = true
                    self.showToast(message: msg)
                }
            }else{
                self.showAlert("Driver RideshareRates", message: msg)
            }
        }
    }
    
    
    //MARK:-  accept reject ride api
    func Reachedatstop(status: String,location_status : String){
        print("ACCEPT REJECT API")
        let param = [ "ride_id" : self.lastRideData?.ride_id  ?? "","status" : status, "location_status" : location_status, "stop_id" : self.lastRideData?.Stops![0].stop_id ] as! [String: String]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "accept_ride", params: param,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            print(value)
            let msg = (value["message"] as? String ?? "")
            if ((value["status"] as? Int ?? 0) == 1){
            
                self.getLastRideDataApi()
            }else{
                self.showAlert("Driver RideshareRates", message: msg)
            }
        }
    }
    
    
    //MARK:- cancel ride api
    func cancelRideStatus(rideId : String){
        print("CANCEL RIDE API")
        kRequestStatus = ""
        let param = [ "ride_id" : rideId ,"status" : "CANCELLED"]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "accept_ride", params: param,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            print(value)
            let msg = (value["message"] as? String ?? "")
            if ((value["status"] as? Int ?? 0) == 1){
              
                kNotificationAction = ""
                kConfirmationAction = ""
                kRequestStatus = ""
                kRideId = ""
                self.confirmationView.isHidden = true
                self.servicesList.reloadData()
                self.getLastRideDataApi()
                self.showToast(message: msg)
            }else{
                self.showAlert("Driver RideshareRates", message: msg)
            }
            
        }
        
    }
    //MARK:-  get ride status
//    func getRideStatus(ride_id : String){
//        let param = ["ride_id": ride_id]
//        print(param)
//        Indicator.shared.showProgressView(self.view)
//        self.conn.startConnectionWithPostType(getUrlString: "get_ride_status", params: param,authRequired: true) { (value) in
//            print("getRideStatus data \(value)")
//            Indicator.shared.hideProgressView()
//            if self.conn.responseCode == 1{
//                // print(value)
//                let msg = (value["message"] as? String ?? "")
//                if ((value["status"] as? Int ?? 0) == 1){
//                    if let body = (value as? [String:Any])?["data"] as? [String:Any] {
//                        do {
//                            let jsondata = try JSONSerialization.data(withJSONObject: body , options: .prettyPrinted)
//                            let encodedJson = try JSONDecoder().decode(userCustomerModal.self, from: jsondata)
//                            self.customerData = encodedJson
//                            self.confirmationView.isHidden = false
//                            kPickAddress = self.customerData?.pickup_adress  ?? ""
//                            kDropAddress = self.customerData?.drop_address  ?? ""
//                            let pickLat = self.customerData?.pickup_lat  ?? ""
//                            let pickLong = self.customerData?.pickup_long  ?? ""
//
//                            let dropLat = self.customerData?.drop_lat  ?? ""
//                            let dropLong = self.customerData?.drop_long  ?? ""
//                            kDestinationLatLong = "\(dropLat)" + "," + "\(dropLong)"
//                            kCustomerMobile = self.customerData?.mobile  ?? ""
//                            kDistanceInMiles = self.customerData?.distance  ?? ""
//                            kRidername = self.customerData?.user_name  ?? ""
//                            self.totalFareLbl.text =    "$" + "\(self.customerData?.total_amount ?? "")"
//                            let firsLocation = CLLocation(latitude:pickLat.toDouble() ?? 0.0, longitude:pickLong.toDouble() ?? 0.0)
//                            let secondLocation = CLLocation(latitude: dropLat.toDouble() ?? 0.0, longitude: dropLong.toDouble() ?? 0.0)
//                            // let distance = firsLocation.distance(from: secondLocation) / 1000
//                            let distance = firsLocation.distance(from: secondLocation) * 0.000621371
//                            print(distance)
//                            let roundedValue = round(distance * 10) / 10.0
//                            print(roundedValue)
//                            self.totalDistanceLbl.text = "\(roundedValue)" + " Miles"
//                            self.mUserNAme.text = "Rider: " + kRidername
//                            self.fromAddressLbl.text = self.customerData?.pickup_adress  ?? ""
//                            self.toAddressLbl.text = self.customerData?.drop_address  ?? ""
//
//                            kConfirmationAction =  self.customerData?.ride_status  ?? ""
//                            print(kConfirmationAction)
//                            if kNotificationAction == "START_RIDE" || kConfirmationAction == "START_RIDE"{
//                                self.confirmationView.isHidden = false
//                                self.startRideView.isHidden = true
//                                self.accptRejectView.isHidden = true
//                                self.recordView.isHidden = false
//                            }
//                            else if kNotificationAction == "ACCEPTED" || kConfirmationAction ==  "ACCEPTED"{
//
//                                self.accptRejectView.isHidden = true
//                                self.startRideView.isHidden = false
//                                self.recordView.isHidden = true
//                            }
//                            else if kNotificationAction == "CANCELLED" || kConfirmationAction  ==  "CANCELLED"{
//                                self.startRideView.isHidden = true
//                                self.accptRejectView.isHidden = true
//                                self.confirmationView.isHidden = true
//                                self.recordView.isHidden = true
//                            }
//                            else if kNotificationAction == "COMPLETED" || kConfirmationAction  == "COMPLETED"{
//                                self.confirmationView.isHidden = true
//                                kNotificationAction = ""
//                                kConfirmationAction = ""
//                                kRideId = ""
//                            }
//                            else {
//                                print("hmm")
//                            }
//
//                        }catch {
//                            print(false, error.localizedDescription)
//                        }
//                    }
//                }else{
//                    self.showAlert("Driver RideshareRates", message: msg)
//                }
//            }
//        }
//    }
    //MARK:-  update driver lat long
    func updateDriverLocation(lat : String,long : String){
        if lat == "" && long == ""{
            //  self.showAlert("Location Permission Required", message: "Please enable location permissions in settings.")
        }
        else{
            let param = ["lat": lat , "long" : long]
            print(param)
            Indicator.shared.showProgressView(self.view)
            self.conn.startConnectionWithPostType(getUrlString: "update_lat_long", params: param,authRequired: true) { (value) in
                Indicator.shared.hideProgressView()
                print(value)
                let msg = (value["message"] as? String ?? "")
                DispatchQueue.main.async {
                    if self.conn.responseCode == 1{
                        // print(value)
                        if ((value["status"] as? Int ?? 0) == 1){
                            if let body = (value as? [String:Any])?["data"] as? [String:Any] {
                                
                            }
                        }else{
                            self.showToast(message: msg)
                        }
                    }
                    else{
                        guard let stat = value["Error"] as? String, stat == "ok" else {
                           
                            return
                        }
                    }
                }
            }
        }
        
    }
    //MARK:-  change ride status
    
    func changeRideStatus(rideId : String,status : String){
        let param = ["ride_id": rideId , "status" : status]
        print(param)
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "change_ride_status", params: param,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            print(value)
            let msg = (value["message"] as? String ?? "")
            if self.conn.responseCode == 1{
                // print(value)
                if ((value["status"] as? Int ?? 0) == 1){
                    if let body = (value as? [String:Any])?["data"] as? [String:Any] {

                    }
                }
                else{
                    self.showToast(message: msg)
                }
            }
        }
    }
    //MARK:- pending ride api
    
    func pendingRequestApi(){
        Indicator.shared.showProgressView(self.view)
        let url = "api/user/rides?status=PENDING"   
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: url,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            let msg = (value["message"] as? String ?? "")
            if self.conn.responseCode == 1{
                
                if (value["status"] as? Int ?? 0) == 1{
                    let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                    
                    if data.count == 0{
                        self.pendingLastRideStatus = true
                        self.getLastRideDataApi()
                    }else{
                        self.getLastRideDataApi()
                    }
//                    else{
//                        print("Pending API Data=== \(value)")
//                        for items in data {
//                            if  let dataId = items["ride_id"] as? String{
//                                self.pendingRideId = dataId
//                                kRideId = dataId
//                                let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
//                                do{
//                                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
//                                    self.pendingReqData = try newJSONDecoder().decode(rides.self, from: jsonData)
//                                    kRideId = self.pendingReqData.first?.rideID  ?? ""
//                                 //   self.confirmationView.isHidden = false
//                                    
//                                    kPickAddress = self.pendingReqData.first?.pickupAdress  ?? ""
//                                    kDropAddress = self.pendingReqData.first?.dropAddress  ?? ""
//                                    let pickLat = self.pendingReqData.first?.pickupLat  ?? ""
//                                    let pickLong = self.pendingReqData.first?.pickupLong  ?? ""
//                                    
//                                    let dropLat = self.pendingReqData.first?.dropLat  ?? ""
//                                    let dropLong = self.pendingReqData.first?.dropLong  ?? ""
//                                    kDestinationLatLong = "\(dropLat)" + "," + "\(dropLong)"
//                                    kDistanceInMiles = self.pendingReqData.first?.distance  ?? ""
//                                    
//                                    self.totalFareLbl.text =    "$" + "\(self.pendingReqData.first?.amount ?? "")"
//                                    self.totalDistanceLbl.text =   "\(self.pendingReqData.first?.distance  ?? "" )" + " " + "Miles"
//                                    self.mUserNAme.text = "Rider: " + kRidername
//                                    self.fromAddressLbl.text = self.pendingReqData.first?.pickupAdress  ?? ""
//                                    self.toAddressLbl.text = self.pendingReqData.first?.dropAddress  ?? ""
//                                    kRequestStatus = self.pendingReqData.first?.status  ?? ""
//                                    
//                                    if kNotificationAction == "START_RIDE" || kConfirmationAction == "START_RIDE"{
//                                        self.mStartRideeBTN.isHidden = true
//                                        self.mGoBTN.isHidden = false
//                                        self.confirmationView.isHidden = false
//                                        self.paymentView.isHidden = true
//                                        self.startRideView.isHidden = true
//                                        self.accptRejectView.isHidden = true
//                                        self.recordView.isHidden = false
//                                        self.offlineOnlineBtn.isUserInteractionEnabled = false
//                                            //self.my_switch.isUserInteractionEnabled = false
//                                    }
//                                    else if kNotificationAction == "ACCEPTED" || kConfirmationAction ==  "ACCEPTED"{
//                                        self.accptRejectView.isHidden = true
//                                        self.startRideView.isHidden = false
//                                        self.recordView.isHidden = true
//                                        let apiKey = "AIzaSyByga05rgV6dTqTnpBcR0HFiSbWoSxp_3s"
//                                        DispatchQueue.main.async {
//                                            let savedDictionary = UserDefaults.standard.object(forKey: "SavedCurrentLocation") as? [String: Any] ?? [String: Any]()
//                                            self.getDistanceAndDuration(from: savedDictionary["address2"] as? String  ?? "", to: (self.lastRideData?.pickup_adress)! , apiKey: apiKey)
//                                        }
//                                    }
//                                    
//                                    else if kNotificationAction == "COMPLETED" || kConfirmationAction  == "COMPLETED"{
//                                        let pendingPaymentStatusData = self.pendingReqData.first?.paymentStatus  ?? ""
//                                        
//                                        if  pendingPaymentStatusData ==  "COMPLETED"{
//                                            self.startRideView.isHidden = true
//                                            self.accptRejectView.isHidden = true
//                                            self.confirmationView.isHidden = true
//                                            self.recordView.isHidden = true
//                                            kNotificationAction = ""
//                                            kConfirmationAction = ""
//                                            kRideId = ""
//                                            self.paymentView.isHidden = true
//                                            self.amountLblFinal.text =   "$" + " " + "\(self.lastRideData?.total_amount  ?? "")"  + " " + "Amount is Received"
//                                            self.ServicesView.isHidden = true
//                                        }
//                                        else{
//                                            kNotificationAction = ""
//                                            kConfirmationAction = ""
//                                            self.confirmationView.isHidden = true
//                                            self.paymentView.isHidden = false
//                                            self.offlineOnlineBtn.isUserInteractionEnabled = false
//                                          //  self.my_switch.isUserInteractionEnabled = false
//                                            self.amountLblFinal.text =   "$" + "\(self.lastRideData?.total_amount  ?? "")"  + " " + "Amount is Pending"
//                                            self.ServicesView.isHidden = true
//
//                                        }
//                                    }
//                                    else if kNotificationAction == "FAILED" || kConfirmationAction  == "FAILED"{
//                                        self.confirmationView.isHidden = true
//                                        kNotificationAction = ""
//                                        kConfirmationAction = ""
//                                        kRideId = ""
//                                    }
//                                    else if kNotificationAction == "PENDING" || kConfirmationAction  == "PENDING" || kRequestStatus == "PENDING"{
//                                        if   self.appMovedToForegroundStatus == true {
//                                            if self.offlineOnlineLabel.text == "Online"{
//                                                print("appMovedToForegroundTrue")
//                                                
//                                                
//                                                self.showAlert("Driver RideshareRates", message: "NO MINORS ALLOWED TO RIDE WITHOUT AN ADULT")
//                                                self.confirmationView.isHidden = false
//                                                self.paymentView.isHidden = true
//                                                self.accptRejectView.isHidden = false
//                                                self.startRideView.isHidden = true
//                                                self.recordView.isHidden = true
//                                                self.appMovedToForegroundStatus = false
//                                                
//                                                self.startProgressAndAPIRequest()
////                                                self.timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(self.startTimer(_:)), userInfo: nil, repeats: true)
////                                                self.progressView.setAnimatedProgress(duration: 20) {
////                                                    print("Done!")
////                                                }
//                                            }else{
//                                                self.startRideView.isHidden = true
//                                                self.accptRejectView.isHidden = true
//                                                self.confirmationView.isHidden = true
//                                                self.recordView.isHidden = true
//                                                kNotificationAction = ""
//                                                kConfirmationAction = ""
//                                                kRideId = ""
//                                                self.paymentView.isHidden = true
//                                            }
//                                        }
//                                    }
//                                    else if kNotificationAction == "NOT_CONFIRMED" || kConfirmationAction  == "NOT_CONFIRMED" || kRequestStatus == "NOT_CONFIRMED"{
//                                        if self.offlineOnlineLabel.text == "Online"{
//                                            self.showAlert("Driver RideshareRates", message: "NO MINORS ALLOWED TO RIDE WITHOUT AN ADULT")
//                                            self.confirmationView.isHidden = false
//                                            self.paymentView.isHidden = true
//                                            self.accptRejectView.isHidden = false
//                                            self.startRideView.isHidden = true
//                                            self.recordView.isHidden = true
//                                            
//                                            self.startProgressAndAPIRequest()
//                                        }else{
//                                            self.startRideView.isHidden = true
//                                            self.accptRejectView.isHidden = true
//                                            self.confirmationView.isHidden = true
//                                            self.recordView.isHidden = true
//                                            kNotificationAction = ""
//                                            kConfirmationAction = ""
//                                            kRideId = ""
//                                            self.paymentView.isHidden = true
//                                        }
//                                        
//                                    }
//                                    
//                                    else if kNotificationAction == "CANCELLED" || kConfirmationAction  ==  "CANCELLED"{
//                                        self.mStartRideeBTN.isHidden = true
//                                        self.mGoBTN.isHidden = false
//                                       // self.Dalert.dismiss(animated: true, completion: nil)
//                                        self.startRideView.isHidden = true
//                                        self.accptRejectView.isHidden = true
//                                        self.confirmationView.isHidden = true
//                                        self.recordView.isHidden = true
//                                    }
//                                      else {
//                                        print("hmm")
//                                        self.confirmationView.isHidden = true
//                                        self.accptRejectView.isHidden = true
//                                        self.startRideView.isHidden = true
//                                        self.recordView.isHidden = true
//                                    }
//                                }catch{
//                                    print(error.localizedDescription)
//                                }
//                                // self.getRideStatus(ride_id:dataId)
//                            }
//                        }
//                    }
                }
            }
            else{
                print("No Ride Available")
                guard let stat = value["Error"] as? String, stat == "ok" else {
                    //  self.showToast(message: "\(String(describing: stat))")
                    return
                }
            }
        }
    }
    func distance(){
        let savedDictionary = UserDefaults.standard.object(forKey: "SavedCurrentLocation") as? [String: Any] ?? [String: Any]()
//        let currentlat = savedDictionary["latitude"] as? String
//        let currentlong = savedDictionary["longitude"] as? String
        let currentlat = NSUSERDEFAULT.value(forKey: kCurrentLat)
        let currentlong =  NSUSERDEFAULT.value(forKey: kCurrentLong)
        var drop_lat = String()
        var drop_long = String()
        if atpickupordrop == "pickup"{
            drop_lat = (self.lastRideData?.pickup_lat)!
            drop_long = (self.lastRideData?.pickup_long)!
            
        }else if atpickupordrop == "drop"{
            drop_lat = (self.lastRideData?.drop_lat)!
            drop_long = (self.lastRideData?.drop_long)!
        }
        
        
        let param = ["pickup_lat":currentlat as! String , "pickup_long":currentlong as! String , "drop_lat": drop_lat as! String, "drop_long": drop_long as! String]
        print(param)
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "driver_location", params: param as [String : String], authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
               // let status = (value["status"] as? String ?? "")
                if (value["status"] as? Int ?? 0) == 1{
                    let distance =  value["distance"] as? Double ?? 0.0
                    if distance <= 0.25{
                        
                        if self.atpickupordrop == "pickup" {
                            self.Reachedapi(status: "ACCEPTED", location_status : "YES")
                        }else if self.atpickupordrop == "drop"{
                            self.Reachedapi(status: "START_RIDE", location_status : "AT_DESTINATION")
                        }
                       
                    }else{
                        if self.atpickupordrop == "pickup" {
                            
                            self.showAlert("Driver RideshareRates", message: "You are not nearby pickup location yet")
                        }else{
                            self.showAlert("Driver RideshareRates", message: "You are not nearby drop location yet")
                        }
                    }
                    
                    
                }else{
                    self.showAlert("Driver RideshareRates", message: "")
                }
            }
        }
    }
}
extension HomeViewController{
    //MARK:-  get profile data api
    func getProfileDataApi() {
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "get_profile",authRequired: true) { (value) in
            // print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print("Getting Profile Data Api  \(value)")
                let msg = (value["message"] as? String ?? "")
                if (value["status"] as? Int ?? 0) == 1{
                    let data = (value["data"] as? [String:AnyObject] ?? [:])
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        self.profileDetails = try newJSONDecoder().decode(ProfileData.self, from: jsonData)
                        NSUSERDEFAULT.set((self.profileDetails?.name ?? ""), forKey: kName)
                        NSUSERDEFAULT.set((self.profileDetails?.total_rating ?? ""), forKey: ktotal_rating)
                        NSUSERDEFAULT.set((self.profileDetails?.email ?? ""), forKey: kEmail)
                        NSUSERDEFAULT.set((self.profileDetails?.profile_pic ?? ""), forKey: kProfilePic)
                        self.servicesList.reloadData()
                    }catch{
                        print(error.localizedDescription)
                    }
                }
                else{
                    guard let stat = value["Error"] as? String, stat == "ok" else {
                        // self.showToast(message: "\(String(describing: stat))")
                        return
                    }
                }
            }
        }
    }
    //MARK:- get added vehicle services
    func getSelectServicesApi() {
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "get_added_vehicle_services",authRequired: true) { (value) in
            // print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print("Getting Select Services Data Api  \(value)")
                let msg = (value["message"] as? String ?? "")
                if (value["status"] as? Int ?? 0) == 1{
                    let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                    do{
                        self.arrSelectedRowsNew.removeAll()
                        self.arrnotSelectedRowsNew.removeAll()
                        self.servicesData.removeAll()
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        self.servicesData = try newJSONDecoder().decode(selectServicesModal.self, from: jsonData)
                        self.servicesList.reloadData()
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
            else{
                guard let stat = value["Error"] as? String, stat == "ok" else {
                    //  self.showToast(message: "\(String(describing: stat))")
                    return
                }
            }
        }
    }
    
    //MARK:- add selected serive api
    func addSelectedServicesApi(){
        
        var stringData = arrSelectedRowsNew[0]
        let param = ["service_id": stringData, "status" : "1" ] as [String : Any]
        print(param)
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "add_service", params: param ,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                NSUSERDEFAULT.set("no", forKey: checknotifi)
                let msg = (value["message"] as? String ?? "")
                if ((value["status"] as? Int ?? 0) == 1){
                    if self.arrSelectedRowsNew.count == 2{
                      //  self.removeSelectedServicesApi2.removeAll()
                        self.addSelectedServicesApi2()
                    }else{
                        if self.arrnotSelectedRowsNew.count != 0{
                            self.removeSelectedServicesApi2()
                        }else{
                            self.getSelectServicesApi()
                            self.ServicesView.isHidden = true
                        }
                    }
                }else{
                    self.showAlert("Driver RideshareRates", message: msg)
                }
            }
            else{
                guard let stat = value["Error"] as? String, stat == "ok" else {
                    
                    return
                }
            }
        }
    }
    //MARK:- add more service
    func addSelectedServicesApi2(){
        var stringData = arrSelectedRowsNew[1]
        let param = ["service_id": stringData, "status" : "1" ] as [String : Any]
        print(param)
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "add_service", params: param ,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                let msg = (value["message"] as? String ?? "")
                if ((value["status"] as? Int ?? 0) == 1){
                    if self.arrnotSelectedRowsNew.count != 0{
                        self.removeSelectedServicesApi2()
                    }else{
                        
                        self.getSelectServicesApi()
                        self.ServicesView.isHidden = true
                    }
                   
                }else{
                    self.showAlert("Driver RideshareRates", message: msg)
                }
            }
            else{
                guard let stat = value["Error"] as? String, stat == "ok" else {
                    return
                }
            }
        }
    }
    //MARK:- add more service
    func removeSelectedServicesApi2(){
        var stringData = arrnotSelectedRowsNew[0]
        let param = ["service_id": stringData, "status" : "0" ] as [String : Any]
        print(param)
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "add_service", params: param ,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                let msg = (value["message"] as? String ?? "")
                if ((value["status"] as? Int ?? 0) == 1){
                    self.getSelectServicesApi()
                    self.ServicesView.isHidden = true
                }else{
                    self.showAlert("Driver RideshareRates", message: msg)
                }
            }
            else{
                guard let stat = value["Error"] as? String, stat == "ok" else {
                    return
                }
            }
        }
    }
    //MARK:- get last ride api 
    func getLastRideDataApi(){
     //   Indicator.shared.showProgressView(self.view)
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "get_last_ride",authRequired: true) { [self] (value) in
            print("Last Ride Data Api  \(value)")
         //   Indicator.shared.hideProgressView()
            let msg = (value["message"] as? String ?? "")
            if self.conn.responseCode == 1{
                if (value["status"] as? Int ?? 0) == 1{
                    let change_vehicle = (value["change_vehicle"] as? Int ?? 0)
                    if value["change_vehicle"] as? Bool == true{
                        self.change_vehicle = "yes"
                        self.updateStatus(updateStatus: "3")
                        self.offline()
                        self.mactionRLBL.text = "Your current vehicle has been exipred.\nPlease add new vehicle"
                        self.mExpireVehicle.isHidden = false
                       }
  //                  let user_status = (value["user_status"] as? Bool)
//                    if user_status == true {
//                   
//                    }
                    let data = (value["data"] as? [String:AnyObject] ?? [:])
                    do {
                        self.startPulsing()
                        let jsondata = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let encodedJson = try JSONDecoder().decode(lastRideModalData.self, from: jsondata)
                        self.lastRideData = encodedJson
                        kRideId = self.lastRideData?.ride_id  ?? ""
                        self.confirmationView.isHidden = false
                        self.paymentView.isHidden = true
                        kPickAddress = self.lastRideData?.pickup_adress  ?? ""
                        kDropAddress = self.lastRideData?.drop_address  ?? ""
                        let pickLat = self.lastRideData?.pickup_lat  ?? ""
                        let pickLong = self.lastRideData?.pickup_long  ?? ""
                        let dropLat = self.lastRideData?.drop_lat  ?? ""
                        let dropLong = self.lastRideData?.drop_long  ?? ""
                        kDestinationLatLong = "\(dropLat)" + "," + "\(dropLong)"
                        kCustomerMobile = self.lastRideData?.mobile  ?? ""
                        kDistanceInMiles = self.lastRideData?.distance  ?? ""
                        kRidername = self.lastRideData?.user_lastname  ?? ""
                        self.totalFareLbl.text =    "$" + "\(self.lastRideData?.total_amount ?? "")"
                        self.fromAddressLbl.text = self.lastRideData?.pickup_adress  ?? ""
                        self.toAddressLbl.text = self.lastRideData?.drop_address  ?? ""
                        
                        self.totalDistanceLbl.text =   "\(self.lastRideData?.distance  ?? "" )" + " " + "Miles"
                        self.mUserNAme.text = "Rider: " + kRidername
                        self.fromAddressLbl.text = self.lastRideData?.pickup_adress  ?? ""
                        if self.lastRideData?.Stops?.count != 0{
                            mstoplocLBL.text = self.lastRideData?.Stops![0].midstop_address  ?? ""
                        }
                        self.toAddressLbl.text = self.lastRideData?.drop_address  ?? ""
                        kConfirmationAction =  self.lastRideData?.status  ?? ""
                        
                        print("last ride status --- \(kConfirmationAction)" )
                        let feedbackStatus = self.lastRideData?.feedback ?? ""
                        print(kConfirmationAction)
                        let paymentStatusData = self.lastRideData?.payment_status ?? ""
                     //   waitingtimelbl.isHidden = true
                        kNotificationAction =  self.lastRideData?.status  ?? ""
                        if kNotificationAction == "START_RIDE" || kConfirmationAction == "START_RIDE"{
                        
                            
                            if self.lastRideData?.Stops?.count != 0{
                            reachedatdropBTN.setTitle("AT \n STOP", for: .normal)
                                
                            }
                            
                            
                            
                            if self.lastRideData?.on_location == "AT_DESTINATION"{
                                endtripBTN.setTitle("END", for: .normal)
                             //   reachedatdropBTN.setTitle("AT \n STOP", for: .normal)
                                    self.mTimerView.isHidden = false
                                self.count = 0
                                let seccount = Int((lastRideData?.totaltimeDiffrenceOnDrop ?? "0")!)
                                    self.count = seccount!
                                self.totalCount = 0
                                let seconds = Int((lastRideData?.last_waiting_time ?? "0")!)
                                    self.totalCount = seconds!
                                let free_waiting_time = lastRideData?.free_waiting_time
                                let paid_waiting_time = lastRideData?.paid_waiting_time
                                    timeupdate()
                                self.reachedatdropBTN.isHidden = true
                            }else{
                                
                            }
                            self.confirmationView.isHidden = false
                            self.paymentView.isHidden = true
                            self.startRideView.isHidden = true
                            self.accptRejectView.isHidden = true
                            self.recordView.isHidden = false
                            self.callTechbtn.isHidden = true
                        }
                        else if kNotificationAction == "ACCEPTED" || kConfirmationAction ==  "ACCEPTED"{
                            if self.lastRideData?.on_location == "YES"{
                             //   if modalData?.on_location == "YES"{
                                    self.mTimerView.isHidden = false
                                  //  mTimerLBL.text = "waiting time on "
                                self.count = 0
                                    timerTitle.text = "Waiting time:"
                                    let seccount = Int((lastRideData?.totaltimeDiffrence ?? "0")!)
                                    self.count = seccount!
                                
                                let free_waiting_time = lastRideData?.free_waiting_time
                                let paid_waiting_time = lastRideData?.paid_waiting_time
                                 timeupdate()
                                
                           //     }
                                
                                self.reachedatpickup.isHidden = true
                             //   self.waitingtimelbl.isHidden = false
                            }else{
                               // self.waitingtimelbl.isHidden = true
                                self.reachedatpickup.isHidden = false
                            }
                            // Start updating path and moving car every 1 second
//                                  updateTimer = Timer.scheduledTimer(timeInterval: 180.0, target: self, selector: #selector(updatePathAndMoveCar), userInfo: nil, repeats: true)
                          //  self.confrmVHeight.constant = 320
                            self.confirmationView.isHidden = false
                            self.paymentView.isHidden = true
                            self.accptRejectView.isHidden = true
                            self.startRideView.isHidden = false
                            self.recordView.isHidden = true
                            self.callTechbtn.isHidden = false
                        //    self.technbtn.isHidden = true
                        }
                        else if kNotificationAction == "MID_STOP" || kConfirmationAction ==  "MID_STOP"{
                            
                            
                            endtripBTN.setTitle("Leave \n stop", for: .normal)
                            
                            
                            
                            if self.lastRideData?.on_location == "AT_STOP"{
                                    self.mTimerView.isHidden = false
                                self.count = 0
                                let seccount = Int((lastRideData?.totaltimeDiffrenceOnDrop ?? "0")!)
                                    self.count = seccount!
                                self.totalCount = 0
                                let seconds = Int((lastRideData?.last_waiting_time ?? "0")!)
                                    self.totalCount = seconds!
                                let free_waiting_time = lastRideData?.free_waiting_time
                                let paid_waiting_time = lastRideData?.paid_waiting_time
                                    timeupdate()
                                self.reachedatdropBTN.isHidden = true
                            }else if self.lastRideData?.on_location == "LEAVE_STOP"{
                                
                                reachedatdropBTN.setTitle("AT \n DROP", for: .normal)
                               
                                        self.mTimerView.isHidden = false
                                    self.count = 0
                                    let seccount = Int((lastRideData?.totaltimeDiffrenceOnDrop ?? "0")!)
                                        self.count = seccount!
                                    self.totalCount = 0
                                    let seconds = Int((lastRideData?.last_waiting_time ?? "0")!)
                                        self.totalCount = seconds!
                                    let free_waiting_time = lastRideData?.free_waiting_time
                                    let paid_waiting_time = lastRideData?.paid_waiting_time
                                        timeupdate()
                                    self.reachedatdropBTN.isHidden = false
                                
                               
                            }else if self.lastRideData?.on_location == "AT_DESTINATION"{
                                endtripBTN.setTitle("END", for: .normal)
                                self.mTimerView.isHidden = false
                            self.count = 0
                            let seccount = Int((lastRideData?.totaltimeDiffrenceOnDrop ?? "0")!)
                                self.count = seccount!
                            self.totalCount = 0
                            let seconds = Int((lastRideData?.last_waiting_time ?? "0")!)
                                self.totalCount = seconds!
                            let free_waiting_time = lastRideData?.free_waiting_time
                            let paid_waiting_time = lastRideData?.paid_waiting_time
                                timeupdate()
                            self.reachedatdropBTN.isHidden = true
                        }
                            self.confirmationView.isHidden = false
                            self.paymentView.isHidden = true
                            self.startRideView.isHidden = true
                            self.accptRejectView.isHidden = true
                            self.recordView.isHidden = false
                            self.callTechbtn.isHidden = true
                        }
                        else if kNotificationAction == "CANCELLED" || kConfirmationAction  ==  "CANCELLED"{
                            self.getearning()
                            self.updateStatus(updateStatus: "1")
                            mnavView.isHidden = true
//                            self.mStartRideeBTN.isHidden = true
//                            self.mGoBTN.isHidden = false
                            self.pathPolyline?.map = nil

                            self.startRideView.isHidden = true
                            self.accptRejectView.isHidden = true
                            self.confirmationView.isHidden = true
                            self.recordView.isHidden = true
                        }
                        else if kNotificationAction == "COMPLETED" || kConfirmationAction  == "COMPLETED"{
                            self.getearning()
                            self.callTechbtn.isHidden = true
                            self.pathPolyline?.map = nil
                            self.mTimerView.isHidden = true
                          //  self.technbtn.isHidden = true
                            if  paymentStatusData ==  "COMPLETED"{
                               // self.pathPolyline?.map = nil

                                self.startRideView.isHidden = true
                                self.accptRejectView.isHidden = true
                                self.confirmationView.isHidden = true
                                self.recordView.isHidden = true
                                let feedbackStatus = self.lastRideData?.rider_feedback
                                    if feedbackStatus == "1"{
                                        kNotificationAction = ""
                                        kConfirmationAction = ""
                                        kRideId = ""
                                        self.ratingView.isHidden = true
                                    }else{
                                        self.mStartView.delegate = self
                                        self.ratingView.isHidden = false
                                        kNotificationAction = "FEEDBACK"
                                        kConfirmationAction = "FEEDBACK"
                                        
                                        if self.lastRideData?.user_lastname == ""{
                                            self.mNameLBL.text =  "How was your experience with" + " Boss rider"
                                        }else{
                                            
                                            self.mNameLBL.text =  "How was your experience with" + " " + "\(self.lastRideData?.user_lastname ?? "")"  + " rider"
                                        }
                                        
                                    }
                              
                                
//                                kNotificationAction = ""
//                                kConfirmationAction = ""
                                kRideId = ""
                                self.paymentView.isHidden = true
                                self.amountLblFinal.text =   "$" + "\(self.lastRideData?.total_amount  ?? "")"  + " " + "Amount is Received"
                                self.ServicesView.isHidden = true
                            }
                            else{
                                kNotificationAction = ""
                                kConfirmationAction = ""
                                self.confirmationView.isHidden = true
                                self.paymentView.isHidden = false
                               // self.offlineOnlineBtn.isUserInteractionEnabled = false
                               // self.my_switch.isUserInteractionEnabled = false
                                self.amountLblFinal.text =   "$" + "\(self.lastRideData?.total_amount  ?? "")"  + " " + "Amount is Pending"
                                self.ServicesView.isHidden = true
                            }
                        }
                        else if kNotificationAction == "FAILED" || kConfirmationAction  == "FAILED"{
                            self.confirmationView.isHidden = true
                            kNotificationAction = ""
                            kConfirmationAction = ""
                            kRideId = ""
                        }
                        else if kNotificationAction == "PENDING" || kConfirmationAction  == "PENDING"{
                         //   self.confrmVHeight.constant = 250
//                            if self.pendingLastRideStatus == true {
//                                self.confirmationView.isHidden = true
//                                self.accptRejectView.isHidden = true
//                                self.startRideView.isHidden = true
//                                self.recordView.isHidden = true
//                            }else{
                          //  updateTimer = Timer.scheduledTimer(timeInterval: 180.0, target: self, selector: #selector(updatePathAndMoveCar), userInfo: nil, repeats: true)
                         //   updatePathAndMoveCar()
                                if self.offlineOnlineLabel.text == "Online"{
                                //    self.showAlert("Driver RideshareRates", message: "NO MINORS ALLOWED TO RIDE WITHOUT AN ADULT")
                                    self.confirmationView.isHidden = false
                                    self.paymentView.isHidden = true
                                    self.accptRejectView.isHidden = false
                                    self.startRideView.isHidden = true
                                    self.recordView.isHidden = true
                                    self.startProgressAndAPIRequest()
//                                    self.timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(self.startTimer(_:)), userInfo: nil, repeats: true)
//                                    self.progressView.setAnimatedProgress(duration: 20) {
//                                        print("Done!")
                                        // self.cancelledUsingProgressBarTime()
                             //       }
                                }else{
                                    self.startRideView.isHidden = true
                                    self.accptRejectView.isHidden = true
                                    self.confirmationView.isHidden = true
                                    self.recordView.isHidden = true
                                    kNotificationAction = ""
                                    kConfirmationAction = ""
                                    kRideId = ""
                                    self.paymentView.isHidden = true
                                }

                    //        }
                        }else if kNotificationAction == "NOT_CONFIRMED" || kConfirmationAction  == "NOT_CONFIRMED"{
                        //    updatePathAndMoveCar()
                         //   self.confrmVHeight.constant = 250
                            //   if self.pendingLastRideStatus == true {
                            if self.offlineOnlineLabel.text == "Online"{
                                self.confirmationView.isHidden = true
                                self.accptRejectView.isHidden = true
                                self.startRideView.isHidden = true
                                self.recordView.isHidden = true
                                self.startProgressAndAPIRequest()
//                                self.timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(self.startTimer(_:)), userInfo: nil, repeats: true)
//                                self.progressView.setAnimatedProgress(duration: 20) {
//                                    print("Done!")
                           //     }
                            }else{
                                self.startRideView.isHidden = true
                                self.accptRejectView.isHidden = true
                                self.confirmationView.isHidden = true
                                self.recordView.isHidden = true
                                kNotificationAction = ""
                                kConfirmationAction = ""
                                kRideId = ""
                                self.paymentView.isHidden = true
                            }
                        }
                        else {
                            print("hmm")
                            self.confirmationView.isHidden = true
                            self.accptRejectView.isHidden = true
                            self.startRideView.isHidden = true
                            self.recordView.isHidden = true
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }
                else{
                    let errMsg = (value["Error"] as? String ?? "")
                  
                }
            }
            else{
                guard let stat = value["Error"] as? String, stat == "ok" else {
                   return
                }
            }
        }
    }
    
    func timeupdate(){
     //   count = NSUSERDEFAULT.value(forKey: Ktimer) as? Int ?? 0
      //  NavigationManager.pushToLoginVC(from: self)
        stopTimer()
        DispatchQueue.main.async {
            self.timerS =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimervalue), userInfo: nil, repeats: true)
            print("1.0")
        }
    }
    func stopTimer() {
        if timerS != nil{
            self.timerS!.invalidate()
            self.timerS = nil
        }
        
    }
    @objc func updateTimervalue() {
        if self.stoptimer == "stop"{
            stopTimer()
        }else{
            let time = timeString(time: TimeInterval(self.count))
            DispatchQueue.main.async {
                self.mTimerLBL.text = time
                print(time)
            }
        }
      //  stopTimer()
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        self.count = self.count + 1

        self.totalwaittime = 0
        self.totalwaittime = self.totalCount + self.count
        print(count)
        print(totalwaittime)

            if kNotificationAction == "ACCEPTED" || kConfirmationAction == "ACCEPTED"{
//                if count > 240{
//                    mTimerView.isHidden = truebbbbbvv
               if lastRideData?.on_location == "YES"{
                    timerTitle.text = "Waiting time:"
                    mTimerView.isHidden = false
                   
//                   var free_waiting_time = Int()
//                   var paid_waiting_time = Int()
                   var free_waiting_time = Int(lastRideData?.free_waiting_time ?? "0")!
                   var paid_waiting_time = Int(lastRideData?.paid_waiting_time ?? "0")!
                   var totaltime = free_waiting_time + paid_waiting_time
                   
                 //  if count > totaltime{
                       if totalwaittime > 4920{
                       mTimerView.isHidden = true
                       kConfirmationStatus = "COMPLETED"
                       CompleteRide(confirmStatus: "COMPLETED", acceptRejectView: acceptReject.completedStatus, time: count )
                  
                       stopTimer()
                   }
                }else{
                    mTimerView.isHidden = true
                }
            }else  if kNotificationAction == "START_RIDE" || kConfirmationAction == "START_RIDE"{
               if lastRideData?.on_location == "AT_DESTINATION"{
                    timerTitle.text = "Waiting time:"
                    mTimerView.isHidden = false
                   var free_waiting_time = Int(lastRideData?.free_waiting_time ?? "0")!
                   var paid_waiting_time = Int(lastRideData?.paid_waiting_time ?? "0")!
                   var totaltime = free_waiting_time + paid_waiting_time
                   if totalwaittime > 5040{
               //        if totalwaittime > totaltime{
                       mTimerView.isHidden = true
                       kConfirmationStatus = "COMPLETED"
                 
                       CompleteRide(confirmStatus: "COMPLETED", acceptRejectView: acceptReject.completedStatus, time: totalwaittime )
                       stopTimer()
                   }
                }else{
                    mTimerView.isHidden = true
                }
                
            }else{
                mTimerView.isHidden = true
                stopTimer()
            }
//        }
        
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func CompleteRide(confirmStatus : String , acceptRejectView : acceptReject, time : Int){
        print("ACCEPT REJECT API")
        let param = [ "ride_id" : self.lastRideData?.ride_id  ?? "","status" : kConfirmationStatus, "waitingtime": time] as [String : Any]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "accept_ride", params: param,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            print(value)
            let msg = (value["message"] as? String ?? "")
            if ((value["status"] as? Int ?? 0) == 1){
                self.stopTimer()
                //  kNotificationAction = ""
//                if kConfirmationStatus == "CANCELLED"{
//                    self.confirmationView.isHidden = true
//                    self.showToast(message: msg)
//                }
//                else if kConfirmationStatus == "START_RIDE"{
//                    self.getLastRideDataApi()
//                   // self.offlineOnlineBtn.isUserInteractionEnabled = false
//                 //   self.my_switch.isUserInteractionEnabled = false
//                }
             //   else
                if kConfirmationStatus == "COMPLETED"{
                 //   self.offlineOnlineBtn.isUserInteractionEnabled = false
                 //   self.my_switch.isUserInteractionEnabled = false
                    self.confirmationView.isHidden = true
                //    self.updateStatus(updateStatus: "3")
                    self.showToast(message: msg)
                    self.getLastRideDataApi()
                }
//                else{
//                    self.getLastRideDataApi()
//                    self.confirmationView.isHidden = false
//                    self.paymentView.isHidden = true
//                    self.showToast(message: msg)
//                }
            }else{
                self.showAlert("Driver RideshareRates", message: msg)
            }
        }
    }
//    @objc func updatePathAndMoveCar() {
//        //    guard let current = currentLocation else { return }
//            
//            // Update path and move car
//       var pickup = ""
////        if kNotificationAction == "START_RIDE" || kConfirmationAction == "START_RIDE"{
//            pickup = (lastRideData?.drop_lat)! + "," + (lastRideData?.drop_long)!
//            if let coordinates = parseCoordinates(from:pickup) {
//                       destinationLocation = coordinates
//                       
//                    }
//            
//            guard let current = currentLocation,
//                          let destination = destinationLocation else { return }
//            
//            
//            drawPath(from: current.coordinate, to: destination)
//        addMarker(at: destination)
//              //  animateCarOnPath()
//
////        }else if kNotificationAction == "ACCEPTED" || kConfirmationAction ==  "ACCEPTED"{
////            pickup = (lastRideData?.pickup_lat)! + "," + (lastRideData?.pickup_long)!
////            if let coordinates = parseCoordinates(from:pickup) {
////                       destinationLocation = coordinates
////                       
////                    }
////            
////            guard let current = currentLocation,
////                          let destination = destinationLocation else { return }
////            
////            
////            drawPath(from: current.coordinate, to: destination)
////                animateCarOnPath()
////
////        }
////        
//                
//       
//        }
    private func addMarker(at coordinate: CLLocationCoordinate2D) {
           let marker = GMSMarker(position: coordinate)
           marker.icon = GMSMarker.markerImage(with: .red)  // Set marker color to blue
           marker.map = mapView
       }
    // Function to parse coordinates from string "latitude,longitude"
       func parseCoordinates(from string: String) -> CLLocationCoordinate2D? {
           let components = string.components(separatedBy: ",")
           guard components.count == 2,
                 let latitude = Double(components[0]),
                 let longitude = Double(components[1]) else {
               return nil
           }
           return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
       }
    
    
//    func drawPath(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
//        let origin = "\(source.latitude),\(source.longitude)"
//        let destination = "\(destination.latitude),\(destination.longitude)"
//            let googleapi = "AIzaSyABQXS9DNSgpuGVZnC5bwfpj1mrl4dd4Z8"
//            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&alternativeRoute=true&key=\(googleapi)"
//        let headers: HTTPHeaders = [
//            "X-Ios-Bundle-Identifier": "com.driverchime.app"
//        ]
//            AF.request(url, headers: headers).responseJSON { response in
//                switch response.result {
//                case .success(let value):
//                    guard let json = value as? [String: Any],
//                          let routes = json["routes"] as? [[String: Any]],
//                          let route = routes.first,
//                          let polyline = route["overview_polyline"] as? [String: Any],
//                          let points = polyline["points"] as? String,
//                          let legs = route["legs"] as? [[String: Any]],
//                                         let leg = legs.first,
//                                         let distance = leg["distance"] as? [String: Any],
//                          let distanceValue = distance["value"] as? Int,
//                          let duration = leg["duration"] as? [String: Any],
//           let durationValue = duration["value"] as? Int
//                         //   print(distanceValue)
//                            
//                            
//                    else {
//                        // Handle parsing error or invalid response
//                        return
//                    }
//                    print(distanceValue)
////                    self.picktodropDistance = distanceValue
////                    self.picktodropDuration = durationValue
////                    if self.pickvalue == "nil"{
////                        self.getVechileTypeApi()
////                        self.pickvalue = ""
////                    }
//                    
//                //    self.getVechileTypeApi()
//                    // Decode the polyline points
//                    let path = GMSPath(fromEncodedPath: points)
//                    
//                    // Remove existing polyline from the map if it exists
//                    self.pathPolyline?.map = nil
//                    
//                    // Create a new GMSPolyline and add it to the map
//                    let newPolyline = GMSPolyline(path: path)
//                    newPolyline.strokeColor = #colorLiteral(red: 0.9921568627, green: 0.9607843137, blue: 0.6901960784, alpha: 1)
//                    newPolyline.strokeWidth = 5
//                    newPolyline.map = self.mapView
//                    self.pathPolyline = newPolyline
//                    let bounds = GMSCoordinateBounds(path: path!)
//                    let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
//                    self.mapView.animate(with: update)
//                    
//                case .failure(let error):
//                   
//                    print("Error: \(error)")
//                }
//            }
//    }
    
//    func drawPath(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
//            // Remove existing polyline and add a new one
//            pathPolyline?.map = nil
//            
//            let path = GMSMutablePath()
//            path.add(source)
//            path.add(destination)
//            
//            let polyline = GMSPolyline(path: path)
//            polyline.strokeColor = .blue
//            polyline.strokeWidth = 3.0
//            polyline.map = mapView
//            
//            pathPolyline = polyline
//        }
//    func animateCarOnPath() {
//        // Create a marker (car) if it doesn't exist
//        if carMarker == nil {
//            carMarker = GMSMarker()
//            carMarker?.position = currentLocation!.coordinate
//            carMarker?.icon = UIImage(named: "car") // Replace with your car icon image
//            carMarker?.map = mapView
//        }
//        
//        // Retrieve the encoded path string
//        guard let encodedPath = pathPolyline?.path?.encodedPath() else {
//            return
//        }
//        
//        // Create a GMSPath from the encoded path string
//        let path = GMSPath(fromEncodedPath: encodedPath)
//        guard let validPath = path else {
//            return
//        }
//        
//        // Animate car movement along the path
//        var currentIndex = 0
//        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
//            guard currentIndex < validPath.count() else {
//                timer.invalidate()
//                return
//            }
//            
//            self.carMarker?.position = validPath.coordinate(at: UInt(currentIndex))
//            currentIndex += 1
//        }
//    }

    func postFeedBackApi(ride_id: String, rating: String, comment :String ,rider_id : String) {
        let param = ["ride_id": ride_id,"rating": rating  ,"comment" : comment ,"rider_id" : rider_id]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "rider_feedback", params: param,authRequired: true) { (value) in
            //   print(value)
            let msg = (value["message"] as? String ?? "")
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                if (value["status"] as? Int ?? 0) == 1{
                    self.ratingView.isHidden = true
                    kRating = ""
                    
                    
                }
                else{
                    self.showAlert("Driver RideshareRates", message: msg)
                }
            }
            else{
                print("No Ride Available")
                guard var stat = value["Error"] as? String, stat == "ok" else {
                    return
                }
            }
        }
    }
}
extension Int {

    func getString(prefix: Int) -> String {
        return "\(prefix)\(self)"
    }

    func getString(prefix: String) -> String {
        return "\(prefix)\(self)"
    }
}
