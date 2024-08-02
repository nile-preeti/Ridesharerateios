//
//  CompletedDetailVC.swift
//  Rider ridesharerates
//
//  Created by malika on 24/11/23.
//

import UIKit

class CompletedDetailVC: UIViewController {
    @IBOutlet var mTotalAmountLBL: UILabel!
    @IBOutlet var mDriverNAme: UILabel!
    @IBOutlet var mDateLBL: UILabel!
    @IBOutlet var mRiderNAME: UILabel!
    @IBOutlet var mTotalLBL: UILabel!
    @IBOutlet var mTripFare: UILabel!
    @IBOutlet var mSubtotal: UILabel!
    @IBOutlet var mCancelfees: UILabel!
    @IBOutlet var mTax: UILabel!
    @IBOutlet var mBookingFees: UILabel!
    @IBOutlet var waitingtime : UILabel!
    @IBOutlet var waitingfees : UILabel!
    
    var ridesStatusData : RidesData?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "Ride Details"
        // Do any additional setup after loading the view.
    }
    func setdata(){
        mTotalAmountLBL.text = "Total $\(ridesStatusData?.amount ?? "")"
        mTotalLBL.text = "$\(ridesStatusData?.amount ?? "")"
        mDateLBL.text = "\(ridesStatusData?.time ?? "")"
        mTripFare.text = "$\(ridesStatusData?.trip_fare ?? "")"
        mSubtotal.text = "$\(ridesStatusData?.subtotal ?? "")"
        mBookingFees.text = "$\(ridesStatusData?.booking_fee ?? "")"
        mTax.text = "$\(ridesStatusData?.tax_charge ?? "")"
        waitingfees.text = "$\(ridesStatusData?.total_waiting_charge ?? "")"
        waitingtime.text = "\(ridesStatusData?.total_waiting_time ?? "") hrs"
        if self.ridesStatusData?.driver_lastname == "" {
            mDriverNAme.text = "For Category: \(ridesStatusData?.category_name ?? ""), \n Vehicle: \(ridesStatusData?.vehicle_name ?? ""). Driven by Boss."
        }else{
            mDriverNAme.text = "For Category: \(ridesStatusData?.category_name ?? ""), \n Vehicle: \(ridesStatusData?.vehicle_name ?? ""). Driven by \(ridesStatusData?.driver_lastname ?? "Boss")."
            }
        
      //  mRiderNAME.text = "Thanks for ride, \(ridesStatusData?.userName ?? "")."
        mCancelfees.text = "$\(ridesStatusData?.cancellation_charge ?? "")"
        var str = ridesStatusData?.userName ?? ""
        if let dotRange = str.range(of: " ") {
          str.removeSubrange(dotRange.lowerBound..<str.endIndex)
        }
        mRiderNAME.text = "Thanks for ride, \(str)."
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.setNavButton()
        self.navigationController?.isNavigationBarHidden = false
        self.setdata()
    }
    func setNavButton(){
        let logoBtn = UIButton(type: .custom)
        logoBtn.setImage(UIImage(named: "leftArrowWhite"), for: .normal)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.backgroundColor = .black
        logoBtn.addTarget(self, action: #selector(tapNavButton), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: logoBtn)
        self.navigationItem.leftBarButtonItem = barButton
    }
    @objc func tapNavButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mWebpageBTN(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "BookingFeeVC") as! BookingFeeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
