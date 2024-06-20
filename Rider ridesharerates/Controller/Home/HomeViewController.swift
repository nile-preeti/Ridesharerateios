//
//  HomeViewController.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import AVFoundation
import Firebase
import FirebaseDatabase
import MapKit
import Alamofire

protocol payRideProtocol {
    func payRide(rideID: String ,amount:String,status:Bool)
}
class HomeViewController: UIViewController {
    //MARK:- OUTLETS
    // @IBOutlet var mainView: UIView!
    //    @IBOutlet var mNewRidesView: UIView!
    //    @IBOutlet var mSecTableV: UITableView!
//    @IBOutlet var mHomeView: UIView!
//    @IBOutlet var mHomeMApV: GMSMapView!
//    @IBOutlet var mDropTF: UITextField!
//    @IBOutlet var mPickupTV: UITextField!
    @IBOutlet weak var emergncyBTN: UIButton!
    
    @IBOutlet var timerTitle : UILabel!
    @IBOutlet var mTimerView: UIView!
    @IBOutlet var mTimerLBL: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var pickUpAddress_lbl: UILabel!
    @IBOutlet weak var dropAddress_lbl: UILabel!
    @IBOutlet weak var ride_tableView: UITableView!
    @IBOutlet weak var chooseRide_view: SetView!
    @IBOutlet weak var rideNow_btn: SetButton!
    @IBOutlet weak var chooseRideViewHeight_const: NSLayoutConstraint!
    @IBOutlet weak var chooseLbl: UILabel!
    @IBOutlet weak var pickupBtn: UIButton!
    @IBOutlet weak var dropBtn: UIButton!
    @IBOutlet weak var pickupBtnCancel: UIButton!
    @IBOutlet weak var dropBtnCancel: UIButton!
    //MARK:- Variables
    var payRideDelegate: payRideProtocol?
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var toggleState = 1
    var recordSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    //    var player: AVAudioPlayer!
    //     var Vplayer: AVPlayer?
    var audioPlayer: AVAudioPlayer?
    var settings = [String : Int]()
    var playBtnValue = ""
    var selectRideID = ""
    var tap = 0
    var tapOneStatus = false
    var tapTwoStatus = false
    let conn = webservices()
    var getAllVechileData = [VechileData]()
    var rideDistance = ""
    var picktodropDistance = 0
    var picktodropDuration = 0
    var pickUpLat = ""
    var pickUpLong = ""
    var dropLat = ""
    var pickvalue = ""
    var dropLong = ""
    var pickUpAddress = ""
    var dropAddress = ""
    //  var rideAmount = ""
    var currentMarker: GMSMarker?
    var locationManager: CLLocationManager!
    var marker = GMSMarker()
    var polyLine = GMSPolyline()
    var update = true
    var profileDetails : ProfileData?
    var locations = [CLLocation]()
    var holdalert = UIAlertController()
    var pathdrawtimer = ""
    var driverConfirmation = driverConfirmStatus.notConfirmed
    var action  =  ""
    var notificationRideId  =  ""
    var driverDistance = ""
    var callDriverStatus = false
    var driverNumber = ""
    var senderDisplayName = ""
    var driverData : userCustomerModal?
    var Dmiles = "0"
    var feedBackStatus = false
    var locationManagerUpdate:Bool = false //Global
    var timer: Timer?
    var newPath = GMSPath()
    private var observer: NSObjectProtocol?
    weak var timerr: Timer?
    var nearByPlacesArray = [[String : Any]]()
    var lastRideData : LastRideModal?
    var lastRideAmount = ""
    var chooseVehicleList = chooseRideList.hide
    var locationPickUpEditStatus =  false
    var locationDropUpEditStatus =  false
    
    var cardData = [cardDataModal]()
    var ref: DatabaseReference?
    var driverLatLNG : String?
    
    var cancellation_charge = String()
    var totalamount = String()
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var popupheight = "full"
    var once = ""
    
    var EndVid = ""
    var pathD = ""
    var speed = Double()
    var timeD = "0"
    var polyline: GMSPolyline?
    var dMarker = GMSMarker()
    var Dtime = 0.0
    //map
    var pendingRidetimeout = ""
    var initialCameraPosition: GMSCameraPosition?
    
