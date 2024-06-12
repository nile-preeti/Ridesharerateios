//
//  CompletedRidesViewController.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit
import CoreLocation
class CompletedRidesViewController: UIViewController {
    //MARK:- OUTLETS
    @IBOutlet weak var completedRides_tableView: UITableView!
    //MARK:- Variables
    var conn = webservices()
    var completedRidesData = [CompletedRidesData]()
    
    // city,state,country
    var picupAdd = [String]()
    var DropAdd = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.completedRides_tableView.dataSource = self
        self.completedRides_tableView.delegate = self
        self.registerCell()
        self.setNavButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.complettedRidesDetailsApi()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Completed Rides"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = "Completed Rides"
    }
    
    
    
    //MARK:- User Defined Func
    func registerCell(){
        let compNib = UINib(nibName: "CompletedRidesTableViewCell", bundle: nil)
        self.completedRides_tableView.register(compNib, forCellReuseIdentifier: "CompletedRidesTableViewCell")
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
}

//MARK:- Table View Datasource
extension CompletedRidesViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.completedRidesData.count ) == 0 {
            tableView.setEmptyMessage("No Data Found.")
        } else {
            tableView.removeErrorMessage()
        }
        return self.completedRidesData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.completedRides_tableView.dequeueReusableCell(withIdentifier: "CompletedRidesTableViewCell") as! CompletedRidesTableViewCell
       
//        var latt = completedRidesData[indexPath.row].pickupLat as! String
//        var lngg = completedRidesData[indexPath.row].pickupLong as! String
//        let lat: Double = Double(latt)!
//        let lng: Double = Double(lngg)!
//        let location = CLLocation(latitude: lat, longitude: lng)
//        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
//                        if error != nil {
//                            return
//                        }else{
//                            let country = placemarks?.first?.country as! String
//
//                            let city = placemarks?.first?.locality as! String
//                            let state = placemarks?.first?.administrativeArea as! String
//                            self.picupAdd.append(city)
//                            self.picupAdd.append(state)
//                            self.picupAdd.append(country)
//                            let ab = self.picupAdd.joined(separator: ", ")
//                            cell.pickUpAddress_lbl.text = ab
//                            self.picupAdd.removeAll()
//                        }
//                    })
//        var Dlatt = completedRidesData[indexPath.row].dropLat as! String
//        var Dlngg = completedRidesData[indexPath.row].dropLong as! String
//        let Dlat: Double = Double(Dlatt)!
//        let Dlng: Double = Double(Dlngg)!
//        let Dlocation = CLLocation(latitude: Dlat, longitude: Dlng)
//        CLGeocoder().reverseGeocodeLocation(Dlocation, completionHandler: {(placemarks, error) -> Void in
//                        if error != nil {
//                            return
//                        }else{
//                            let country = placemarks?.first?.country as! String
//
//                            let city = placemarks?.first?.locality as! String
//                            let state = placemarks?.first?.administrativeArea as! String
//                            self.picupAdd.append(city)
//                            self.picupAdd.append(state)
//                            self.picupAdd.append(country)
//                            let ab = self.picupAdd.joined(separator: ", ")
//                            cell.dropAddress_lbl.text = ab
//                            self.picupAdd.removeAll()
//                        }
//                    })
        
//        let result = getlatlnt(latt: Dlatt, lngg: Dlngg)
//        cell.dropAddress_lbl.text = result
        cell.dropAddress_lbl.text = self.completedRidesData[indexPath.row].pickupAdress ?? ""
        cell.pickUpAddress_lbl.text = self.completedRidesData[indexPath.row].dropAddress ?? ""
        
        if self.completedRidesData[indexPath.row].user_lastname ?? "" == ""{
            cell.driverName_lbl.text = "Boss"
        }else{
            cell.driverName_lbl.text = self.completedRidesData[indexPath.row].user_lastname ?? ""
        }
       
     //   cell.amount_lbl.text = "$" + "\(self.completedRidesData[indexPath.row].amount ?? "")"
     //   cell.date_lbl.text =  getStringFormat(date: (self.completedRidesData[indexPath.row].time ?? "")) + " ,"
        cell.time_lbl.text = self.completedRidesData[indexPath.row].time ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "RideDetailsViewController") as! RideDetailsViewController
        vc.ridesStatusData = self.completedRidesData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    func getlatlnt(latt:String, lngg: String) -> String {
////        var latt = completedRidesData[indexPath.row].pickupLat as! String
////        var lngg = completedRidesData[indexPath.row].pickupLong as! String
//        let lat: Double = Double(latt)!
//        let lng: Double = Double(lngg)!
//        let ab = String()
//        let location = CLLocation(latitude: lat, longitude: lng)
//        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
//                        if error != nil {
//                            return
//                        }else{
//                            let country = placemarks?.first?.country as! String
//
//                            let city = placemarks?.first?.locality as! String
//                            let state = placemarks?.first?.administrativeArea as! String
//                            self.picupAdd.append(city)
//                            self.picupAdd.append(state)
//                            self.picupAdd.append(country)
//                            let ab = self.picupAdd.joined(separator: ", ")
//
//                        }
//                    })
//
//        return ab
//    }
    
}
//MARK:- Web Api
extension CompletedRidesViewController{
    //MARK:- complete ride api 
    func complettedRidesDetailsApi(){
        let url = "api/user/rides?status=COMPLETED"
        Indicator.shared.showProgressView(self.view)
        print(url)
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: url,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                if (value["status"] as? Int ?? 0) == 1{
                    print(value)
                    let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        self.completedRidesData = try newJSONDecoder().decode(completed.self, from: jsonData)
                        self.completedRides_tableView.reloadData()
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

