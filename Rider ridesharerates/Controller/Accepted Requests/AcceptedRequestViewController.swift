//
//  AcceptedRequestViewController.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//


import UIKit

class AcceptedRequestViewController: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var acceptedReq_tableView: UITableView!
    
    
    //MARK:- Variables
    let conn = webservices()
    var acceptedReqData = [RidesData]()
    
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.acceptedReq_tableView.dataSource = self
        self.acceptedReq_tableView.delegate = self
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
        self.navigationItem.title = "Accepted Requests"
        self.acceptedRidesDetailsApi()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK:- User Defined Func
    
    func registerCell(){
        
        let acceptNib = UINib(nibName: "CompletedTableViewCell", bundle: nil)
        self.acceptedReq_tableView.register(acceptNib, forCellReuseIdentifier: "CompletedTableViewCell")
    }
    
    func setNavButton(){
        
        let logoBtn = UIButton(type: .custom)
        logoBtn.setImage(UIImage(named: "shape_28"), for: .normal)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        

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
        
        let cell = self.acceptedReq_tableView.dequeueReusableCell(withIdentifier: "CompletedTableViewCell") as! CompletedTableViewCell
        cell.pickUpLocation_lbl.text = self.acceptedReqData[indexPath.row].pickupAdress ?? ""
        cell.dropLocation_lbl.text = self.acceptedReqData[indexPath.row].dropAddress ?? ""
        if self.acceptedReqData[indexPath.row].driver_lastname == ""{
            cell.driverName_lbl.text = "Boss"
        }else{
            cell.driverName_lbl.text = self.acceptedReqData[indexPath.row].driver_lastname ?? "Boss"
        }
        cell.date_lbl.text = self.acceptedReqData[indexPath.row].time ?? ""
     //   cell.time_lbl.text = self.getStringTimeFormat(date: self.acceptedReqData[indexPath.row].time ?? "")
        return cell
    }
    
}
//MARK:- Table View Delegate

extension AcceptedRequestViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "RideDetailsViewController") as! RideDetailsViewController
        vc.ridesStatusData = self.acceptedReqData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- Web Api
extension AcceptedRequestViewController{
    // MARK:- Accepted Request API
    func acceptedRidesDetailsApi(){
        
        let url = "rides?status=ACCEPTED"
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
                        self.acceptedReqData = try newJSONDecoder().decode(rides.self, from: jsonData)
                        print(self.acceptedReqData)
                        self.acceptedReq_tableView.reloadData()
                    }catch{
                        
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