    private var driverAnnotation : MKPointAnnotation?
    
    var observationHandle : DatabaseHandle?
    var seconds = 0
    
    var secs = 0
    var timerS : Timer?
    var count = 0
    var count2 = 1
    var stoptimer = ""
    var sectionData = [
        ["Sedan", "SUV"],
        ["Coupe", "Sedan", "SUV"],
        ["Sedan 2022-2024", "Sedan 2010-2021", "Coupe","SUV"],
        ["Coupe", "Sedan", "SUV"],
        // Add more sections and rows as needed
    ]
    // Define an array to hold section titles
    var sectionTitles = ["LUXURY", "ELECTRIC","EXOTIC","RARE"]
    
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
       // updateAppVersionPopup()
        self.mTimerView.isHidden = true
      //  appUpdateAvailable()
        //        mNewRidesView.isHidden = true
        //        mSecTableV.isHidden = true
        //  updateAppVersionPopup()
//        mPickupTV.delegate = self
//        mDropTF.delegate = self
//        mDropTF.layer.borderWidth = 1
//        mDropTF.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.631372549, blue: 0.262745098, alpha: 1)
        pickupBtnCancel.setImage(UIImage(named: "cancel"), for: .normal)
        if Reachability.isConnectedToNetwork(){
            
        }else{
            //  print("Internet Connection not Available!")
            self.showAlert("Rider RideshareRates", message: "Internet connection appears to be offline")
        }
        
