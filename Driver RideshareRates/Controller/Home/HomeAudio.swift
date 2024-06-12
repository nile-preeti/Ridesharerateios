//
//  HomeAudio.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//
//
import UIKit
import AVFoundation
import Alamofire

extension HomeViewController {
    //MARK:- set up audio recording
    func setUpAudioRecording(){
        recordSession = AVAudioSession.sharedInstance()
        if(recordSession.responds(to:#selector(AVAudioSession.requestRecordPermission(_:)))){
            // configure audio settings
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool) -> Void in
                if granted{
                    print("Recording granted!")
                    do{
                        try self.recordSession.setCategory(.playAndRecord,mode: .default, options: [])
                        try self.recordSession.setActive(true)
                    }catch{
                        print("Audio session could not be set!")
                    }
                }else{
                    print("Recording not granted!")
                }
            })
        }
        settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 12000,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    }
    //MARK:- get document
    func getDocumentsDirectory()-> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    //MARK:- get audio
    func getAudioURL() -> URL {
        let filename = NSUUID().uuidString+".m4a"
        return getDocumentsDirectory().appendingPathComponent(filename)
    }
    //MARK:- start recording
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
    //MARK:- finish recording
    func finishRecording(success: Bool){
        audioRecorder.stop()
        if success{
            print("Recorded successfully!")
        }else{
            audioRecorder = nil
            print("Recording failed!")
        }
    }
    //MARK:- audio recording finish fun 
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag{
            finishRecording(success:false)
            print("What is this url \(recorder.url)")
        }
        let refreshAlert = UIAlertController(title: Singleton.shared!.title , message: "Are you sure you want to save recording?", preferredStyle: UIAlertController.Style.alert)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]
        let messageAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.white,
        ]

//        let attributedTitle = NSAttributedString(string: "Are you sure you want to delete account?", attributes: titleAttributes)
//        let attributedMessage = NSAttributedString(string: "Are you sure you want to save recording?", attributes: messageAttributes)
//
//        // Set the attributed title and message
//        alert.setValue(attributedTitle, forKey: "attributedTitle")
//        alert.setValue(attributedMessage, forKey: "attributedMessage")
//        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.96)
//        refreshAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action: UIAlertAction!) in
//            self.audioRecorder = nil
//           // self.startRecording()
//            let params = ["ride_id" : kRideId ]
//            self.requestForUpload(audioFilePath: recorder.url, parameters: params)
//        }))
//        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//        }))
//        present(refreshAlert, animated: true, completion: nil)
    }
}

extension HomeViewController : AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playBtn.setTitle("Play Recoring", for: .normal)
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
          //  print("URL AND HEADERS==========\(headers)")
            Indicator.shared.hideProgressView()
            switch (response.result) {
            case .success(let JSON):
                print("JSON: \(JSON)")
                let responseString = JSON as! NSDictionary
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
