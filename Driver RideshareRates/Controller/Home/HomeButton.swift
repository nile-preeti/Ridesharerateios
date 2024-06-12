//
//  HomeRecording.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit

extension HomeViewController {
    //MARK:- User Defined Func
    @IBAction func cancelServiceBtnAction(_ sender: Any) {
        ServicesView.isHidden = true
        self.arrSelectedRowsStatus.removeAll()
    }
    //MARK:- fun for register xib
    func registerCell(){
        let imgNib = UINib(nibName: "SelectServicesVC", bundle: nil)
        self.servicesList.register(imgNib, forCellReuseIdentifier: "SelectServicesVC")
        
        let btnNib = UINib(nibName: "SubmitServicesCell", bundle: nil)
        self.servicesList.register(btnNib, forCellReuseIdentifier: "SubmitServicesCell")
    }
    func startProgressAndAPIRequest() {
        progressView.progress = 0.0

               // Animate the progress to 1.0 over 20 seconds
               UIView.animate(withDuration: 20.0, animations: {
                   self.progressView.setProgress(1.0, animated: true)
               }) { (_) in
                   // Animation completed, start a timer to clear the progress view after 20 seconds
                   self.progressTimer = Timer.scheduledTimer(withTimeInterval: 20.0, repeats: false, block: { (_) in
                       self.progressView.progress = 0.0
                       self.cancelProgressAnimation()
                       self.hitAPI()
                   })
               }
    }
    func cancelProgressAnimation() {
            progressTimer?.invalidate()
            progressView.progress = 0.0
        }
    func hitAPI() {
        // Perform your API request here
        // For demonstration purposes, we'll just print a message after the 20 seconds
        if kRequestStatus == "PENDING" ||  kNotificationAction == "PENDING" || kConfirmationAction == "PENDING" {
            if kConfirmationStatus == "ACCEPTED" || kConfirmationStatus == "START_RIDE" || kConfirmationStatus == "COMPLETED" || kConfirmationStatus == "CANCELLED" {
                print("")
            }else{
                self.cancelRideStatus(rideId: kRideId)
            }
        }
    }
    
    
    
    
//    @objc func startTimer(_ timer: Timer) {
//        print("Timer Start")
//        if kRequestStatus == "PENDING" ||  kNotificationAction == "PENDING" && kConfirmationAction == "PENDING" {
//            if kConfirmationStatus == "ACCEPTED" || kConfirmationStatus == "START_RIDE" || kConfirmationStatus == "COMPLETED"{
//               print("")
//            }else{
//                self.cancelRideStatus(rideId: kRideId)
//            }
//
//        }
//        self.timer?.invalidate()
//        self.timer = nil
//    }
    
