//
//  PendingRequestViewController.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit
import CoreLocation

class PendingRequestViewController: UIViewController {
    //MARK:- OUTLETS
    @IBOutlet weak var pendingList: UITableView!
    let conn = webservices()
    var pendingReqData = [RidesData]()
    //MARK:- Variables
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Pending Requests"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "green")
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
      
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
        self.setNavButton()
        self.settupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.pendingRidesDetailsApi()
    }
    //MARK:- User Defined Func
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
}
extension PendingRequestViewController : UITableViewDelegate,UITableViewDataSource {
    func settupTableView(){
        self.pendingList.delegate = self
        self.pendingList.dataSource = self
        self.pendingList.tableFooterView = UIView()
        self.pendingList.register(UINib(nibName: "PendingCell", bundle: nil), forCellReuseIdentifier: "PendingCell")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if (pendingReqData.count ) == 0 {
            tableView.setEmptyMessage("No Data Found.")
        } else {
            tableView.removeErrorMessage()
        }
        return pendingReqData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PendingCell", for: indexPath) as! PendingCell
        var modal = pendingReqData[indexPath.row]
        var from = self.pendingReqData.first?.pickupAdress ?? ""
        kDropAddress = self.pendingReqData.first?.dropAddress ?? ""
        kDistanceInMiles = self.pendingReqData.first?.distance ?? ""
//        cell.totalFareLbl.text =     "$" + "\(self.pendingReqData.first?.amount ?? "")"
      //  cell.totalDistanceLbl.text = "\(self.pendingReqData.first?.distance ?? "")" +  " " + "Miles"
        cell.fromAddressLbl.text =  self.pendingReqData.first?.pickupAdress ?? ""
        cell.toAddressLbl.text = self.pendingReqData.first?.dropAddress ?? ""
        cell.acceptBtn.tag = indexPath.row
        cell.rejectBtn.tag = indexPath.row
        cell.acceptBtn.addTarget(self, action: #selector(acceptBtnAction), for: .touchUpInside)
        cell.rejectBtn.addTarget(self, action: #selector(rejectBtnAction), for: .touchUpInside)
        
        if self.pendingReqData[indexPath.row].user_lastname == ""{
            cell.driverName.text = "Boss"
        }else{
            cell.driverName.text = self.pendingReqData[indexPath.row].user_lastname ?? ""
        }
      
        //cell.amount_lbl.text = " $" + "\(self.acceptedReqData[indexPath.row].amount ?? "")"
            //   cell.dateLbl.text = self.getStringFormat(date: self.pendingReqData[indexPath.row].time ?? "") + " ,"
        cell.timeLbl.text =  self.pendingReqData[indexPath.row].time ?? ""
        return cell
    }
    @objc func acceptBtnAction(_ sender: UIButton) {
        let modal = pendingReqData[sender.tag]
        self.acceptRejectStatus(confirmStatus: "ACCEPTED", rideId: modal.rideID ?? "")
        
        
      
    }
    
    @objc  func rejectBtnAction(_ sender: UIButton) {
        let modal = pendingReqData[sender.tag]
        self.acceptRejectStatus(confirmStatus:  "CANCELLED", rideId: modal.rideID ?? "")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "RideDetailsViewController") as! RideDetailsViewController
        vc.screen = "accept"
        vc.ridedetail = self.pendingReqData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK:- Web Api
extension PendingRequestViewController{
    //MARK:- get pending ride api
    func pendingRidesDetailsApi(){
        let url = "api/user/rides?status=PENDING"
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: url,authRequired: true) { (value) in
            print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                if (value["status"] as? Int ?? 0) == 1{
                    let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                    do{
                        self.pendingReqData.removeAll()
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        self.pendingReqData = try newJSONDecoder().decode(rides.self, from: jsonData)
                        self.pendingList.reloadData()
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    //MARK:- accept ride api 
    func acceptRejectStatus(confirmStatus : String , rideId : String ){
        let param = [ "ride_id" : rideId ,"status" : confirmStatus]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "accept_ride", params: param,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            print(value)
            let msg = (value["message"] as? String ?? "")
            if ((value["status"] as? Int ?? 0) == 1){
                self.pendingRidesDetailsApi()
            }else{
                self.showAlert("Driver RideshareRates", message: msg)
            }
        }
    }
}
