//
//  TechnicalViewControllerPopUP.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit
protocol TechnicalPopUPD : AnyObject {
    func technical()
}
class TechnicalViewControllerPopUP: UIViewController {

    @IBOutlet var crossBTN: UIButton!
    @IBOutlet weak var mCallBTN: UIButton!
    @IBOutlet weak var mNoBTN: UIButton!
    @IBOutlet weak var mYesBTN: UIButton!
    @IBOutlet weak var mTitleLBL: UILabel!
    var delegate: TechnicalPopUPD?
    let conn = webservices()
    override func viewDidLoad() {
        super.viewDidLoad()
        mYesBTN.isHidden = false
        mNoBTN.isHidden = false
        mCallBTN.isHidden = true
        crossBTN.isHidden = true
        mTitleLBL.text = "Are you facing any technical issue?"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func mCrossBTN(_ sender: Any) {
        self.dismiss(animated: true,completion: {
            self.delegate?.technical()
        })
    }
    func acceptRejectStatus(confirmStatus : String){
        print("ACCEPT REJECT API")
        let param = [ "ride_id" : kRideId ,"status" : "COMPLETED", "is_technical_issue" : confirmStatus]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "accept_ride", params: param,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            print(value)
            let msg = (value["message"] as? String ?? "")
            if ((value["status"] as? Int ?? 0) == 1){
                
               
            }else{
                self.showAlert("Driver RideshareRates", message: msg)
            }
        }
    }
    @IBAction func mYESBTN(_ sender: Any) {
        if mTitleLBL.text == "Are you facing any technical issue?"{
            acceptRejectStatus(confirmStatus: "Yes")
            mYesBTN.isHidden = true
            mNoBTN.isHidden = true
            mCallBTN.isHidden = false
            crossBTN.isHidden = false
           // mTitleLBL.text = "Are you facing any technical issue?"
        }
        if mTitleLBL.text == "Do you want complete this ride before reaching destination?"{
            self.dismiss(animated: true)
              acceptRejectStatus(confirmStatus: "No")
        }
    }
    
    @IBAction func mNoBTN(_ sender: Any) {
        if mTitleLBL.text == "Do you want complete this ride before reaching destination?"{
            self.dismiss(animated: true)
            //  acceptRejectStatus(confirmStatus: "No")
        }
        if mTitleLBL.text == "Are you facing any technical issue?"{
            mTitleLBL.text = "Do you want complete this ride before reaching destination?"
            return
        }
    }
    @IBAction func mCAllBTN(_ sender: Any) {
        let url: NSURL = URL(string: "TEL://4042075620")! as NSURL
           UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
      //  if confirmStatus == "Yes"{
            self.dismiss(animated: true,completion: {
                self.delegate?.technical()
            })
      //  }
   //     dialNumber(number: "+1 802-375-5793")
        
    }
    
    //MARK:- dial number 
    func dialNumber(number : String) {

     if let url = URL(string: "tel://\(number)"),
       UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
           } else {
               UIApplication.shared.openURL(url)
           }
       } else {
                // add error message here
       }
    }
}