    @objc func failedTimer(_ timer: Timer){
        print("Failded Timer Start")
        var timerCountStatus = false
        if kRideId != "" && timerCountStatus == true {
            print("work 3 minutes more")
            timerCountStatus = false
        }
        if kRideId != "" && timerCountStatus == false {
            print("work 3 minutes")
            timerCountStatus = true
            if  kNotificationAction == "PENDING" && kConfirmationAction == "PENDING" {
                self.cancelRideStatus(rideId: kRideId)
            }
        }
    }
    
//    @objc func cancelledUsingProgressBarTime(){
//        print("Failed cancelledUsingProgressBarTime")
//        var timerCountStatus = false
//        if kRideId != "" && timerCountStatus == true {
//            print("work 20 seconds more")
//            timerCountStatus = false
//        }
//        if kRideId != "" && timerCountStatus == false {
//            print("work 20 secondss")
//            timerCountStatus = true
//            if  kNotificationAction == "PENDING" || kConfirmationAction == "NOT_CONFIRMED" || kRequestStatus == "NOT_CONFIRMED" || kRequestStatus == "PENDING" {
//                progressView.progress = 0.0
//                self.cancelRideStatus(rideId: kRideId)
//            }
//        }
//    }
//    @objc func failedTimerPendingRequest(_ timer: Timer){
//        print("Failded Timer Pending Request")
//        if  kRideId != "" && kNotificationAction == "PENDING" || kConfirmationAction == "PENDING" {
//            self.cancelRideStatus(rideId: kRideId)
//        }
//    }
    @objc func appMovedToForeground() {
        print("App moved to foreground!")
        appMovedToForegroundStatus = true
        self.pendingRequestApi()
//        if kRideId != ""{
//            self.getRideStatus(ride_id:kRideId)
//        }
    }
    @objc func loadBackgroundList(_ notification: NSNotification){
        
        let notificationData = notification.userInfo
        if let dict = notificationData as? [String: Any] {
            print("userInfo: ", dict)
            if let dictData = dict["action"] as? String{
                print(dictData)
                kNotificationAction = dictData
                if kNotificationAction == "PENDING"{
                    self.pendingRequestApi()
                  //  timer = Timer.scheduledTimer(timeInterval: 40.0, target: self, selector: #selector(startCancelledApiTimer(_:)), userInfo: nil, repeats: false)
                }
                if  kNotificationAction == "FEEDBACK"{
                 //   kNotificationAction = "COMPLETED"
                    self.showAlert("Drive RideshareRates", message: "$" + "\(self.lastRideData?.total_amount  ?? "")"  + " " + "Amount is received successfully")
                   getLastRideDataApi()
                //    UpdateLotLng()
                    getearning()
                }
            }
            if let dictDataRideID = dict["ride_id"] as? String{
                print(dictDataRideID)
                kRideId = dictDataRideID
            }
        }
    }
    @objc func loadForegroundList(_ notification: NSNotification){
        let notificationData = notification.userInfo
        if let dict = notificationData as? [String: Any] {
            print("userInfo: ", dict)
            if let dictData = dict["action"] as? String{
                print(dictData)
                kNotificationAction = dictData
                if kNotificationAction == "PENDING"{
                    self.pendingRequestApi()
                  //  timer = Timer.scheduledTimer(timeInterval: 40.0, target: self, selector: #selector(startCancelledApiTimer(_:)), userInfo: nil, repeats: false)
                }
                 if kNotificationAction == "FEEDBACK"{
//                    kNotificationAction = "COMPLETED"
                    self.showAlert("Drive RideshareRates", message: "$" + "\(self.lastRideData?.total_amount  ?? "")"  + " " + "Amount is received successfully")
                   getLastRideDataApi()
                //    UpdateLotLng()
                    getearning()
                   
                }
            }
            if let dictDataRideID = dict["ride_id"] as? String{
                print(dictDataRideID)
                kRideId = dictDataRideID
            }
        }
    }
    @objc func startCancelledApiTimer(_ timer: Timer) {
        print("Cancelled Timer Start")
        if kNotificationAction == "PENDING" || kConfirmationAction  == "PENDING" {
            self.cancelRideStatus(rideId: kRideId)
        }
    }
    
    @IBAction func startRecordBtnAction(_ sender: Any) {
        var playBtn = sender as! UIButton
        if toggleState == 1 {
            //  player.play()
            toggleState = 2
            playBtn.backgroundColor = UIColor.red
            playBtn.setTitle("Stop Record", for: .normal)
            showToast(message: "Recording Started")
            startRecording()
        } else {
            // player.pause()
            toggleState = 1
            playBtn.backgroundColor = #colorLiteral(red: 0.262745098, green: 0.6235294118, blue: 0.1647058824, alpha: 1)
            playBtn.setTitle("Start Record", for: .normal)
            showToast(message: "Recording Stopped")
            finishRecording(success: true)
        }
    }
    