        setUpMainFunctions()
        self.registerCell()
        self.setNavButton()
        self.getLocation()
        self.getLastRideDataApi()
        NotificationCenter.default.addObserver(self, selector: #selector(loadBackgroundList), name: NSNotification.Name(rawValue: "ReceiveDataBackground1"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadForegroundList), name: NSNotification.Name(rawValue: "ReceiveDataForeground1"), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        applyMapStyle()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //    override var preferredStatusBarStyle: UIStatusBarStyle {
    //        return .lightContent
    //    }
    //    override var preferredStatusBarStyle: UIStatusBarStyle {
    //        if #available(iOS 13.0, *) {
    //            return .lightContent
    //        } else {
    //            return .default
    //        }
    //
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
          //  self.mHomeMApV.mapStyle = mapStyle
        } catch {
            print("Error loading map style: \(error)")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        //updateAppVersionPopup()
        self.title = "Book a Ride"
        self.stoptimer = ""
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "green")
        self.navigationController?.navigationBar.backgroundColor = .black
        self.navigationController?.navigationBar.barStyle = .black
        setNeedsStatusBarAppearanceUpdate()
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        DispatchQueue.main.async {
            self.getProfileDataApi()
        }
        //        DispatchQueue.main.async {
        //            self.getNearbyDrivers()
        //        }
        DispatchQueue.main.async {
            self.getLastRideDataApi()
        }
        self.savedCardApi()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stoptimer = "stop"
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ReceiveDataBackground1"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ReceiveDataForeground1"), object: nil)
       
    }
    
    
    // MARK: Check AppVersion
      func updateAppVersionPopup() {
        guard let appStoreURL = URL(string: "http://itunes.apple.com/lookup?bundleId=com.riderRideshare.app") else {
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
            guard let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/rider-ridesharerates/id6476266125") else {
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
    
    
    //MARK:- Get LAt long
    func getDriverLatLong(driverName:String, RideID :String){
        self.ref = Database.database().reference()
        if driverName != "" && RideID != "" {
            //   Timer.scheduledTimer(withTimeInterval: self.Dtime, repeats: false) { timer in
            let trimmedString = driverName.trimmingCharacters(in: .whitespaces) + RideID
            self.observationHandle = ref!.child("driver").child(RideID).observe(.value, with: { snapshot in
                self.ref!.child("driver").child(RideID).removeAllObservers()
                print(self.ref)
                
                guard let dict = snapshot.value as? [String:Any] else {
                    print("Error")
                    return
                }
                
                // self.stopObservingFirebase()
                let latitude1 = dict["latitude"] as? String
                let longitude1 = dict["longitude"] as? String
                let bearing1 = dict["bearing"] as? String
                
                let latitude = Double(latitude1!)
                let longitude =  Double(longitude1!)
                let bearing =  Double(bearing1!)
                
               // self.speed = (dict["speedAccuracyMetersPerSecond"] as? Double)!
                self.driverLatLNG =   "\(latitude ?? 0.0)" + "," + "\(longitude ?? 0.0)"
                //  Timer.scheduledTimer(withTimeInterval: self.Dtime, repeats: false) { timer in
                //  let delayInSeconds: Double = 300.0 // Specify the delay time in seconds
                //   self.Dtime = 10
                DispatchQueue.main.asyncAfter(deadline: .now() + 00.0) {
                    if  self.driverLatLNG != nil{
                        if kNotificationAction == "ACCEPTED" || kConfirmationAction == "ACCEPTED" || kNotificationAction == "START_RIDE" || kConfirmationAction == "START_RIDE"{
                            // self.Dtime = 10.0
                            print("inf")
                            if kNotificationAction == "START_RIDE" || kConfirmationAction == "START_RIDE"{
                                if self.lastRideData?.on_location != "AT_DESTINATION"{
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 00.0) {
                                        print("startride")
                                        
                                           self.routingLines(origin: self.driverLatLNG! ,destination: kDestinationLatLongTap)
                                    }
                                    
                                }else{
                                    print("AT_DESTINATION")
                                }
                            }else if kNotificationAction == "ACCEPTED" || kConfirmationAction == "ACCEPTED"{
                                if self.lastRideData?.on_location != "YES"{
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                                        print("accepted")
                                           self.routingLines(origin: self.driverLatLNG! ,destination: kCurrentLocaLatLongTap)
                                    }
                                }
                                //                                    DispatchQueue.main.async {
                                ////                                        let delayInSeconds: Double = 120.0 // Specify the delay time in seconds
                                ////
                                ////                                           DispatchQueue.main.asyncAfter(deadline: .now() + self.Dtime) {
                                //                                           //   self.getRideStatus(ride_id: kRideId)
                                //
                                //                                     //      }
                                //
                                //                                     //   self.CheckDistance(lat: latitude!, lng: longitude!)
                                //                                    }
                                
                            }
                            CATransaction.begin()
                            CATransaction.setValue(2.0, forKey: kCATransactionAnimationDuration)
                            self.marker.map = nil
                            CATransaction.setCompletionBlock {
                                self.marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                            }
                            let puppyGif = UIImage(named: "car")
                            let imageView = UIImageView(image: puppyGif)
                            
                            imageView.frame = CGRect(x: 0, y: 0, width: 85, height: 60)
                            // self.marker.position = CLLocationCoordinate2D(latitude: latLng.latitude, longitude: latLng.longitude)
                            self.marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                            if bearing != nil{
                                self.marker.rotation = CLLocationDegrees(bearing! + 98 + 180)
                            }
                         //   self.marker.rotation = CLLocationDegrees(bearing! + 98 + 180) // bearing used for car rotation
                            self.marker.isFlat = true
                            self.marker.iconView = imageView
                            self.marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                            CATransaction.commit()
                            self.marker.map = self.mapView
                            // Add a car image marker at the starting point
                            let startingLocation = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                            
                        }
                    }
                    
                }
            })
            //  }
        }
        if pathdrawtimer == ""{
            pathdrawtimer = "hit"
            DispatchQueue.main.asyncAfter(deadline: .now() + 120.0) {
                if kNotificationAction == "ACCEPTED" || kConfirmationAction == "ACCEPTED" || kNotificationAction == "START_RIDE" || kConfirmationAction == "START_RIDE"{
                    self.pathdrawtimer = ""
                        self.getDriverLatLong(driverName: driverName,RideID: RideID)
                   
                    }
                }
               
            }
        
        
    }
