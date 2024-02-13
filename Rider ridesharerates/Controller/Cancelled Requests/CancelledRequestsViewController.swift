//
//  CancelledRequestsViewController.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//

import UIKit

class CancelledRequestsViewController: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var cancelledReq_tableView: UITableView!
    
    
    //MARK:- Variables
    
    var conn = webservices()
    var cancelledRideData = [RidesData]()
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cancelledReq_tableView.dataSource = self
        self.cancelledReq_tableView.delegate = self
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "green")
        self.navigationController?.navigationBar.backgroundColor = .black
        self.registerCell()
        self.setNavButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "Cancelled Rides"
        self.cancelledRidesDetailsApi()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK:- User Defined Func
    
    func registerCell(){
        
        let acceptNib = UINib(nibName: "CompletedTableViewCell", bundle: nil)
        self.cancelledReq_tableView.register(acceptNib, forCellReuseIdentifier: "CompletedTableViewCell")
    }
    
    func setNavButton(){
        
        let logoBtn = UIButton(type: .custom)
        logoBtn.setImage(UIImage(named: "shape_28"), for: .normal)
        self.navigationItem.title = "Set Destination"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = .black
        logoBtn.addTarget(self, action: #selector(tapNavButton), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: logoBtn)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func tapNavButton(){
        
        let presentedVC = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController")
        let nvc = UINavigationController(rootViewController: presentedVC)
        present(nvc, animated: false, pushing: true, completion: nil)
    }
    
    //MARK:- Button Action
    
    
    
    
}
//MARK:- Table View Datasource

extension CancelledRequestsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.cancelledRideData.count ) == 0 {
            tableView.setEmptyMessage("No Data Found.")
        } else {
            tableView.removeErrorMessage()
        }
        return self.cancelledRideData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.cancelledReq_tableView.dequeueReusableCell(withIdentifier: "CompletedTableViewCell") as! CompletedTableViewCell
        cell.pickUpLocation_lbl.text = self.cancelledRideData[indexPath.row].pickupAdress ?? ""
        cell.dropLocation_lbl.text = self.cancelledRideData[indexPath.row].dropAddress ?? ""
        if self.cancelledRideData[indexPath.row].driver_lastname == ""{
            cell.driverName_lbl.text = "Boss"

        }else{
            cell.driverName_lbl.text = self.cancelledRideData[indexPath.row].driver_lastname ?? "Boss"

        }
       // cell.driverName_lbl.text = self.cancelledRideData[indexPath.row].driver_lastname ?? "Boss"
        cell.date_lbl.text = self.cancelledRideData[indexPath.row].time ?? ""
        //cell.time_lbl.text = self.getStringTimeFormat(date: self.cancelledRideData[indexPath.row].time ?? "")
        return cell
    }
    
}
//MARK:- Table View Datasource

extension CancelledRequestsViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(identifier: "RideDetailsViewController") as! RideDetailsViewController
        vc.ridesStatusData = self.cancelledRideData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK:- Web Api
extension CancelledRequestsViewController{
    
    //MARK:- Cancelled Rides Api
    func cancelledRidesDetailsApi(){
        
        let url = "rides?status=CANCELLED"
        Indicator.shared.showProgressView(self.view)
        
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: url,authRequired: true) { (value) in
            
            print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                
                if (value["status"] as? Int ?? 0) == 1{
                    
                    print(value)
                    let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                    
                    do{
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        self.cancelledRideData = try newJSONDecoder().decode(rides.self, from: jsonData)
                        print(self.cancelledRideData)
                        self.cancelledReq_tableView.reloadData()
                    }catch{
                        
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
