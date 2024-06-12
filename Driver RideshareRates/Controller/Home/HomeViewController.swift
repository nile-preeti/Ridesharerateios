//
//  HomeViewController.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire
import AVFoundation
import Firebase
import FirebaseDatabase

extension UIView {

    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }


    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}
class HomeViewController: UIViewController {
    //MARK:- OUTLETS
    
    @IBOutlet var mstoplocLBL: UILabel!
    
    @IBOutlet var mlocationper: UIView!
    @IBOutlet var mGObtn : UIButton!
    @IBOutlet var mnavView: UIView!
    @IBOutlet var timerTitle : UILabel!
    @IBOutlet var mTimerView: UIView!
    @IBOutlet var mTimerLBL: UILabel!
   // @IBOutlet var waitingtimelbl: UILabel!
    @IBOutlet var callTechbtn : UIButton!
  //  @IBOutlet var technbtn : UIButton!
    @IBOutlet var reachedatdropBTN : UIButton!
    @IBOutlet var endtripBTN : UIButton!
    @IBOutlet var reachedatpickup: UIButton!
    @IBOutlet var cancelrideBTNN: UIButton!
    @IBOutlet var mStartRideeBTN: UIButton!
    @IBOutlet var mNearPOPview: UIView!
    @IBOutlet var mStartView: StarRateView!
    @IBOutlet var mNameLBL: UILabel!
    @IBOutlet var commentTF: UITextField!
    @IBOutlet var ratingView: UIView!
    @IBOutlet var mGoBTN: UIButton!
    @IBOutlet var mGostarttripeBTN: UIButton!
    @IBOutlet var mUserNAme: UILabel!
    @IBOutlet weak var mTotalEarning: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var confirmationView: SetView!
    @IBOutlet weak var fromAddressLbl: UILabel!
    @IBOutlet weak var toAddressLbl: UILabel!
    @IBOutlet weak var totalDistanceLbl: UILabel!
    @IBOutlet weak var totalFareLbl: UILabel!
    @IBOutlet weak var accptRejectView: UIView!
    @IBOutlet weak var startRideView: UIView!
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var offlineOnlineBtn: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var ServicesView: UIView!
    @IBOutlet weak var servicesList: UITableView!
    @IBOutlet weak var mDocumentPendingView: UIView!
    @IBOutlet weak var confrmVHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mExpireVehicle: UIView!
    var totalwaittime = 0
    var locationManager: CLLocationManager!
    var marker = GMSMarker()
    var update = true
    var customerData : userCustomerModal?
    var profileDetails : ProfileData?
    let conn = webservices()
    var acceptRejectViewCase = acceptReject.acceptStatus
    var arrayPolyline = [GMSPolyline]()
    var startLOC = CLLocation()
    var endLOC = CLLocation()
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var toggleState = 1
    
    var recordSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var settings = [String : Int]()
    var onOffStatus = onOff.online
    var selectServicesStatus = selectServices.isNotSelected
    var onOffValue = ""
    weak var timer: Timer?
    var pendingReqData = [RidesData]()
    var pendingRideId = ""
    var isChecked = true
    // Bool property
    var  checkBtnStatusServices = false
    var selectedIndexServices  = 0
    var servicesData = [ServicesModel]()
    var  checkBtnStatus = false
    var selectedIndex  = 0
    var vehicleTypeId = ""
    var vehicleTypeStatus = ""
    var arrSelectedRows:[IndexPath] = []
    var arrSelectedRowsStatus:[String] = []
    var rowsWhichAreChecked = [NSIndexPath]()
    var arrSelectedRowsNew:[Int] = []
    var arrnotSelectedRowsNew:[Int] = []
    //  let my_switch = UISwitch(frame: .zero)
    var selectedRows:[IndexPath] = []
    // toggalswitch
    var toggalBTN = ""
    var change_vehicle = ""
    var Doc_Exp = ""
    var Doc_Pend = ""
    var progressTimer: Timer?
    var Dtime = 0.0
    var bearing = 0.0
    var bearingAccuracy = 0.0
    var currentLocation: CLLocation?
    var updateTimer: Timer?
    var carMarker: GMSMarker?
       var pathPolyline: GMSPolyline?
    var destinationLocation: CLLocationCoordinate2D?
    var secs = 0
    var timerS : Timer?
    var locationManager2 = CLLocationManager()
    
    @IBOutlet weak var amountLblFinal: UILabel!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var my_switch: UISwitch!
    @IBOutlet weak var offlineOnlineLabel: UILabel!
    
    
    @IBOutlet weak var mOnoffToggalBTN: UIButton!
    
    @IBOutlet weak var mactionRLBL: UILabel!
    var arr = ["Pending","Pending","Pending","Pending","Pending","Pending"]
    var lastRideData : LastRideModal?
    var pendingLastRideStatus = false
    let dispatchGroup = DispatchGroup()
    var section = ["",""]
    // var progressTimer = Timer()
    var counter: Int = 0;
    var total: Int = 40;
    weak var timerr: Timer?
    var count = 0
    var totalCount = 0
    var stoptimer = ""
    var appMovedToForegroundStatus = false
    //MARK:- Variables
    var ref: DatabaseReference!
    var ref2: DatabaseReference!
    var currentLocationn: String?
    