    @IBAction func navigateBtnAction(_ sender: Any) {
        
        let pickLat = self.lastRideData?.drop_lat  ?? ""
        let pickLong = self.lastRideData?.drop_long  ?? ""
        var destinationName = self.lastRideData?.drop_address
        let lat =  Double(pickLat)
        let long =  Double(pickLong)
        let encodedDestination = destinationName!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            //if phone has an app
            if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(encodedDestination)&directionsmode=driving") {
                if UIApplication.shared.canOpenURL(url) {
//                    let alert = UIAlertController(title: "Navigation Instructions", message: "Press 'Start' in Google Maps to begin navigation.", preferredStyle: .alert)
//                    let visibility: CGFloat = 0.4
//                    let blurEffect = UIBlurEffect(style: .light)
//                    let blurredEffectView = UIVisualEffectView(effect: blurEffect)
//                    blurredEffectView.alpha = visibility
//                    blurredEffectView.frame = view.bounds
//                    self.view.addSubview(blurredEffectView)
//                    let titleAttributes: [NSAttributedString.Key: Any] = [
//                        
//                        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
//                        NSAttributedString.Key.foregroundColor: UIColor.white,
//                    ]
//                    let messageAttributes: [NSAttributedString.Key: Any] = [
//                        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                        .foregroundColor: UIColor.white,
//                    ]
//
//                    let attributedTitle = NSAttributedString(string: "Navigation Instructions", attributes: titleAttributes)
//                    let attributedMessage = NSAttributedString(string: "Press 'Start' in Google Maps to begin navigation.", attributes: messageAttributes)
//
//                    // Set the attributed title and message
//                    alert.setValue(attributedTitle, forKey: "attributedTitle")
//                    alert.setValue(attributedMessage, forKey: "attributedMessage")
//                    alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.96)
//                    
//                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
//                        blurredEffectView.removeFromSuperview()
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    }
//                    alert.addAction(okAction)
                    //let urldestination2 = URL.init(string: "")
//
//                    present(alert, animated: true, completion: nil)
                } else {
                    
                    if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                        UIApplication.shared.open(urlDestination)
                    }
                }
            }
        }else{
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(encodedDestination)&directionsmode=driving") {
               // UIApplication.shared.open(urlDestination)
                UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
            }
        }
    }
    @IBAction func completeRideBtnAction(_ sender: Any) {
        
        
        if endtripBTN.currentTitle == "Leave \n stop"{
            
            
            self.Reachedatstop(status: "MID_STOP", location_status : "LEAVE_STOP")
            
            
        }else{
            kConfirmationStatus = "COMPLETED"
            mTimerView.isHidden = true
            kConfirmationStatus = "COMPLETED"
      
            CompleteRide(confirmStatus: "COMPLETED", acceptRejectView: acceptReject.completedStatus, time: totalwaittime )
            stopTimer()
        }
        
       
       // acceptRejectStatus(confirmStatus: kConfirmationStatus, acceptRejectView: acceptReject.completedStatus)
        
    }
    @IBAction func trackBtnAction(_ sender: Any) {
        print(kCurrentLocaLatLong)
        print(kDestinationLatLong)
      //  routingLines(origin: kCurrentLocaLatLong,destination: kDestinationLatLong)
        //  getPolylineRoute(source: kCurrentLocaLatLong, destination: kDestinationLatLong)
        print("track")
        let pickLat = self.lastRideData?.pickup_lat ?? ""
        let pickLong = self.lastRideData?.pickup_long ?? ""
        var destinationName = self.lastRideData?.pickup_adress
        let lat =  Double(pickLat)
        let long =  Double(pickLong)
        let encodedDestination = destinationName!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
         //   let encodedDestination = destinationName!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    
            if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(encodedDestination)&directionsmode=driving") {
                if UIApplication.shared.canOpenURL(url) {
//                    let alert = UIAlertController(title: "Navigation Instructions", message: "Press 'Start' in Google Maps to begin navigation.", preferredStyle: .alert)
//                    let visibility: CGFloat = 0.4
//                    let blurEffect = UIBlurEffect(style: .light)
//                    let blurredEffectView = UIVisualEffectView(effect: blurEffect)
//                    blurredEffectView.alpha = visibility
//                    blurredEffectView.frame = view.bounds
//                    self.view.addSubview(blurredEffectView)
//                    let titleAttributes: [NSAttributedString.Key: Any] = [
//                        
//                        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
//                        NSAttributedString.Key.foregroundColor: UIColor.white,
//                    ]
//                    let messageAttributes: [NSAttributedString.Key: Any] = [
//                        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                        .foregroundColor: UIColor.white,
//                    ]
//
//                    let attributedTitle = NSAttributedString(string: "Navigation Instructions", attributes: titleAttributes)
//                    let attributedMessage = NSAttributedString(string: "Press 'Start' in Google Maps to begin navigation.", attributes: messageAttributes)
//
//                    // Set the attributed title and message
//                    alert.setValue(attributedTitle, forKey: "attributedTitle")
//                    alert.setValue(attributedMessage, forKey: "attributedMessage")
//                    alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.96)
//                    
//                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
//                        blurredEffectView.removeFromSuperview()
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    }
//                    alert.addAction(okAction)
//                    
//                    present(alert, animated: true, completion: nil)
                  //  let urldestination2 = URL.init(string: "")
                } else {
                    
                    if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                       // UIApplication.shared.open(urlDestination)
                        
                        UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
                    }
                }
            }
        }else{
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(encodedDestination)&directionsmode=driving") {
               // UIApplication.shared.open(urlDestination)
                UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
            }
        }
    }
    @IBAction func callBtnAction(_ sender: Any) {
      //  kCustomerMobile.makeCall(phoneNumber: kCustomerMobile)
    }
    @IBAction func startBtnAction(_ sender: Any) {
        DispatchQueue.main.async {
//            let savedDictionary = UserDefaults.standard.object(forKey: "SavedCurrentLocation") as? [String: Any] ?? [String: Any]()
//            self.getDistanceAndDuration(from: savedDictionary["address2"] as? String  ?? "", to: (self.lastRideData?.pickup_adress)!)
            kConfirmationStatus = "START_RIDE"
           // self.UpdateLotLng()
            self.start(confirmStatus: kConfirmationStatus, acceptRejectView: acceptReject.startRideStatus)
           // self.navigatetodrop() 
            self.mnavView.isHidden = false
           
        }
//        startRideView.isHidden = true
//        accptRejectView.isHidden = true
//        recordView.isHidden = false
//        kConfirmationStatus = "START_RIDE"
//        UpdateLotLng()
//        acceptRejectStatus(confirmStatus: kConfirmationStatus, acceptRejectView: acceptReject.startRideStatus)
    }
    func navigatetodrop(){
        
        let pickLat = self.lastRideData?.drop_lat  ?? ""
        let pickLong = self.lastRideData?.drop_long  ?? ""
        var destinationName = self.lastRideData?.drop_address
        let lat =  Double(pickLat)
        let long =  Double(pickLong)
        let encodedDestination = destinationName!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
         //   let encodedDestination = destinationName!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""//if phone has an app
            if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(encodedDestination)&directionsmode=driving") {
                if UIApplication.shared.canOpenURL(url) {
//                    let alert = UIAlertController(title: "Navigation", message: "Navigating to google maps", preferredStyle: .alert)
//                    let visibility: CGFloat = 0.4
//                    let blurEffect = UIBlurEffect(style: .light)
//                    let blurredEffectView = UIVisualEffectView(effect: blurEffect)
//                    blurredEffectView.alpha = visibility
//                    blurredEffectView.frame = view.bounds
//                    self.view.addSubview(blurredEffectView)
//                    let titleAttributes: [NSAttributedString.Key: Any] = [
//                        
//                        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
//                        NSAttributedString.Key.foregroundColor: UIColor.white,
//                    ]
//                    let messageAttributes: [NSAttributedString.Key: Any] = [
//                        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                        .foregroundColor: UIColor.white,
//                    ]
//
//                    let attributedTitle = NSAttributedString(string: "Navigation", attributes: titleAttributes)
//                    let attributedMessage = NSAttributedString(string: "Navigating to google maps", attributes: messageAttributes)
//
//                    // Set the attributed title and message
//                    alert.setValue(attributedTitle, forKey: "attributedTitle")
//                    alert.setValue(attributedMessage, forKey: "attributedMessage")
//                    alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.96)
//                    
//                    let okAction = UIAlertAction(title: "GO", style: .cancel) { _ in
//                        blurredEffectView.removeFromSuperview()
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    }
//                    
//                    okAction.setValue(UIColor.green, forKey: "titleTextColor")
//                    // Set custom background color for OK action button
//                    if let view = okAction.value(forKey: "__representer") as? UIView {
//                        view.backgroundColor = UIColor.green // Change button background color to green
//                    }
//                    
//                    alert.addAction(okAction)
//                    
//                    present(alert, animated: true, completion: nil)
                } else {
                    
                    if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                        let urldestination2 = URL.init(string: "")
                        UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
                      //  UIApplication.shared.open(urlDestination)
                    }
                }
            }
        }else{
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(encodedDestination)&directionsmode=driving") {
               // UIApplication.shared.open(urlDestination)
                UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func acceptBtnAction(_ sender: Any) {
        
        self.timer?.invalidate()
        self.timer = nil
        self.progressView.progress = 0.0
        kConfirmationStatus = "ACCEPTED"
        accptRejectView.isHidden = true
        startRideView.isHidden = false
        recordView.isHidden = true
     //   UpdateLotLng()
        acceptRejectStatus(confirmStatus: kConfirmationStatus, acceptRejectView: acceptReject.acceptStatus)
        mnavView.isHidden = false
       // self.navigatetopickup()
//
//        let alert = UIAlertController(title: "Navigation", message: "Navigating to google maps", preferredStyle: .alert)
//        let visibility: CGFloat = 0.4
//        let blurEffect = UIBlurEffect(style: .light)
//        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
//        blurredEffectView.alpha = visibility
//        blurredEffectView.frame = view.bounds
//        self.view.addSubview(blurredEffectView)
//        let titleAttributes: [NSAttributedString.Key: Any] = [
//            
//            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
//            NSAttributedString.Key.foregroundColor: UIColor.white,
//        ]
//        let messageAttributes: [NSAttributedString.Key: Any] = [
//            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//            .foregroundColor: UIColor.white,
//        ]
//
//        let attributedTitle = NSAttributedString(string: "Navigation", attributes: titleAttributes)
//        let attributedMessage = NSAttributedString(string: "Navigating to google maps", attributes: messageAttributes)
//
//        // Set the attributed title and message
//        alert.setValue(attributedTitle, forKey: "attributedTitle")
//        alert.setValue(attributedMessage, forKey: "attributedMessage")
//        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.96)
//        
//        let okAction = UIAlertAction(title: "GO", style: .default) { _ in
//            blurredEffectView.removeFromSuperview()
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
//        alert.addAction(okAction)
//        
//        present(alert, animated: true, completion: nil)
        
        
        
    }
    func navigatetopickup(){
        let pickLat = self.lastRideData?.pickup_lat ?? ""
        let pickLong = self.lastRideData?.pickup_long ?? ""
        var destinationName = self.lastRideData?.pickup_adress
        let lat =  Double(pickLat)
        let long =  Double(pickLong)
        let encodedDestination = destinationName!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            
                    
            if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(encodedDestination)&directionsmode=driving") {
                if UIApplication.shared.canOpenURL(url) {
//                    let alert = UIAlertController(title: "Navigation ", message: "Navigating to google maps", preferredStyle: .alert)
//                    let visibility: CGFloat = 0.4
//                    let blurEffect = UIBlurEffect(style: .light)
//                    let blurredEffectView = UIVisualEffectView(effect: blurEffect)
//                    blurredEffectView.alpha = visibility
//                    blurredEffectView.frame = view.bounds
//                    self.view.addSubview(blurredEffectView)
//                    let titleAttributes: [NSAttributedString.Key: Any] = [
//                        
//                        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
//                        NSAttributedString.Key.foregroundColor: UIColor.white,
//                    ]
//                    let messageAttributes: [NSAttributedString.Key: Any] = [
//                        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                        .foregroundColor: UIColor.white,
//                    ]
//
//                    let attributedTitle = NSAttributedString(string: "Navigation ", attributes: titleAttributes)
//                    let attributedMessage = NSAttributedString(string: "Navigating to google maps", attributes: messageAttributes)
//
//                    // Set the attributed title and message
//                    alert.setValue(attributedTitle, forKey: "attributedTitle")
//                    alert.setValue(attributedMessage, forKey: "attributedMessage")
//                    alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.96)
//                    
//                    let okAction = UIAlertAction(title: "GO", style: .cancel) { _ in
//                        blurredEffectView.removeFromSuperview()
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    }
//                    okAction.setValue(UIColor.green, forKey: "titleTextColor")
//                    // Set custom background color for OK action button
//                    if let view = okAction.value(forKey: "__representer") as? UIView {
//                        view.backgroundColor = UIColor.green // Change button background color to green
//                    }
//                    alert.addAction(okAction)
//                    
//                    present(alert, animated: true, completion: nil)
                } else {
                    
                    if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                        UIApplication.shared.open(urlDestination)
                    }
                }
            }
        }else{
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(encodedDestination)&directionsmode=driving") {
               // UIApplication.shared.open(urlDestination)
                UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func rejecttBtnAction(_ sender: Any) {
        kConfirmationStatus = "CANCELLED"
        acceptRejectViewCase = acceptReject.cancelStatus
        startRideView.isHidden = true
        accptRejectView.isHidden = true
        confirmationView.isHidden = true
        recordView.isHidden = true
        acceptRejectStatus(confirmStatus: kConfirmationStatus, acceptRejectView: acceptReject.cancelStatus)
    }
    @IBAction func switchToggled(_ sender: UISwitch) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        
        if self.toggalBTN == ""{
            if self.change_vehicle == "yes"{
                my_switch.isOn = false
                self.showAlert("Driver RideshareRates", message: "Your vehicle is exipred.\nPlease change your vehicle")
            }else if self.Doc_Exp == "yes"{
                my_switch.isOn = false
                self.showAlert("Driver RideshareRates", message: "Your Document is exipred.\nPlease Update your Document")
            }else if self.Doc_Pend == "yes"{
                my_switch.isOn = false
                self.showAlert("Driver RideshareRates", message: "Your approval is still pending. We \nwill update you within 48 hours.")
            }else{
                if sender.isOn {
                    print( "The switch is now true!" )
                    NSUSERDEFAULT.set("1", forKey: kUpdateDriveStatus)
                    offlineOnlineLabel.text = "Online"
                    onOffStatus = onOff.online
                    my_switch.onTintColor = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
                    offlineOnlineBtn.setTitle("Online", for: .normal)
                    offlineOnlineBtn.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
                    selectServicesStatus = .isSelected
                    self.updateStatus(updateStatus: "1")
                    UIApplication.shared.isIdleTimerDisabled = true
                }else{
                    print( "The switch is now false!" )
                    NSUSERDEFAULT.set("3", forKey: kUpdateDriveStatus)
                    offlineOnlineLabel.text = "Offline"
                    onOffStatus = onOff.offline
                    my_switch.onTintColor = UIColor.red
                    offlineOnlineBtn.setTitle("Offline", for: .normal)
                    offlineOnlineBtn.backgroundColor = UIColor.red
                    selectServicesStatus = .isNotSelected
                    self.updateStatus(updateStatus: "3")
                    UIApplication.shared.isIdleTimerDisabled = false
                }
            }
        }else{
            my_switch.isOn = false
            self.showAlert("Driver RideshareRates", message: toggalBTN)
        }
    }
    @IBAction func markAsReceivedBtn(_ sender: Any) {
        print("Received")
        self.receivedMark()
    }
    
    
    @IBAction func offOnBtnAction(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        if self.toggalBTN == ""{
            if self.change_vehicle == "yes"{
                self.showAlert("Driver RideshareRates", message: "Your vehicle is exipred.\nPlease change your vehicle")
            }else if self.Doc_Exp == "yes"{
                my_switch.isOn = false
                self.showAlert("Driver RideshareRates", message: "Your Document is exipred.\nPlease Update your Document")
            }else if self.Doc_Pend == "yes"{
                my_switch.isOn = false
                self.showAlert("Driver RideshareRates", message: "Your approval is still pending. We \nwill update you within 48 hours.")
            }else{
                sender.isSelected = !sender.isSelected
                if sender.isSelected {
                    print("Offline")
                    sender.backgroundColor = UIColor.red
                    NSUSERDEFAULT.set("3", forKey: kUpdateDriveStatus)
                    offlineOnlineLabel.text = "Offline"
                    onOffStatus = onOff.offline
                    my_switch.tintColor = UIColor.red
                    offlineOnlineBtn.setTitle("Offline", for: .normal)
                    offlineOnlineBtn.backgroundColor = UIColor.red
                    my_switch.isOn = false
                    selectServicesStatus = .isNotSelected
                    self.updateStatus(updateStatus: "3")
                    UIApplication.shared.isIdleTimerDisabled = false
                } else {
                    print("Online")
                    sender.backgroundColor = UIColor.green
                    NSUSERDEFAULT.set("1", forKey: kUpdateDriveStatus)
                    offlineOnlineLabel.text = "Online"
                    onOffStatus = onOff.online
                    my_switch.onTintColor = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
                    offlineOnlineBtn.setTitle("Online", for: .normal)
                    offlineOnlineBtn.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
                    my_switch.isOn = true
                    selectServicesStatus = .isSelected
                    self.updateStatus(updateStatus: "1")
                    UIApplication.shared.isIdleTimerDisabled = true
                }
            }
        }else{
            self.showAlert("Driver RideshareRates", message: toggalBTN)
        }
       
    }
    @objc func changeRideTimer(_ timer: Timer) {
        print("CHANGE RIDE CALLING")
        self.changeRideStatus(rideId: kRideId, status: "PENDING")
    }
    @objc func pendingViewAutomatically(){
        self.pendingRequestApi()
    }
    @objc func cancelAutomatically(){
        var timerCountStatus = false
        if kRideId != "" && timerCountStatus == false {
            print("work 3 minutes")
            timerCountStatus = true
            if  kNotificationAction == "PENDING" && kConfirmationAction == "PENDING" {
                self.cancelRideStatus(rideId: kRideId)
            }
        }
        
    }
    @objc func onReceiveData(_ notification:Notification) {
        // Do something now //reload tableview
    }
    //MARK:- payemnt recived popup 
    func receivedMark() {
        let refreshAlert = UIAlertController(title: "Alert" , message: "Do you want to receive payment via Cash?", preferredStyle: UIAlertController.Style.alert)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]
        let messageAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.white,
        ]

        let attributedTitle = NSAttributedString(string: "Alert", attributes: titleAttributes)
        let attributedMessage = NSAttributedString(string: "Do you want to receive payment via Cash?", attributes: messageAttributes)

        // Set the attributed title and message
        refreshAlert.setValue(attributedTitle, forKey: "attributedTitle")
        refreshAlert.setValue(attributedMessage, forKey: "attributedMessage")
        refreshAlert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.96)
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
            if kRideId != "" {
                self.markReceivedApi(rideId: kRideId, updateDriverStatus: "1")
            }
         
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
}
extension StringProtocol  {
    var digits: [Int] { compactMap(\.wholeNumberValue) }
}