//    func stopObservingFirebase() {
//        if let observationHandle = self.observationHandle {
//                self.ref?.removeObserver(withHandle: observationHandle)
//                self.observationHandle = nil
//            }
//        }
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
//                    let apiKey = "AIzaSyABQXS9DNSgpuGVZnC5bwfpj1mrl4dd4Z8"
//                    DispatchQueue.main.async {
//                        self.getDistanceAndDuration(from: from, to: (self.lastRideData?.pickup_adress)!, apiKey: apiKey)
//                    }
//                } else {
//                    print("Unable to determine location name")
//                }
//            }
//        }
//    }
//    func getDistanceAndDuration(from: String, to: String, apiKey: String) {
//        let bundleID = "com.riderRideshare.app"
//        let baseURL = "https://maps.googleapis.com/maps/api/distancematrix/json"
//        let origin = from.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let destination = to.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let urlString = "\(baseURL)?units=imperial&origins=\(origin)&destinations=\(destination)&key=\(apiKey)"
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
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
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
//                            self.timeD = durationText
    
//                            print("Distance: \(distanceText)")
//                            DispatchQueue.main.async {
//                                if distanceText.contains("mi"){
//                                    let cleanedDistanceText = distanceText.replacingOccurrences(of: " mi", with: "")
//                                    self.Dmiles = cleanedDistanceText
//                                    self.popup()
//                                }else{
//                                    let cleanedDistanceText = distanceText.replacingOccurrences(of: " ft", with: "")
//                                    self.Dmiles = cleanedDistanceText
//                                    self.popupF()
//                                }
//                            }
//                            DispatchQueue.main.async {
//                                self.ride_tableView.reloadData()
//                            }
//                            //   self.Dmiles = cleanedDistanceText
//                        }
//                    }
//                } catch {
//                    print("Error parsing JSON: \(error)")
//                }
//                
//            }.resume()
//        }
//    }
//    func popup(){
//        if Double(self.Dmiles)! <= 0.12{
//          //  self.timeD = "1 min"
////                if Dmiles <= 0.1{
////                    self.timeD = "0"
////                }
//            if kNotificationAction == "ACCEPTED" || kConfirmationAction == "ACCEPTED" && kRideId != "" {
//                if self.once != "done"{
//                    self.once = "done"
//                    if let audioPath = Bundle.main.path(forResource: "example", ofType: "caf") {
//                               let audioUrl = URL(fileURLWithPath: audioPath)
//                               do {
//                                   audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
//                                   audioPlayer?.prepareToPlay()
//                               } catch {
//                                   print("Error loading audio file: \(error.localizedDescription)")
//                               }
//                           }
//                    self.audioPlayer?.play()
//                    let alert = UIAlertController(title: "Rider RideshareRates", message: "Driver has arrived at your location. Please meet with your driver.", preferredStyle: UIAlertController.Style.alert)
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
//                    let attributedTitle = NSAttributedString(string: "Rider RideshareRates", attributes: titleAttributes)
//                    let attributedMessage = NSAttributedString(string: "Driver has arrived at your location. Please meet with your driver.", attributes: messageAttributes)
//
//                    // Set the attributed title and message
//                    alert.setValue(attributedTitle, forKey: "attributedTitle")
//                    alert.setValue(attributedMessage, forKey: "attributedMessage")
//                    alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.96)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
//                        self.once = "done"
//                        self.audioPlayer?.stop()
//                        self.audioPlayer?.currentTime = 0
//                    }))
//                    self.present(alert, animated: true, completion: nil)
//                }
//            }
//        }else{
//            DispatchQueue.main.async {
//                self.ride_tableView.reloadData()
//            }
//        }
//    }
   