    var timerL : Timer?
    var locManager : CLLocationManager!
    var atpickupordrop = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        mlocationper.isHidden = true
        mTimerView.isHidden = true
        mnavView.isHidden = true
     //   self.waitingtimelbl.isHidden = true
        //  CurrentLocation()
        reachedatpickup.titleLabel?.textAlignment = .center
        reachedatdropBTN.titleLabel?.textAlignment = .center
       //    technbtn.isHidden = true
        callTechbtn.isHidden = true
        UpdateLotLngD()
        // UpdateLotLngD()
     //   UpdateLotLng()
    //   updateAppVersionPopup()
        self.registerCell()
        mGObtn.layer.cornerRadius = 22
        reachedatdropBTN.layer.cornerRadius = 18
        self.mDocumentPendingView.isHidden = true
        self.mExpireVehicle.isHidden = true
        self.mDocumentPendingView.layer.cornerRadius = 5
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        paymentView.isHidden = true
        ServicesView.isHidden = true
        //        self.mStartRideeBTN.isHidden = true
        //        self.mGoBTN.isHidden = false
        self.ratingView.isHidden = true
        progressView.progress = 0.0
        //  self.my_switch.isUserInteractionEnabled = true
        if let savedPeople = UserDefaults.standard.object(forKey: "loginInfo") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [String: Any] {
                print("Local Saved Login Data====\(decodedPeople)")
                if let user_id = decodedPeople["user_id"] as? String {
                    NSUSERDEFAULT.set(user_id, forKey: kUserID)
                }
                if let fcm = decodedPeople["gcm_token"] as? String {
                    NSUSERDEFAULT.set(fcm, forKey: kFcmToken )
                    print("GCM TOKEN IS HERE \(NSUSERDEFAULT.value(forKey: kFcmToken) ?? "")")
                }
            }
        }
        print(NSUSERDEFAULT.value(forKey: accessToken))
        print("FCM TOKEN IS HERE \(NSUSERDEFAULT.value(forKey: kFcmToken) ?? "")")
        self.setNavButton()
        self.mapView.isMyLocationEnabled = true
        self.setUpLocation()
        // self.setUpAudioRecording()
        NotificationCenter.default.addObserver(self, selector: #selector(loadBackgroundList), name: NSNotification.Name(rawValue: "ReceiveDataBackground"), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadForegroundList), name: NSNotification.Name(rawValue: "ReceiveDataForeground"), object: nil)
        self.appMovedToForegroundStatus = true
        getearning()
        logoutAPI()
        applyMapStyle()
         startPulsing()
        mStartRideeBTN.layer.cornerRadius = 18
      //  self.mStartRideeBTN.applyGradient(colours: [ #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)])
        //        addBorderToButton()
        //        startRadarPulsingAnimation()
      //  updateAppVersionPopup()
        requestLocationPermission()
          
    }
    func requestLocationPermission() {
        // Check if location services are enabled
        if CLLocationManager.locationServicesEnabled() {
            // Check the authorization status
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                // Request authorization when the status is not determined
                locationManager2.requestWhenInUseAuthorization() // Or requestAlwaysAuthorization() depending on your needs
            case .denied, .restricted:
                // Prompt user to enable location services in settings
                mlocationper.isHidden = false
//                print("Location services are disabled. Please enable them in Settings.")
//                let alert = UIAlertController(title: "Location", message: "Location services are disabled. Please enable them in Settings.", preferredStyle: .alert)
//                                   let visibility: CGFloat = 0.4
//                                   let blurEffect = UIBlurEffect(style: .light)
//                                   let blurredEffectView = UIVisualEffectView(effect: blurEffect)
//                                   blurredEffectView.alpha = visibility
//                                   blurredEffectView.frame = view.bounds
//                                   self.view.addSubview(blurredEffectView)
//                                   let titleAttributes: [NSAttributedString.Key: Any] = [
//               
//                                       NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
//                                       NSAttributedString.Key.foregroundColor: UIColor.white,
//                                   ]
//                                   let messageAttributes: [NSAttributedString.Key: Any] = [
//                                       NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                                       .foregroundColor: UIColor.white,
//                                   ]
//               
//                                   let attributedTitle = NSAttributedString(string: "Location", attributes: titleAttributes)
//                                   let attributedMessage = NSAttributedString(string: "Location services are disabled. Please enable them in Settings.", attributes: messageAttributes)
//               
//                                   // Set the attributed title and message
//                                   alert.setValue(attributedTitle, forKey: "attributedTitle")
//                                   alert.setValue(attributedMessage, forKey: "attributedMessage")
//                                   alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.96)
//               
//                                   let okAction = UIAlertAction(title: "OK", style: .default) { _ in
//                                       blurredEffectView.removeFromSuperview()
//                                       self.redirectToLocationSettings()
//                                      // UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                                   }
//                                   alert.addAction(okAction)
//               
//                present(alert, animated: true, completion: nil)
                
            case .authorizedWhenInUse, .authorizedAlways:
                // Location services are already enabled
                print("Location services are already enabled.")
            @unknown default:
                fatalError()
            }
        } else {
            // Location services are not enabled on the device
            print("Location services are not enabled on this device.")
        }
    }
    func redirectToLocationSettings() {
        if let bundleIdentifier = Bundle.main.bundleIdentifier,
           let settingsURL = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
    func handleAppDidBecomeActive() {
            // Code to execute when app becomes active
            print("App became active!")
        startPulsing()
        getLastRideDataApi()
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
    func startPulsing(){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.2
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.autoreverses = true
        animation.repeatCount = .infinity
       // self.mStartRideeBTN.applyGradient(colours: [ #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)])
        reachedatpickup.layer.add(animation, forKey: "pulsing")
        mStartRideeBTN.layer.add(animation, forKey: "pulsing")
        reachedatdropBTN.layer.add(animation, forKey: "pulsing")
        endtripBTN.layer.add(animation, forKey: "pulsing")
       // mStartRideeBTN.layer.add(animation, forKey: "pulsing")
    }
    //    func startBTNPulsing() {
    //        let animation = CABasicAnimation(keyPath: "transform.scale")
    //        animation.toValue = 1.2
    //        animation.duration = 1.0
    //        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
    //        animation.autoreverses = true
    //        animation.repeatCount = .infinity
    //        mGoBTN.layer.removeAnimation(forKey: "pulsing")
    //        mGostarttripeBTN.layer.add(animation, forKey: "pulsing")
    //        mStartRideeBTN.layer.add(animation, forKey: "pulsing")
    //    }
    func applyMapStyle() {
        // Retrieve the style URL from the JSON file
        guard let styleURL = Bundle.main.url(forResource: "dark_map_style", withExtension: "json") else {
            return
        }
        
        do {
            // Load the JSON file and create a GMSMapStyle object
            let mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            
            // Apply the custom style to the map view
            self.mapView.mapStyle = mapStyle
        } catch {
            print("Error loading map style: \(error)")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        NSUSERDEFAULT.set("no", forKey: checknotifi)
        print("ViewWILLappear call")
        //KKself.appUpdateAvailable()
        DispatchQueue.main.async {
            self.startPulsing()
            self.getdocumentaApi()
        }
        let onOffTap = NSUSERDEFAULT.value(forKey: kUpdateDriveStatus) as? String
        if onOffStatus == onOff.online  &&   onOffTap == "1" {
            onOffValue = "Online"
            offlineOnlineLabel.text = "Online"
            my_switch.isOn = true
            my_switch.onTintColor = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
            self.updateStatus(updateStatus: "1")
            NSUSERDEFAULT.set("1", forKey: kUpdateDriveStatus)
            offlineOnlineBtn.setTitle("Online", for: .normal)
            offlineOnlineBtn.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
            getLastRideDataApi()
            //
        }
        else{
            offlineOnlineBtn.setTitle("Offline", for: .normal)
            offlineOnlineBtn.backgroundColor = UIColor.red
            onOffValue = "Offline"
            offlineOnlineLabel.text = "Offline"
            my_switch.isOn = false
            my_switch.tintColor = UIColor.red
            self.updateStatus(updateStatus: "3")
            NSUSERDEFAULT.set("3", forKey: kUpdateDriveStatus)
        }
        
        DispatchQueue.main.async {
            print("FIRST")
            NavigationManager.pushToLoginVC(from: self)
        }
        
        
        DispatchQueue.main.async {
            self.timerL = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { (timer) in
              //  self.UpdateLotLng()
                self.checkonline()
            }
        }
        DispatchQueue.main.async {
            print("FIRST")
            self.getProfileDataApi()
        }
        DispatchQueue.main.async {
            print("SECOND")
            self.getSelectServicesApi()
        }
        DispatchQueue.main.async {
            print("THIRD")
            
            self.pendingRequestApi()
        }
        
    }
    // MARK: Check AppVersion
//    func updateAppVersionPopup(){
//        _ = try? VersionCheck.shared.isUpdateAvailable { (update, error) in
//            DispatchQueue.main.async {
//                if let error = error {
//                    print(error)
//                } else if let update = update {
//                    print("update12",update)
//                    if update == true {
//                        let refreshAlert = UIAlertController(title: Singleton.shared!.title , message: "Please update new version", preferredStyle: UIAlertController.Style.alert)
//                        let titleAttributes: [NSAttributedString.Key: Any] = [
//                            
//                            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
//                            NSAttributedString.Key.foregroundColor: UIColor.white,
//                        ]
//                        let messageAttributes: [NSAttributedString.Key: Any] = [
//                            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                            .foregroundColor: UIColor.white,
//                        ]
//                        
//                        let attributedTitle = NSAttributedString(string: Singleton.shared!.title, attributes: titleAttributes)
//                        let attributedMessage = NSAttributedString(string: "Please update new version", attributes: messageAttributes)
//                        
//                        // Set the attributed title and message
//                        refreshAlert.setValue(attributedTitle, forKey: "attributedTitle")
//                        refreshAlert.setValue(attributedMessage, forKey: "attributedMessage")
//                        refreshAlert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.96)
//                        refreshAlert.addAction(UIAlertAction(title: "UPDATE", style: .destructive, handler: { (action: UIAlertAction!) in
//                            self.openAppStore()
//                        }))
//                        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//                        }))
//                        self.present(refreshAlert, animated: true, completion: nil)
//                        //                  upgradeAvailable = true
//                        //                  versionAvailable = version
//                    }
//                }
//            }
//        }
//        
//    }
    func logoutAPI(){
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "updateloginlogout", params: ["status" : 1], authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                //    self.logO()
            }
        }
    }
    
    //MARK:- update and left
//    func UpdateLotLng(){
//        locManager = CLLocationManager()
//        locManager.delegate = self
//        locManager.requestAlwaysAuthorization()
//        locManager.startUpdatingLocation()
//        locManager.allowsBackgroundLocationUpdates = true
//        locManager.desiredAccuracy = kCLLocationAccuracyBest
//        
////        self.locManager.delegate = self
////               self.locManager.requestWhenInUseAuthorization()
////               self.locManager.startUpdatingHeading()
//        
//        //   locManager.allowsBackgroundLocationUpdates = true
//        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
//            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
//            guard let currentLocation = locManager.location else {
//                return
//            }
//            let LatitudeGPS = String(format: "%.10f", locManager.location!.coordinate.latitude)
//            let LongitudeGPS = String(format: "%.10f", locManager.location!.coordinate.longitude)
//            let speedGPS = String(format: "%.3f", locManager.location!.speed)
//            let Altitude = String(format: "%.3f", locManager.location!.altitude)
//            print("loc update")
//            let currentLocationLat = currentLocation.coordinate.latitude as! Double
//            let currentLocationLng = currentLocation.coordinate.longitude as! Double
//            
//            kCurrentLocaLat = LatitudeGPS
//            kCurrentLocaLong = LongitudeGPS
//            //    updateCurrentLocation(lat: kCurrentLocaLat, long: kCurrentLocaLong)
//            var location = locManager.location
//            let time = location?.timestamp.timeIntervalSinceReferenceDate as! Double
//            
//            let speedAccuracyMetersPerSecond = location?.speedAccuracy as! Double
//            var accuracy = Double()
//            if #available(iOS 13.4, *) {
//                accuracy = location?.courseAccuracy as! Double
//            } else {
//                accuracy = 0.0
//                // Fallback on earlier versions
//            }
//            let verticalAccuracyMeters = location?.verticalAccuracy as! Double
//            if kRideId != ""{
//                self.ref = Database.database().reference()
//                
//                let dict:Dictionary<String, Any>? = ["accuracy": accuracy,
//                                                     "bearing" : self.bearing,
//                                                     "bearingAccuracyDegrees" : self.bearingAccuracy,
//                                                     "complete" : true,
//                                                     "fromMockProvider" : false,
//                                                     "provider": "fused",
//                                                     "speedAccuracyMetersPerSecond": speedAccuracyMetersPerSecond,
//                                                     "verticalAccuracyMeters":verticalAccuracyMeters,
//                                                     "elapsedRealtimeNanos": 0,
//                                                     "elapsedRealtimeUncertaintyNanos": 0,
//                                                     "latitude": currentLocationLat,
//                                                     "longitude": currentLocationLng,
//                                                     "altitude":Altitude,
//                                                     "speed":speedGPS,
//                                                     "time":time]
//                print(dict!)
//                let name = NSUSERDEFAULT.value(forKey: kName) as? String ?? ""
//                //  self.ref?.child("rides").childByAutoId().child(kRideId).setValue(dict)
//                DispatchQueue.main.asyncAfter(deadline: .now() + Dtime) {
//                    self.Dtime = 60.0
//                    if kRideId != ""{
//                        let refss = self.ref?.child("rides").child(name + kRideId).child(kRideId).setValue(dict){ (error, _) in
//                            //  print(refss)
//                            if let error = error {
//                                print("Error saving driver data: \(error.localizedDescription)")
//                            } else {
//                                print("Driver data saved successfully")
//                            }
//                            //   let refs = self.ref.child(name + kRideId).child(kRideId)
//                            //    refs.setValue(dict)
//                            
//                            // print(refs)
//                            self.UpdateLotLngD()
//                        }
//                    }
//                }
//            }
//        }
//        
//    }
//    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//           // Bearing
//        self.bearing = newHeading.trueHeading
//           
//           // Bearing accuracy degrees
//           let bearingAccuracyDegrees = newHeading.headingAccuracy
//           
//           print("Bearing: \(bearing), Bearing Accuracy Degrees: \(bearingAccuracyDegrees)")
//       }
    //MARK:- update and left
    func UpdateLotLngD(){
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.requestAlwaysAuthorization()
        locManager.startUpdatingLocation()
       locManager.startUpdatingHeading()
        locManager.allowsBackgroundLocationUpdates = true
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //   locManager.allowsBackgroundLocationUpdates = true
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else {
                return
            }
            
            
            if let currentLocation = self.locManager.location {
                let geocoder = CLGeocoder()
                
                geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
                    if let error = error {
                        print("Reverse geocoding failed with error: \(error.localizedDescription)")
                        return
                    }
                    
                    if let placemark = placemarks?.first {
                        // Access the address components as needed
                        let address = "\(placemark.subThoroughfare ?? "") \(placemark.thoroughfare ?? ""), \(placemark.locality ?? "") \(placemark.administrativeArea ?? "") \(placemark.postalCode ?? "") \(placemark.country ?? "")"
                        
                        self.currentLocationn = address
                        print("Current Location: \(self.currentLocationn)")
                    }
                }
            }
            
            
            //            let LatitudeGPS = String(format: "%.10f", locManager.location!.coordinate.latitude)
            //            let LongitudeGPS = String(format: "%.10f", locManager.location!.coordinate.longitude)
            //            let speedGPS = String(format: "%.3f", locManager.location!.speed)
            //            let Altitude = String(format: "%.3f", locManager.location!.altitude)
            //        //    let Course = String(format: "%.3f", locManager.location!.course)
            //            print("loc update")
            
            //            DispatchQueue.main.async {
            //                print("FIRST")
            //                self.checkdevicetokenAPI()
            //            }
            //
            let currentLocationLat = currentLocation.coordinate.latitude as! Double
            let currentLocationLng = currentLocation.coordinate.longitude as! Double
            
            //            kCurrentLocaLat = LatitudeGPS
            //            kCurrentLocaLong = LongitudeGPS
            //        //    updateCurrentLocation(lat: kCurrentLocaLat, long: kCurrentLocaLong)
            //            var location = locManager.location
            //            let time = location?.timestamp.timeIntervalSinceReferenceDate as! Double
            //
            //            let speedAccuracyMetersPerSecond = location?.speedAccuracy as! Double
            //            var accuracy = Double()
            //            if #available(iOS 13.4, *) {
            //                 accuracy = location?.courseAccuracy as! Double
            //            } else {
            //                accuracy = 0.0
            //                // Fallback on earlier versions
            //            }
            //            let verticalAccuracyMeters = location?.verticalAccuracy as! Double
            let UserID = NSUSERDEFAULT.value(forKey: kUserID) as? String ?? ""
            if UserID != ""{
                self.ref2 = Database.database().reference()
                
                let driverlat = String(currentLocationLat)
                    let driverlong = String(currentLocationLng)
                let driverbearing = String(self.bearing)
                let dict:Dictionary<String, String>? = ["userID": UserID,
                                                     "bearing" : driverbearing,
                                                     "latitude": driverlat,
                                                     "longitude": driverlong]
                print(dict!)
                let name = NSUSERDEFAULT.value(forKey: kName) as? String ?? ""
                let UserID = NSUSERDEFAULT.value(forKey: kUserID) as? String ?? ""
                // NSUSERDEFAULT.set(userId, forKey: kUserID)
                //  self.ref?.child("rides").childByAutoId().child(kRideId).setValue(dict)
                
                //  let refs = self.ref2?.child("Driver").child(name + UserID).child(kUserID).setValue(dict)
                let ref2s = self.ref2?.child("driver").child(UserID).setValue(dict){ (error, _) in
                  //  print(ref2s)
                    if let error = error {
                        print("Error saving driver data: \(error.localizedDescription)")
                    } else {
                        print("Driver data saved successfully")
                    }
                    //   let refs = self.ref.child(name + kRideId).child(kRideId)
                    //    refs.setValue(dict)
                  //  print(ref2)
                    // print(ref2s)
                    
                }
                //   let refs = self.ref.child(name + kRideId).child(kRideId)
                //    refs.setValue(dict)
                
                
            }
        }
    }
    //MARK:- check online offline status
    func checkonline(){
        let onOffTap = NSUSERDEFAULT.value(forKey: kUpdateDriveStatus) as? String
        let checked = NSUSERDEFAULT.value(forKey: checknotifi) as? String
        if onOffTap == "1" && checked == "no"{
            getLastRideDataApi()
        }
    }
    
    //    func appUpdateAvailable() -> (Bool,String?) {
    //
    //            guard let info = Bundle.main.infoDictionary,
    //                  let identifier = info["CFBundleIdentifier"] as? String else {
    //                return (false,nil)
    //            }
    //
    //    //        let storeInfoURL: String = "http://itunes.apple.com/lookup?bundleId=\(identifier)&country=IN"
    //            var upgradeAvailable = false
    //            var versionAvailable = ""
    //            // Get the main bundle of the app so that we can determine the app's version number
    //            let bundle = Bundle.main
    //            if let infoDictionary = bundle.infoDictionary {
    //                // The URL for this app on the iTunes store uses the Apple ID for the  This never changes, so it is a constant
    //                let urlOnAppStore = NSURL(string: storeInfoURL)
    //                if let dataInJSON = NSData(contentsOf: urlOnAppStore! as URL) {
    //                    // Try to deserialize the JSON that we got
    //                    if let dict: NSDictionary = try? JSONSerialization.jsonObject(with: dataInJSON as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject] as NSDictionary? {
    //                        if let results:NSArray = dict["results"] as? NSArray {
    //                            if let version = (results[0] as! [String:Any])["version"] as? String {
    //                                // Get the version number of the current version installed on device
    //                                if let currentVersion = infoDictionary["CFBundleShortVersionString"] as? String {
    //                                    // Check if they are the same. If not, an upgrade is available.
    //                                    print("\(version)")
    //                                    if version != currentVersion {
    //                                        let refreshAlert = UIAlertController(title: Singleton.shared!.title , message: "Please update new version", preferredStyle: UIAlertController.Style.alert)
    //                                        refreshAlert.addAction(UIAlertAction(title: "UPDATE", style: .destructive, handler: { (action: UIAlertAction!) in
    //                                            self.openAppStore()
    //                                        }))
    //                                        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
    //                                        }))
    //                                       present(refreshAlert, animated: true, completion: nil)
    //                                        upgradeAvailable = true
    //                                        versionAvailable = version
    //                                    }
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //            return (upgradeAvailable,versionAvailable)
    //        }
    //MARK:- open app store
