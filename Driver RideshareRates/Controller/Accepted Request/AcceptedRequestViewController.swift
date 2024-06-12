//
//  AcceptedRequestViewController.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit
import AVFoundation
import Alamofire

class AcceptedRequestViewController: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var acceptedReq_tableView: UITableView!
    
    //MARK:- Variables
    var conn = webservices()
    var acceptedReqData = [RidesData]()
    let BtnIndexPath: IndexPath =  IndexPath()
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var toggleState = 1
    var recordSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var settings = [String : Int]()
    var playBtnValue = ""
    var selectRideID = ""
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavButton()
        self.registerCell()
        self.acceptedReq_tableView.delegate = self
        self.acceptedReq_tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.acceptedRidesDetailsApi()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Accepted Requests"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
    }
    func setNavButton(){
        let logoBtn = UIButton(type: .custom)
        logoBtn.setImage(UIImage(named: "shape_28"), for: .normal)
        logoBtn.addTarget(self, action: #selector(tapNavButton), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: logoBtn)
        self.navigationItem.leftBarButtonItem = barButton
    }
    @objc func tapNavButton(){
        let presentedVC = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController")
        let nvc = UINavigationController(rootViewController: presentedVC)
        present(nvc, animated: false, pushing: true, completion: nil)
    }
    func registerCell(){
        let acceptNib = UINib(nibName: "AcceptedReqTableViewCell", bundle: nil)
        self.acceptedReq_tableView.register(acceptNib, forCellReuseIdentifier: "AcceptedReqTableViewCell")
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
//MARK:- Table View Datasource
extension AcceptedRequestViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.acceptedReqData.count ) == 0 {
            tableView.setEmptyMessage("No Data Found.")
        } else {
            tableView.removeErrorMessage()
        }
        return self.acceptedReqData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.acceptedReq_tableView.dequeueReusableCell(withIdentifier: "AcceptedReqTableViewCell") as! AcceptedReqTableViewCell
        if self.acceptedReqData[indexPath.row].status ?? "" == "START_RIDE"{
            cell.mainStackView.isHidden = true
            cell.CompleteRideView.isHidden = false
        }
        if self.acceptedReqData[indexPath.row].status ?? "" == "COMPLETED"{
            cell.mainStackView.isHidden = false
            cell.CompleteRideView.isHidden = true
        }
        cell.pickUpAddress_lbl.text = self.acceptedReqData[indexPath.row].pickupAdress ?? ""
        cell.dropAddress_lbl.text = self.acceptedReqData[indexPath.row].dropAddress ?? ""
        if self.acceptedReqData[indexPath.row].user_lastname == ""{
            cell.driverName_lbl.text = "Boss"

        }else{
            cell.driverName_lbl.text = self.acceptedReqData[indexPath.row].user_lastname ?? ""
        }
        //cell.amount_lbl.text = " $" + "\(self.acceptedReqData[indexPath.row].amount ?? "")"
      //  cell...text = self.getStringFormat(date: self.acceptedReqData[indexPath.row].time ?? "") + " ,"
        cell.time_lbl.text = self.acceptedReqData[indexPath.row].time ?? ""
        cell.trackBtn.tag = indexPath.row
        cell.trackBtn.addTarget(self, action: #selector(trackButtonAction), for: .touchUpInside)
        cell.callBtn.tag = indexPath.row
        cell.callBtn.addTarget(self, action: #selector(callButtonAction), for: .touchUpInside)
        cell.startRide.tag = indexPath.row
        cell.startRide.addTarget(self, action: #selector(startRideButtonAction), for: .touchUpInside)
     //   cell.startRecordingBtn.tag = indexPath.row
        cell.navigateBtn.tag = indexPath.row
        cell.completeRideBtn.tag = indexPath.row
        //cell.startRecordingBtn.addTarget(self, action: #selector(startRecordButtonAction), for: .touchUpInside)
        cell.navigateBtn.addTarget(self, action: #selector(navigateButtonAction), for: .touchUpInside)
        //    cell.completeRideBtn.addTarget(self, action: #selector(completeRideButtonAction), for: .touchUpInside)
        cell.configure(indexPath: indexPath)
        cell.callCheckBox = {index in
            print("Complete Ride Btn")
            let driverId = self.acceptedReqData[index.row].driverID ?? ""
            let riderId = self.acceptedReqData[index.row].rideID ?? ""
            self.selectRideID = riderId
            print(riderId)
            let param = ["driver_id": driverId , "ride_id" : riderId ,"status" : "COMPLETED"]
            self.conn.startConnectionWithPostType(getUrlString: "accept_ride", params: param,authRequired: true) { (value) in
                print(value)
                let msg = (value["message"] as? String ?? "")
                if ((value["status"] as? Int ?? 0) == 1){
                    // self.showToast(message: msg)
                    // self.acceptedRidesDetailsApi()
                    if kConfirmationStatus == "COMPLETED"{
                        self.showToast(message: "Ride Completed")
                    }
                    self.acceptedRidesDetailsApi()
                }else{
                    self.showAlert("Driver RideshareRates", message: msg)
                }
            }
        }
        return cell
    }
    @objc func trackButtonAction(sender : UIButton){
        print("track")
        let pickLat = self.acceptedReqData[sender.tag].pickupLat ?? ""
        let pickLong = self.acceptedReqData[sender.tag].pickupLong ?? ""
        let lat =  Double(pickLat)
        let long =  Double(pickLong)
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(pickLat),\(pickLong)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }}
        else {
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
    }
    @objc func callButtonAction(sender : UIButton){
        print("call")
        kCustomerMobile.makeCall(phoneNumber: self.acceptedReqData[sender.tag].userMobile ?? "")
    }
    @objc func startRideButtonAction(sender : UIButton){
        print("start")
        let modalRideId = self.acceptedReqData[sender.tag].rideID ?? ""
        let tag:NSInteger = sender.tag;
        let indexPath = NSIndexPath(row: tag, section: 0)
        if let cell = acceptedReq_tableView.cellForRow(at: indexPath as IndexPath ) as? AcceptedReqTableViewCell {
            cell.showStackView(show: true)
            kConfirmationStatus = "START_RIDE"
            acceptRejectStatus(confirmStatus: kConfirmationStatus, rideId: modalRideId, acceptRejectView: acceptReject.startRideStatus)
        }
        //  acceptRejectStatus(confirmStatus: kConfirmationStatus, acceptRejectView: acceptReject.acceptStatus)
    }
    
//    print("start")
//    
//    DispatchQueue.main.async {
//        let savedDictionary = UserDefaults.standard.object(forKey: "SavedCurrentLocation") as? [String: Any] ?? [String: Any]()
//        self.getDistanceAndDuration(from: savedDictionary["address2"] as? String  ?? "", to: (self.acceptedReqData[sender.tag].pickupAdress)!)
//       
//    }
//   
//}
//
//func getDistanceAndDuration(from: String, to: String){
//  
// //   let apiKey = "AIzaSyABQXS9DNSgpuGVZnC5bwfpj1mrl4dd4Z8"
//    let bundleID = "com.driverchime.app"
//    let baseURL = "https://maps.googleapis.com/maps/api/distancematrix/json"
//    let origin = DcurrentLocation.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//    let destination = to.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//    let urlString = "\(baseURL)?units=imperial&origins=\(origin)&destinations=\(destination)&key=AIzaSyABQXS9DNSgpuGVZnC5bwfpj1mrl4dd4Z8"
//    let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//    
//    let header: HTTPHeaders = [ "Accept": "application/json", "Content-Type": "application/json" ]
//    if let url = URL(string: urlString) {
//        var request = URLRequest(url: url)
//        
//        // Add a custom header with the bundle ID
//        request.addValue(bundleID, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
//        
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                return
//            }
//            guard let data = data else {
//                print("No data received")
//                return
//            }
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                // Process the JSON response here
//                print(json ?? "Invalid JSON")
//                if let jsonDict = json as? [String: Any],
//                   let rows = jsonDict["rows"] as? [[String: Any]],
//                   let firstRow = rows.first,
//                   let elements = firstRow["elements"] as? [[String: Any]],
//                   let firstElement = elements.first,
//                   let distance = firstElement["distance"] as? [String: Any],
//                   let duration = firstElement["duration"] as? [String: Any] {
//                    if let distanceText = distance["text"] as? String,
//                       let durationText = duration["text"] as? String {
//                        print("Duration: \(durationText)")
//                      //  self.timeD = durationText
//                        print("Distance: \(distanceText)")
//                        DispatchQueue.main.async {
//                            if distanceText.contains("mi"){
//                                let cleanedDistanceText = distanceText.replacingOccurrences(of: " mi", with: "")
//                                if Double(cleanedDistanceText)! <= 0.10{
////                                            self.mStartRideeBTN.isHidden = false
////                                            self.mGoBTN.isHidden = true
////                                            self.startBTNPulsing()
//                                    self.startride()
//                                }else{
//                                    self.showAlert("Driver RideshareRates", message: "You are not nearby pickup location yet")
//                                }
//                                }
//                            }
//                        
//                        DispatchQueue.main.async {
//                            if distanceText.contains("ft"){
//                               // let cleanedDistanceText = distanceText.replacingOccurrences(of: " ft", with: "")
////                                        self.mStartRideeBTN.isHidden = false
////                                        self.mGoBTN.isHidden = true
////                                        self.startBTNPulsing()
//                                self.startride()
//                                
//                                }else{
//                                    self.showAlert("Driver RideshareRates", message: "You are not nearby pickup location yet")
//                                }
//                                
//                            }
//                        }
//                    
//                }
//            } catch {
//                print("Error decoding JSON: \(error.localizedDescription)")
//            }
//        }
//        
//        task.resume()
//    }
//
//}
//func startride(){
//    let modalRideId = self.acceptedReqData[sender.tag].rideID ?? ""
//    let tag:NSInteger = sender.tag;
//    let indexPath = NSIndexPath(row: tag, section: 0)
//    if let cell = acceptedReq_tableView.cellForRow(at: indexPath as IndexPath ) as? AcceptedReqTableViewCell {
//        cell.showStackView(show: true)
//        kConfirmationStatus = "START_RIDE"
//        acceptRejectStatus(confirmStatus: kConfirmationStatus, rideId: modalRideId, acceptRejectView: acceptReject.startRideStatus)
//    }
//   
//}
    
    
    
    
    
    
    @objc func startRecordButtonAction(sender : UIButton){
        print("record btn")
        let modalRideId = self.acceptedReqData[sender.tag].rideID ?? ""
        selectRideID = modalRideId
        let tag:NSInteger = sender.tag;
        let indexPath = NSIndexPath(row: tag, section: 0)
        if let cell = acceptedReq_tableView.cellForRow(at: indexPath as IndexPath ) as? AcceptedReqTableViewCell {
         //   cell.startRecordingBtn.setTitle("Play Recoring", for: .normal)
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
    }
    @objc func navigateButtonAction(sender : UIButton){
        print("navigate Btn")
        let pickLat = self.acceptedReqData[sender.tag].dropLat ?? ""
        let pickLong = self.acceptedReqData[sender.tag].dropLong ?? ""
        let lat =  Double(pickLat)
        let long =  Double(pickLong)
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(pickLat),\(pickLong)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }}
        else {
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
    }
    @objc func completeRideButtonAction(sender : UIButton){
        let modalRideId = self.acceptedReqData[sender.tag].rideID ?? ""
        let tag:NSInteger = sender.tag;
        let indexPath = NSIndexPath(row: tag, section: 0)
        if let cell = acceptedReq_tableView.cellForRow(at: indexPath as IndexPath ) as? AcceptedReqTableViewCell {
            cell.showStackView(show: true)
            kConfirmationStatus = "COMPLETED"
            acceptRejectStatus(confirmStatus: kConfirmationStatus, rideId: modalRideId, acceptRejectView: acceptReject.completedStatus)
        }
    }
   
}

//MARK:- Table View Delegate
extension AcceptedRequestViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "RideDetailsViewController") as! RideDetailsViewController
        vc.screen = "accept"
        vc.ridedetail = self.acceptedReqData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK:- Web Api
extension AcceptedRequestViewController{
    
    //MARK:- accept ride api 
    func acceptedRidesDetailsApi(){
        let url = "api/user/rides?status=ACCEPTED"
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: url,authRequired: true) { (value) in
            print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                if (value["status"] as? Int ?? 0) == 1{
                    let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        self.acceptedReqData = try newJSONDecoder().decode(rides.self, from: jsonData)
                        self.acceptedReq_tableView.reloadData()
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    func acceptRejectStatus(confirmStatus : String ,rideId: String , acceptRejectView : acceptReject){
        let param = [ "ride_id" : rideId ,"status" : kConfirmationStatus]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "accept_ride", params: param,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            print(value)
            let msg = (value["message"] as? String ?? "")
            if ((value["status"] as? Int ?? 0) == 1){
                if kConfirmationStatus == "COMPLETED"{
                    self.acceptedRidesDetailsApi()
                }
                if kConfirmationStatus == "START_RIDE"{
                    self.showToast(message: "Ride Started")
                }
            }else{
                self.showAlert("Driver RideshareRates", message: msg)
            }
        }
    }
}

extension AcceptedRequestViewController : AVAudioRecorderDelegate, AVAudioPlayerDelegate {
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
        let url = URL(string: "\(baseurl)audio_capture")!
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
}
