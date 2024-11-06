//
//  HomeButton.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//

import UIKit
import AVFoundation
import Alamofire
extension HomeViewController {
    //MARK:- Button Action

    @objc func loadBackgroundList(_ notification: NSNotification){
        let notificationData = notification.userInfo
        if let dict = notificationData as? [String: Any] {
            print("userInfo: ", dict)
            if let dictData = dict["action"] as? String{
                print(dictData)
                kNotificationAction = dictData
                kConfirmationAction = dictData
                if let dictDataRideID = dict["ride_id"] as? String{
                    kRideId = (dict["ride_id"] as? String)!
                    getLastRideDataApi()
                    print(dictDataRideID)
                }
                if kNotificationAction == "ACCEPTED"{
                    self.ride_tableView.reloadData()
                }
                else  if kNotificationAction == "COMPLETED"  {
                    if dict["is_technical_issue"] as? String == "Yes"{
                        let refreshAlert = UIAlertController(title: "Rider RideshareRates", message: "Driver wants to drop off you before \n reaching destination. Do you want to complete this ride?", preferredStyle: UIAlertController.Style.alert)
                        
                        let titleAttributes: [NSAttributedString.Key: Any] = [
                            
                            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                            NSAttributedString.Key.foregroundColor: UIColor.white,
                        ]
                        let messageAttributes: [NSAttributedString.Key: Any] = [
                            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                            .foregroundColor: UIColor.white,
                        ]

                        let attributedTitle = NSAttributedString(string: "Rider RideshareRates", attributes: titleAttributes)
                        let attributedMessage = NSAttributedString(string: "Driver wants to drop off you before \n reaching destination. Do you want to complete this ride?", attributes: messageAttributes)

                        // Set the attributed title and message
                        refreshAlert.setValue(attributedTitle, forKey: "attributedTitle")
                        refreshAlert.setValue(attributedMessage, forKey: "attributedMessage")
                        refreshAlert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.96)
                        
                        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                            let refreshAlert = UIAlertController(title: "Rider RideshareRates", message: "Payment is automatically debit for this ride.", preferredStyle: UIAlertController.Style.alert)
                            let titleAttributes: [NSAttributedString.Key: Any] = [
                                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                                NSAttributedString.Key.foregroundColor: UIColor.white,
                            ]
                            let messageAttributes: [NSAttributedString.Key: Any] = [
                                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                                .foregroundColor: UIColor.white,
                            ]

                            let attributedTitle = NSAttributedString(string: "Rider RideshareRates", attributes: titleAttributes)
                            let attributedMessage = NSAttributedString(string: "Payment is automatically debit for this ride.", attributes: messageAttributes)

                            // Set the attributed title and message
                            refreshAlert.setValue(attributedTitle, forKey: "attributedTitle")
                            refreshAlert.setValue(attributedMessage, forKey: "attributedMessage")
                            refreshAlert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.96)
                            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                               // print("autoPAyment")
                                self.savedCardApi()
                            }))
                            refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                                refreshAlert.dismiss(animated: true, completion: nil)
                            }))
                            self.present(refreshAlert, animated: true, completion: nil)
                            
                        }))
                        // "Driver NOT wants to drop off you before \n reaching destination. Do you want to complete this ride?"
                        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                            let url: NSURL = URL(string: "TEL://4042075620")! as NSURL
                               UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                        }))
                        present(refreshAlert, animated: true, completion: nil)
                        kNotificationAction = ""
                        kConfirmationAction = ""
                        self.pickUpAddress_lbl.text = NSUSERDEFAULT.value(forKey: kpCurrentAdd) as! String
                        self.dropAddress_lbl.text = "Enter Drop Location"
                        self.chooseRide_view.isHidden = true
                        self.ride_tableView.isHidden = true
                    }else{
                        self.ride_tableView.reloadData()
                    }
                }
                else  if kNotificationAction == "FEEDBACK" {
                    self.ride_tableView.reloadData()
                }
                else  if kNotificationAction == "CANCELLED" {
                    kNotificationAction = ""
                    kConfirmationAction = ""
                    self.mapView.clear()
                    self.pickUpAddress_lbl.text = NSUSERDEFAULT.value(forKey: kpCurrentAdd) as! String
                    self.dropAddress_lbl.text = "Enter Drop Location"
                    self.chooseRide_view.isHidden = true
                    self.ride_tableView.isHidden = true
                    self.chooseRideViewHeight_const.constant = 0
                }
                else  if kNotificationAction == "PENDING" {
                    self.ride_tableView.reloadData()
                }
                else  if kNotificationAction == "DRIVER_AT_STOP" {
                    self.ride_tableView.reloadData()
                }
                else  if kNotificationAction == "START_FROM_STOP" {
                    self.ride_tableView.reloadData()
                }
                else  if kNotificationAction == "START_RIDE" {
                    self.ride_tableView.reloadData()
                }
                else{
                    print("Nothing")
                }
            }
            if let dictDataRideID = dict["ride_id"] as? String{
                kRideId = (dict["ride_id"] as? String)!
                print(dictDataRideID)
            }
            if let dictDataDriverID = dict["driver_id"] as? String{
                print(dictDataDriverID)
                kDriverId = dictDataDriverID
            }
            self.getLastRideDataApi()
        }
    }
    @objc func loadForegroundList(_ notification: NSNotification){
        let notificationData = notification.userInfo
        if let dict = notificationData as? [String: Any] {
            print("userInfo: ", dict)
            if let dictData = dict["action"] as? String{
                print(dictData)
                kNotificationAction = dictData
                kConfirmationAction = dictData
                if let dictDataRideID = dict["ride_id"] as? String{
                    kRideId = (dict["ride_id"] as? String)!
                    getLastRideDataApi()
                    print(dictDataRideID)
                }
//                if kNotificationAction == "ACCEPTED"{
//                    self.ride_tableView.reloadData()
//                }
                
                if kNotificationAction == "ACCEPTED"{
                    self.ride_tableView.reloadData()
                }
                else  if kNotificationAction == "COMPLETED"  {
                 //   self.ride_tableView.reloadData()
                }
                else  if kNotificationAction == "FEEDBACK" {
                  //  self.ride_tableView.reloadData()
                }
                else  if kNotificationAction == "CANCELLED" {
                    self.mapView.clear()
                }
                else  if kNotificationAction == "PENDING" {
                    self.ride_tableView.reloadData()
                }
                else  if kNotificationAction == "START_RIDE" {
                    self.ride_tableView.reloadData()
                }
                else  if kNotificationAction == "DRIVER_AT_STOP" {
                    self.ride_tableView.reloadData()
                }
                else  if kNotificationAction == "START_FROM_STOP" {
                    self.ride_tableView.reloadData()
                }
                else{
                    print("Nothing")
                }
            }
            if let dictDataRideID = dict["ride_id"] as? String{
                print(dictDataRideID)
            }
            if let dictDataDriverID = dict["driver_id"] as? String{
                print(dictDataDriverID)
                kDriverId = dictDataDriverID
            }
           self.getLastRideDataApi()
        }
    }
    @objc func appMovedToForeground() {
        print("App moved to foreground!")
        self.getLastRideDataApi()
    }
    @IBAction func currentLocationClearBtnAction(_ sender: Any) {
        
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        
        if pickupBtnCancel.currentImage == UIImage(named: "cancel"){
            pickupBtnCancel.setImage(UIImage(named: "loc"), for: .normal)
            self.pickUpAddress_lbl.text = "Enter Current Location"
            
            self.chooseRide_view.isHidden = true
            self.rideNow_btn.isHidden = true
            self.chooseRideViewHeight_const.constant = 0
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            mapView.clear()
            kNotificationAction = ""
            kConfirmationAction = ""
            locationPickUpEditStatus = false
            polyLine.map = nil
        }else{
            pickupBtnCancel.setImage(UIImage(named: "cancel"), for: .normal)
            self.update = true
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        }
       
    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        //Access the last object from locations to get perfect current location
//        if let location = locations.last {
//            let span = MKCoordinateSpanMake(0.00775, 0.00775)
//            let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
//            let region = MKCoordinateRegionMake(myLocation, span)
//            Map.setRegion(region, animated: true)
//        }
//        self.Map.showsUserLocation = true
//        manager.stopUpdatingLocation()
//    }
    @IBAction func tapPickupLoction_btn(_ sender: Any) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        pickupBtnCancel.setImage(UIImage(named: "loc"), for: .normal)
        self.tap = 1
        self.autocompleteClicked()
    }
    @IBAction func tapDropLoaction_btn(_ sender: Any) {
        
        if pickUpAddress_lbl.text == "Enter Current Location"{
            
            self.showAlert("Rider RideshareRates", message: "Please select current location first")
        }else{
            DispatchQueue.main.async {
                NavigationManager.pushToLoginVC(from: self)
            }
            self.tap = 0
            self.autocompleteClicked()
        }
        
       
    }
    @IBAction func tapCancelDropAddress_btn(_ sender: Any) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.pickUpAddress_lbl.text = NSUSERDEFAULT.value(forKey: kpCurrentAdd) as! String
      //  self.dropAddress_lbl.text = "Enter Drop Location"
        self.dropAddress_lbl.text = "Enter Drop Location"
        self.chooseRide_view.isHidden = true
        self.rideNow_btn.isHidden = true
        self.chooseRideViewHeight_const.constant = 230
        kNotificationAction = ""
        kConfirmationAction = ""
        polyLine.map = nil
        mapView.clear()
        locationDropUpEditStatus = false

    }
    @IBAction func tapRideNow_btn(_ sender: Any) {
//        if cardData.count == 0{
//           
//
//        }else{
        //        DispatchQueue.main.async {
        //            NavigationManager.pushToLoginVC(from: self)
        //        }
        //            if !(self.rideAmount == ""){
        //                self.rideNowApi()
        //            }
  //      }
       
    }

    func setNavButton(){
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = .black

       // self.navigationController?.view.backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)

        
        
//        let logoBtn1 = UIButton(type: .custom)
//        logoBtn1.setImage(UIImage(named: "shape_28"), for: .normal)
//        logoBtn1.addTarget(self, action: #selector(tapNavButton), for: .touchUpInside)
//
//        let barButton1 = UIBarButtonItem(customView: logoBtn1)
//
//        let logoBtn2 = UIButton(type: .custom)
//        logoBtn2.setImage(UIImage(named: "another_image"), for: .normal)
//        logoBtn2.addTarget(self, action: #selector(anotherAction), for: .touchUpInside)
//
//        let barButton2 = UIBarButtonItem(customView: logoBtn2)
//
//        self.navigationItem.rightBarButtonItems = [barButton1, barButton2]
        
        let logoBtn = UIButton(type: .custom)
        logoBtn.setImage(UIImage(named: "shape_28"), for: .normal)
        logoBtn.addTarget(self, action: #selector(tapNavButton), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: logoBtn)
        self.navigationItem.leftBarButtonItem = barButton
        
        let logoBtn2 = UIButton(type: .custom)
        logoBtn2.setImage(UIImage(systemName: "headphones"), for: .normal)
        logoBtn2.tintColor = #colorLiteral(red: 0.9921568627, green: 0.9607843137, blue: 0.6901960784, alpha: 1)
       // logoBtn2.setImage(UIImage(named: "headphones"), for: .normal)
        logoBtn2.addTarget(self, action: #selector(anotherAction), for: .touchUpInside)
        let barButton2 = UIBarButtonItem(customView: logoBtn2)
        self.navigationItem.rightBarButtonItem = barButton2
    }
    @objc func anotherAction(){
        let vc = self.storyboard?.instantiateViewController(identifier: "helpVCID") as! helpVC
        vc.screen = "home"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func tapNavButton(){
        let presentedVC = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController")
        let nvc = UINavigationController(rootViewController: presentedVC)
        present(nvc, animated: false, pushing: true, completion: nil)
    }
    
    
    func getDocumentsDirectory()-> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    func getAudioURL() -> URL {
        let filename = NSUUID().uuidString+".m4a"
        return getDocumentsDirectory().appendingPathComponent(filename)
    }
    func startRecording(){
        do{
            let audioURL = self.getAudioURL()
            print("first \(audioURL)")
            audioRecorder = try AVAudioRecorder(url:self.getAudioURL(),settings:settings)
            audioRecorder.delegate = self
            audioRecorder.record(forDuration: 15)
        }catch{
            finishRecording(success: false)
        }
    }
    func finishRecording(success: Bool){
        audioRecorder.stop()
        if success{
            print("Recorded successfully!")
        }else{
            audioRecorder = nil
            print("Recording failed!")
        }
    }
}



extension HomeViewController : AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag{
            finishRecording(success:false)
            print("What is this url \(recorder.url)")
            
        }
        let refreshAlert = UIAlertController(title: Singleton.shared!.title , message: "Are you sure you want to save recording?", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action: UIAlertAction!) in
            self.audioRecorder = nil
          //  self.startRecording()
            let params = ["ride_id" : self.selectRideID ]
            self.requestForUpload(audioFilePath: recorder.url, parameters: params)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playBtnValue = "Play Recoring"
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
    func requestForUpload( audioFilePath: URL , parameters : [String: Any] ) {
        let url = URL(string: "\(baseURL)audio_capture")!
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Accept": "application/json",
            "authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as? String ?? "")"
        ]
        Indicator.shared.showProgressView(self.view)
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(audioFilePath, withName: "audio", fileName: "ajay", mimeType: "audio/m4a")
            for (key, value) in parameters {
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
                    self.showAlert("Rider RideshareRates", message: msg)
                }
                else{
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
}
