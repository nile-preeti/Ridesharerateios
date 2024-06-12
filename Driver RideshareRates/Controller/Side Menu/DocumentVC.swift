//
//  DocumentVC.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit

class DocumentVC: UIViewController {
    
    @IBOutlet weak var mTableV: UITableView!
    var tableARR = ["Car Registration","Driver's License","TNC/INSURANCE","Background check","vehicle inspection"]
    var arr = ["Pending","Pending","Pending","Pending","Pending"]
    let conn = webservices()
    override func viewDidLoad() {
        super.viewDidLoad()
        mTableV.delegate = self
        mTableV.dataSource = self
        self.setNavButton()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "green")
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "Document"
        getdocumentaApi()
    }
    //MARK:- get approval document status api
    func getdocumentaApi() {
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "get_approval_document_status",authRequired: true) { (value) in
            print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                
                print(value)
                
                if ((value["data"] as? [String:Any]) != nil){
                    var model = [String:Any]()
                    model = value["data"] as! [String : Any]
                   
                    
                    if model["car_registration_approve_status"] as? String == "1" {
                        self.arr[0] = "Approved"
                    }
                    if model["license_approve_status"] as? String == "1"{
                        self.arr[1] = "Approved"
                    }
                    if model["insurance_approve_status"] as? String == "1" {
                        self.arr[2] = "Approved"
                    }
                    if model["inspection_approval_status"] as? String == "1" {
                        self.arr[4] = "Approved"
                    }
                    if model["car_expiry"] as? Bool == true{
                        self.arr[0] = "Expired"
                    }
                    if model["license_expiry"] as? Bool == true{
                        self.arr[1] = "Expired"
                    }
                    if model["insurance_expiry"] as? Bool == true{
                        self.arr[2] = "Expired"
                    }
//                    if model["identification_expiry"] as? Bool == true{
//                        self.arr[3] = "Expired"
//                    }else{
//                        self.arr[3] = "Approved"
//                    }
                    if model["inspection_expiry"] as? Bool == true{
                        self.arr[3] = "Expired"
                    }
                }
                if value["background_approval_status"] as? String == "1" {
                    self.arr[3] = "Approved"
                }
                self.mTableV.reloadData()
            }
        }
    }
    //MARK:- set nav button 
    func setNavButton(){
        
        let logoBtn = UIButton(type: .custom)
        logoBtn.setImage(UIImage(named: "shape_28"), for: .normal)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        
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
extension DocumentVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableARR.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.mTableV.dequeueReusableCell(withIdentifier: "welcomeVCTableViewCellID") as! welcomeVCTableViewCell
        cell.mTitleLBL.text = tableARR[indexPath.row]
        cell.mStatusLBL.text = arr[indexPath.row]
        if arr[indexPath.row] == "Approved"{
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
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(identifier: "UploadDocVCID") as! UploadDocVC
//        vc.TitleLBL = tableARR[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
}
