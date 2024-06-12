//
//  welcomeVC.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit

class welcomeVC: UIViewController {

    @IBOutlet weak var mTableV: UITableView!
    var tableARR = ["Car Registration","Driver's License","TNC/INSURANCE","vehicle inspection"]
    var arr = ["upload document","upload document","upload document","upload document"]
    let conn = webservices()
    var profileDetails : ProfileData?

    override func viewDidLoad() {
        super.viewDidLoad()
        mTableV.delegate = self
        mTableV.dataSource = self
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        
       // getProfileDataApi()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        getdocumentaApi()
        logoutAPI()
    }
    //MARK:- logout api
    func logoutAPI(){
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "updateloginlogout", params: ["status" : 2], authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
               // self.logO()
            }
        }
    }
    //MARK:- check document expiry api 
    func getdocumentaApi() {
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "get_check_document_expiry",authRequired: true) { (value) in
            print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                if value["car_expiry"] as? Bool == false {
                    self.arr[0] = "Uploaded Successfully"
                }
                if value["license_expiry"] as? Bool == false{
                    self.arr[1] = "Uploaded Successfully"
                }
                if value["insurance_expiry"] as? Bool == false {
                    self.arr[2] = "Uploaded Successfully"
                }
                if value["inspection_expiry"] as? Bool == false{
                    self.arr[3] = "Uploaded Successfully"
                }
                if value["car_expiry"] as? Bool == false && value["license_expiry"] as? Bool == false && value["insurance_expiry"] as? Bool == false &&   value["inspection_expiry"] as? Bool == false{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                self.mTableV.reloadData()
            }
        }
    }
    
    
}
extension welcomeVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableARR.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.mTableV.dequeueReusableCell(withIdentifier: "welcomeVCTableViewCellID") as! welcomeVCTableViewCell
        cell.mTitleLBL.text = tableARR[indexPath.row]
        cell.mStatusLBL.text = arr[indexPath.row]
        
        if arr[indexPath.row] == "Uploaded Successfully"{
            cell.mStatusLBL.textColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
            cell.mImg.image = UIImage(systemName: "hand.thumbsup.fill")
            cell.mImg.tintColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
        }else{
            cell.mStatusLBL.textColor = .red
            cell.mImg.image = UIImage(systemName: "exclamationmark.triangle.fill")
            cell.mImg.tintColor = .red
        }
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(identifier: "UploadDocVCID") as! UploadDocVC
        vc.TitleLBL = tableARR[indexPath.row]
       // vc.mTitleLBL.text = "Upload " + tableARR[indexPath.row]
      //  vc.ridesStatusData = self.completedRidesData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