//    func popupF(){
//        if Double(self.Dmiles)! <= 633.6{
//          //  self.timeD = "1 min"
////                if Dmiles <= 0.1{
////                    self.timeD = "0"
////                }
//            if kNotificationAction == "ACCEPTED" || kConfirmationAction == "ACCEPTED" && kRideId != "" {
//                if self.once != "done"{
//                    self.once = "done"
////                    DispatchQueue.main.async {
////                        self.ride_tableView.reloadData()
////                    }
//                    if let audioPath = Bundle.main.path(forResource: "example", ofType: "caf") {
//                               let audioUrl = URL(fileURLWithPath: audioPath)
//                               do {
//                                   audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
//                                   audioPlayer?.prepareToPlay()
//                               } catch {
//                                   print("Error loading audio file: \(error.localizedDescription)")
//                               }
//                           }
//                    self.audioPlayer?.play()
//                    let alert = UIAlertController(title: "Rider RideshareRates", message: "Driver has arrived at your location. Please meet with your driver.", preferredStyle: UIAlertController.Style.alert)
//                   
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
//                    let attributedTitle = NSAttributedString(string: "Rider RideshareRates", attributes: titleAttributes)
//                    let attributedMessage = NSAttributedString(string: "Driver has arrived at your location. Please meet with your driver.", attributes: messageAttributes)
//
//                    // Set the attributed title and message
//                    alert.setValue(attributedTitle, forKey: "attributedTitle")
//                    alert.setValue(attributedMessage, forKey: "attributedMessage")
//                    alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.96)
//                    
//                    
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
//                        self.once = "done"
//                        self.audioPlayer?.stop()
//                        self.audioPlayer?.currentTime = 0
//                    }))
//                    DispatchQueue.main.async {
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                }
//            }
//        }else{
//            DispatchQueue.main.async {
//                self.ride_tableView.reloadData()
//            }
//        }
//    }
    func reverseGeocodeLocation(lat: Double, lng: Double, completionHandler: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: lat, longitude: lng)
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                completionHandler(nil)
                return
            }
            if let placemark = placemarks?.first {
                if let name = placemark.name,
                   let locality = placemark.locality {
                    let locationName = "\(name), \(locality)"
                    completionHandler(locationName)
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    func geocodeAddress(address: String, completion: @escaping (Result<(latitude: Double, longitude: Double), Error>) -> Void) {
        let apiKey = "AIzaSyABQXS9DNSgpuGVZnC5bwfpj1mrl4dd4Z8" // Replace with your own Google Maps API key
        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "https://maps.googleapis.com/maps/api/geocode/json?address=\(encodedAddress)&key=\(apiKey)"
        let url = URL(string: urlString)!

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let results = json?["results"] as? [[String: Any]],
                   let location = results.first?["geometry"] as? [String: Any],
                   let latitude = location["lat"] as? Double,
                   let longitude = location["lng"] as? Double {
                    completion(.success((latitude: latitude, longitude: longitude)))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    func calculateEstimatedDrivingTime(fromAddress: String, toAddress: String) {
        geocodeAddress(address: fromAddress) { result in
            switch result {
            case .success(let fromLocation):
                self.geocodeAddress(address: toAddress) { result in
                    switch result {
                    case .success(let toLocation):
                        let sourcePlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: fromLocation.latitude, longitude: fromLocation.longitude))
                        let destinationPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: toLocation.latitude, longitude: toLocation.longitude))
                        
                        let request = MKDirections.Request()
                        request.transportType = .automobile
                        request.source = MKMapItem(placemark: sourcePlacemark)
                        request.destination = MKMapItem(placemark: destinationPlacemark)
                        
                        let directions = MKDirections(request: request)
                        directions.calculate { (response, error) in
                            guard let response = response else {
                                if let error = error {
                                    print("Error calculating directions: \(error.localizedDescription)")
                                }
                                return
                            }
                            
                            if let route = response.routes.first {
                                let estimatedTimeInSeconds = route.expectedTravelTime
                                let estimatedTimeInMinutes = estimatedTimeInSeconds / 60
                                print("Estimated driving time: \(estimatedTimeInMinutes) minutes")
                            }
                        }
                    case .failure(let error):
                        print("Error geocoding to address: \(error)")
                    }
                }
            case .failure(let error):
                print("Error geocoding from address: \(error)")
            }
        }
    }
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
                self.getLastRideDataApi()
                pendingRidetimeout = "true"
                self.cancelRideStatus(rideId: kRideId)
            }
        }
    }
    
    @IBAction func mHelpBTN(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "helpVCID") as! helpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func emergncy(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "emergency911POPUPID") as! emergency911POPUP
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
extension HomeViewController: UITextFieldDelegate{
    
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == mPickupTV{
//            self.tap = 0
//            autocompleteClicked()
//        }else if textField == mDropTF{
//            self.tap = 0
//            autocompleteClicked()
//        }
//    }
}
extension HomeViewController {
    //MARK:- User Defined Func
    func getLocation() {
      //  self.mapView.isMyLocationEnabled = true
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.startUpdatingLocation()
        }
    }
    func registerCell(){
        let sideMenuNib = UINib(nibName: "SideMenuTableViewCell", bundle: nil)
        self.ride_tableView.register(sideMenuNib, forCellReuseIdentifier: "SideMenuTableViewCell")
        
        let confirmationNib = UINib(nibName: "DriverConfirmationCell", bundle: nil)
        self.ride_tableView.register(confirmationNib, forCellReuseIdentifier: "DriverConfirmationCell")
        
        let callDriverNib = UINib(nibName: "CallDriverCell", bundle: nil)
        self.ride_tableView.register(callDriverNib, forCellReuseIdentifier: "CallDriverCell")
        
        let rideOnWaydNib = UINib(nibName: "RideOnWayCell", bundle: nil)
        self.ride_tableView.register(rideOnWaydNib, forCellReuseIdentifier: "RideOnWayCell")
        
        let rideCompletedNib = UINib(nibName: "RideCompletedCell", bundle: nil)
        self.ride_tableView.register(rideCompletedNib, forCellReuseIdentifier: "RideCompletedCell")
        
        let paymentNib = UINib(nibName: "PaymentPopUpVCCell", bundle: nil)
        self.ride_tableView.register(paymentNib, forCellReuseIdentifier: "PaymentPopUpVCCell")
        
        self.ride_tableView.dataSource = self
        self.ride_tableView.delegate = self

    }