//    func openAppStore() {
//        // "https://itunes.apple.com/us/app/itunes-connect/id376771144"
//        if let url = URL(string: "itms-apps://itunes.apple.com/app/id376771144"),
//           UIApplication.shared.canOpenURL(url){
//            UIApplication.shared.open(url, options: [:]) { (opened) in
//                if(opened){
//                    print("App Store Opened")
//                }
//            }
//        } else {
//            print("Can't Open URL on Simulator")
//        }
//    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ReceiveDataBackground"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ReceiveDataForeground"), object: nil)
    }
    @IBAction func cancelRideBTNN(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelRideVCPopupID") as! CancelRideVCPopup
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func mOnOffToggalBTN(_ sender: Any) {
        //        if mOnoffToggalBTN.currentTitle == "offline"{
        //            self.updateStatus(updateStatus: "1")
        //        }else{
        //            self.updateStatus(updateStatus: "3")
        //        }
    }
    @IBAction func TechnicalIssueBTN(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TechnicalViewControllerPopUPID") as! TechnicalViewControllerPopUP
//        vc.delegate = self
//        vc.modalPresentationStyle = .overFullScreen
//        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func mExpireVehicleBTN(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //    func CheckDistance(lat:Double, lng: Double){
    //        locManager.requestWhenInUseAuthorization()
    //        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
    //            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
    //            guard let currentLocation = locManager.location else {
    //                return
    //            }
    //            print(currentLocation.coordinate.latitude)
    //            print(currentLocation.coordinate.longitude)
    //
    //            let currentLocationLat = currentLocation.coordinate.latitude as! Double
    //            let currentLocationLng = currentLocation.coordinate.longitude as! Double
    //
    //            let coordinate₀ = CLLocation(latitude: lat, longitude: lng)
    //            let coordinate₁ = CLLocation(latitude: currentLocationLat, longitude: currentLocationLng)
    //
    //            var from = String()
    //            reverseGeocodeLocation(lat: lat, lng: lng) { locationName in
    //                if let locationName = locationName {
    //                    from = locationName
    //                    print("Location: \(locationName)")
    //                } else {
    //                    print("Unable to determine location name")
    //                }
    //            }
    //            var to = String()
    //            reverseGeocodeLocation(lat: currentLocationLat, lng: currentLocationLng) { locationName in
    //                if let locationName = locationName {
    //                    to = locationName
    //                    print("Location: \(locationName)")
    //                    let apiKey = "AIzaSyByga05rgV6dTqTnpBcR0HFiSbWoSxp_3s"
    //                    DispatchQueue.main.async {
    //                        self.getDistanceAndDuration(from: from, to: to, apiKey: apiKey)
    //                    }
    //                } else {
    //                    print("Unable to determine location name")
    //                }
    //            }
    //        }
    //    }
    
    //    func reverseGeocodeLocation(lat: Double, lng: Double, completionHandler: @escaping (String?) -> Void) {
    //        let location = CLLocation(latitude: lat, longitude: lng)
    //        let geocoder = CLGeocoder()
    //
    //        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
    //            if let error = error {
    //                print("Reverse geocoding error: \(error.localizedDescription)")
    //                completionHandler(nil)
    //                return
    //            }
    //            if let placemark = placemarks?.first {
    //                if let name = placemark.name,
    //                   let locality = placemark.locality {
    //                    let locationName = "\(name), \(locality)"
    //                    completionHandler(locationName)
    //                } else {
    //                    completionHandler(nil)
    //                }
    //            } else {
    //                completionHandler(nil)
    //            }
    //        }
    //    }
//    func getDistanceAndDuration(from: String, to: String){
////        startride()
////    }
////    {
//     //   let apiKey = "AIzaSyABQXS9DNSgpuGVZnC5bwfpj1mrl4dd4Z8"
//        let bundleID = "com.driverchime.app"
//        let baseURL = "https://maps.googleapis.com/maps/api/distancematrix/json"
//        let origin = DcurrentLocation.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let destination = to.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let urlString = "\(baseURL)?units=imperial&origins=\(origin)&destinations=\(destination)&key=AIzaSyABQXS9DNSgpuGVZnC5bwfpj1mrl4dd4Z8"
//        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        
//        let header: HTTPHeaders = [ "Accept": "application/json", "Content-Type": "application/json" ]
//        if let url = URL(string: urlString) {
//            var request = URLRequest(url: url)
//            
//            // Add a custom header with the bundle ID
//            request.addValue(bundleID, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
//            
//            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                if let error = error {
//                    print("Error: \(error.localizedDescription)")
//                    return
//                }
//                guard let data = data else {
//                    print("No data received")
//                    return
//                }
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                    // Process the JSON response here
//                    print(json ?? "Invalid JSON")
//                    if let jsonDict = json as? [String: Any],
//                       let rows = jsonDict["rows"] as? [[String: Any]],
//                       let firstRow = rows.first,
//                       let elements = firstRow["elements"] as? [[String: Any]],
//                       let firstElement = elements.first,
//                       let distance = firstElement["distance"] as? [String: Any],
//                       let duration = firstElement["duration"] as? [String: Any] {
//                        if let distanceText = distance["text"] as? String,
//                           let durationText = duration["text"] as? String {
//                            print("Duration: \(durationText)")
//                          //  self.timeD = durationText
//                            print("Distance: \(distanceText)")
//                            DispatchQueue.main.async {
//                                if distanceText.contains("mi"){
//                                    let cleanedDistanceText = distanceText.replacingOccurrences(of: " mi", with: "")
//                                    if Double(cleanedDistanceText)! <= 0.1{
////                                            self.mStartRideeBTN.isHidden = false
////                                            self.mGoBTN.isHidden = true
////                                            self.startBTNPulsing()
//                                        
//                                        if self.atpickupordrop == "pickup" {
//                                            self.Reachedapi(status: "ACCEPTED", location_status : "YES")
//                                        }else if self.atpickupordrop == "drop"{
//                                            self.Reachedapi(status: "START_RIDE", location_status : "AT_DESTINATION")
//                                        }
//                                       
//                                    }else{
//                                        if self.atpickupordrop == "pickup" {
//                                            
//                                            self.showAlert("Driver RideshareRates", message: "You are not nearby pickup location yet")
//                                        }else{
//                                            self.showAlert("Driver RideshareRates", message: "You are not nearby drop location yet")
//                                        }
//                                    }
//                                    }
//                                }
//                            DispatchQueue.main.async {
//                                if distanceText.contains("ft"){
//                                   // let cleanedDistanceText = distanceText.replacingOccurrences(of: " ft", with: "")
////                                        self.mStartRideeBTN.isHidden = false
////                                        self.mGoBTN.isHidden = true
////                                        self.startBTNPulsing()
//                                    if self.atpickupordrop == "pickup" {
//                                        self.Reachedapi(status: "ACCEPTED", location_status : "YES")
//                                    }else if self.atpickupordrop == "drop"{
//                                        self.Reachedapi(status: "START_RIDE", location_status : "AT_DESTINATION")
//                                    }
//                                   
//                                }else{
//                                    if self.atpickupordrop == "pickup" {
//                                        
//                                        self.showAlert("Driver RideshareRates", message: "You are not nearby pickup location yet")
//                                    }else{
//                                        self.showAlert("Driver RideshareRates", message: "You are not nearby drop location yet")
//                                    }
//                                }
//                                    
//                                    
//                                }
//                            }
//                        
//                    }
//                } catch {
//                    print("Error decoding JSON: \(error.localizedDescription)")
//                }
//            }
//            
//            task.resume()
//        }
//   
//    }
   
    @IBAction func mDoneBTN(_ sender: Any) {
   
        let modalData = lastRideData
        if kRating == ""{
            self.showAlert("Driver RideshareRates", message: "Please provide the rating.")
        }
        else{
            let index = IndexPath(row: 0, section: 0)
            let kCommentRating = commentTF.text!
            self.postFeedBackApi(ride_id: modalData?.ride_id ?? "", rating: kRating, comment: kCommentRating, rider_id: modalData?.user_id ?? "")
            commentTF.text = ""
        }
        
    }
    
    @IBAction func mNoThanksBTN(_ sender: Any) {
        self.ratingView.isHidden = true
        let modalData = lastRideData
//        if kRating == ""{
//
//        }
//        else{
//            let index = IndexPath(row: 0, section: 0)
//            let cell: RideCompletedCell = self.ride_tableView.cellForRow(at: index) as! RideCompletedCell
            let kCommentRating = commentTF.text!
        //    if  getCellsDataOn(){
                self.postFeedBackApi(ride_id: modalData?.ride_id ?? "", rating: kRating, comment: kCommentRating, rider_id: modalData?.user_id ?? "")
                commentTF.text = ""
//            }
//            else{
//
//            }
  //     }
    }
    
    @IBAction func mStartridePOPUPbtn(_ sender: Any) {
//        DispatchQueue.main.async {
//            let savedDictionary = UserDefaults.standard.object(forKey: "SavedCurrentLocation") as? [String: Any] ?? [String: Any]()
//          self.getDistanceAndDuration(from: savedDictionary["address2"] as? String  ?? "", to: (self.lastRideData?.pickup_adress)!)
//
//        }
       
        
        
    }
    func startride(){
//        self.mStartRideeBTN.isHidden = true
//        self.mGoBTN.isHidden = false
        kConfirmationStatus = "START_RIDE"
      //  self.UpdateLotLng()
        self.start(confirmStatus: kConfirmationStatus, acceptRejectView: acceptReject.startRideStatus)
        
    }
    
    @IBAction func reachedatPickupBtn(_ sender: Any){
        stopTimer()
        atpickupordrop = "pickup"
        distance()
//        let savedDictionary = UserDefaults.standard.object(forKey: "SavedCurrentLocation") as? [String: Any] ?? [String: Any]()
//      self.getDistanceAndDuration(from: savedDictionary["address2"] as? String  ?? "", to: (self.lastRideData?.pickup_adress)!)
        
      //  Reachedapi(status: "ACCEPTED", location_status : "YES")
    }
    @IBAction func reachedatdropbtn(_ sender: Any){
        
        if reachedatdropBTN.currentTitle == "AT \n STOP"{
            self.Reachedatstop(status: "MID_STOP", location_status : "AT_STOP")
            
            
        }else{
            stopTimer()
            atpickupordrop = "drop"
            distance()
        }
        
    }
   
    @IBAction func callbtn (_ sender: Any){
        kCustomerMobile.makeCall(phoneNumber: kCustomerMobile)
    }
    
    @IBAction func technicalBTN (_ sender: Any){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TechnicalViewControllerPopUPID") as! TechnicalViewControllerPopUP
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func mGobtn(_ sender: Any){
        mnavView.isHidden = true
        if kConfirmationStatus == "START_RIDE"{
            self.navigatetodrop()
        }else if kConfirmationStatus == "ACCEPTED"{
            self.navigatetopickup()
        }
    }
    @IBAction func mGotosetting(_ sender: Any){
        self.redirectToLocationSettings()
        mlocationper.isHidden = true
    }
    
    
   
}




extension HomeViewController: RatingViewDelegate {
    func updateRatingFormatValue(_ value: Int) {
     //   print("Rating : = ", value)
        kRating = "\(value)"
    }
}
extension HomeViewController : TechnicalPopUPD{
    func technical() {
        self.updateStatus(updateStatus: "3")
        self.offline()
        getLastRideDataApi()
    }
}
extension HomeViewController : CancelRide{
    //MARK:- cancel ride
    func CancelRide() {
        self.confirmationView.isHidden = true
        DispatchQueue.main.async {
            print("FIRST")
            self.getProfileDataApi()
        }
        DispatchQueue.main.async {
            print("SECOND")
         self.getSelectServicesApi()
        }
        DispatchQueue.main.async {
            print("THIRD")
            self.pendingRequestApi()
        }
    }
}
//MARK:- User Defined Func
extension HomeViewController {
    //MARK:- add current location marker
//    func addCurrentLocationMarker() {
//        let puppyGif = UIImage(named: "car")
//        let imageView = UIImageView(image: puppyGif)
//        imageView.frame = CGRect(x: 0, y: 0, width: 45, height: 30)
//        if let location = locationManager.location {
//            marker = GMSMarker(position: location.coordinate)
//            marker.iconView = imageView
//            marker.map = mapView
//            marker.rotation = locationManager.location?.course ?? 0
//        }
//    }
    func setNavButton(){
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "green")
        if NSUSERDEFAULT.value(forKey: kUpdateDriveStatus) as? String  == "1"{
            my_switch.isOn = true
            my_switch.onTintColor = #colorLiteral(red: 0.2278893888, green: 0.6798063517, blue: 0.2944246531, alpha: 1)
            onOffValue = "Online"
        }
        else{
            my_switch.isOn = false
            my_switch.tintColor = UIColor.red
            onOffValue = "Offline"
        }
    }
    @IBAction func sideMenuButton(){
        let presentedVC = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController")
        let nvc = UINavigationController(rootViewController: presentedVC)
        present(nvc, animated: false, pushing: true, completion: nil)
    }
    func hasLocationPermission() -> Bool {
        var hasPermission = false
        let manager = CLLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            if #available(iOS 14.0, *) {
                switch manager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    hasPermission = false
                case .authorizedAlways, .authorizedWhenInUse:
                    hasPermission = true
                @unknown default:
                    break
                }
            } else {
            }
        } else {
            hasPermission = false
            let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        return hasPermission
    }
}
extension HomeViewController : gobackHome {
    func gobackHomeVC(flag: Bool) {
        if flag == true{
            self.pendingRequestApi()
        }
    }
}
extension UIProgressView {
    @available(iOS 10.0, *)
    func setAnimatedProgress(progress: Float = 1, duration: Float = 1, completion: (() -> ())? = nil) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            DispatchQueue.main.async {
                let current = self.progress
                self.setProgress(current+(1/duration), animated: true)
            }
            if self.progress >= progress {
                timer.invalidate()
                if completion != nil {
                    completion!()
                }
            }
        }
    }
}