    func scheduledTimerWithTimeInterval(){
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.updateLocationManager), userInfo: nil, repeats: true)
    }
    @objc func updateLocationManager() {
        if locationManagerUpdate == false {
            locationManager.delegate = self
            locationManagerUpdate = true
        }
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
                // Fallback on earlier versions
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
    //MARK:- set up userid and fcm token
    func setUpMainFunctions(){
        if let savedPeople = UserDefaults.standard.object(forKey: "loginInfo") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [String: Any] {
           //     print(decodedPeople)
                if let user_id = decodedPeople["user_id"] as? String {
                    NSUSERDEFAULT.set(user_id, forKey: kUserID)
                    kDriverId = kUserID
                }
//                if let fcm = decodedPeople["gcm_token"] as? String {
//                    NSUSERDEFAULT.set(fcm, forKey: kFcmToken)
//                    print("GCM TOKEN IS HERE \(NSUSERDEFAULT.value(forKey: kFcmToken) ?? "")")
//                }
//                if let email = decodedPeople["email"] as? String {
//                    NSUSERDEFAULT.set(email, forKey: kEmail)
//                    print("EMAIL IS HERE \(NSUSERDEFAULT.value(forKey: kEmail) ?? "")")
//
//                }
//                if let name = decodedPeople["name"] as? String {
//                    NSUSERDEFAULT.set(name, forKey: kName)
//                    print("NAME IS HERE \(NSUSERDEFAULT.value(forKey: kName) ?? "")")
//                }
            }
        }
        print("ACCESS TOKEN IS HERE \(NSUSERDEFAULT.value(forKey: accessToken) ?? "")")
        print("FCM TOKEN IS HERE \(NSUSERDEFAULT.value(forKey: kFcmToken) ?? "")")
        print(action)
        print(kRideId)
        print(senderDisplayName)
    }
    // Present the Autocomplete view controller when the button is pressed.
    func autocompleteClicked(){
        marker.map = nil
        polyLine.map = nil
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.primaryTextColor = UIColor.lightGray
        autocompleteController.primaryTextHighlightColor = UIColor.white
        autocompleteController.secondaryTextColor = UIColor.white
        autocompleteController.tableCellSeparatorColor = UIColor.lightGray
        autocompleteController.tableCellBackgroundColor = UIColor.lightBlackThemeColor()
        
        let searchBarTextAttributes: [NSAttributedString.Key : AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white, NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont.systemFont(ofSize: UIFont.systemFontSize)]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
       // autocompleteController.searchbartextatt
        
        present(autocompleteController, animated: true, completion: nil)
       
    }
}
