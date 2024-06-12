//
//  helpVC.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit

class helpVC: UIViewController {
    @IBOutlet weak var completedRides_tableView: UITableView!

    @IBOutlet weak var mHrlpTableHeight: NSLayoutConstraint!
    @IBOutlet weak var mHelpTV: UITableView!
    
    //MARK:- Variables
    var conn = webservices()
    var completedRidesData = [CompletedRidesData]()
    
//    let conn = webservices()
    var  QueData = [RidesData]()

    var helpscreen = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        completedRides_tableView.isHidden = true
        self.completedRides_tableView.dataSource = self
        self.completedRides_tableView.delegate = self
        self.registerCell()
       // self.setNavButton()
        
        
        questionApi()
        complettedRidesDetailsApi()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "green")
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
      
        self.setNavButton()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- User Defined Func
    func registerCell(){
        let compNib = UINib(nibName: "CompletedRidesTableViewCell", bundle: nil)
        self.completedRides_tableView.register(compNib, forCellReuseIdentifier: "CompletedRidesTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "Help"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
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

//MARK:- Table View Datasource

extension helpVC: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == completedRides_tableView{
            if (self.completedRidesData.count ) == 0 {
                tableView.setEmptyMessage("No Data Found.")
            } else {
                tableView.removeErrorMessage()
            }
            return self.completedRidesData.count
        }else{
        if (self.QueData.count ) == 0 {
            tableView.setEmptyMessage("No Data Found.")
        } else {
            mHrlpTableHeight.constant = CGFloat(QueData.count * 110)
            tableView.removeErrorMessage()
        }
        return self.QueData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == completedRides_tableView{
            let cell = self.completedRides_tableView.dequeueReusableCell(withIdentifier: "CompletedRidesTableViewCell") as! CompletedRidesTableViewCell
            cell.pickUpAddress_lbl.text = self.completedRidesData[indexPath.row].pikupLocation ?? ""
            cell.dropAddress_lbl.text = self.completedRidesData[indexPath.row].dropAddress ?? ""
            cell.driverName_lbl.text = self.completedRidesData[indexPath.row].userName ?? ""
        
         //   cell.date_lbl.text =  getStringFormat(date: (self.completedRidesData[indexPath.row].time ?? "")) + " ,"
            cell.time_lbl.text = self.completedRidesData[indexPath.row].time ?? ""
            return cell
        }else{
        
        let cell = self.mHelpTV.dequeueReusableCell(withIdentifier: "helpTableViewCellID") as! helpTableViewCell
        if helpscreen == "second"{
            cell.mLabel.text = QueData[indexPath.row].question

        }else{
            cell.mLabel.text = QueData[indexPath.row].question_category

        }
        
        return cell
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == completedRides_tableView{
            let vc = self.storyboard?.instantiateViewController(identifier: "helpDetailVCID") as! helpDetailVC
            vc.HelpTitle = completedRidesData[indexPath.row].rideID!
           
            vc.ride_id = completedRidesData[indexPath.row].rideID!
            vc.question_id = "1"
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            if helpscreen == "second"{
                let vc = self.storyboard?.instantiateViewController(identifier: "helpDetailVCID") as! helpDetailVC
                vc.HelpTitle = QueData[indexPath.row].question!
                vc.email = QueData[indexPath.row].email!
                vc.question_id = QueData[indexPath.row].id!
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let question_id = QueData[indexPath.row].id!
                get_question_category(id: question_id)
                helpscreen = "second"
            }
        }
        
        
       
       
       
    }
}
extension helpVC{
    //MARK:-  get question api
    func questionApi(){
        
       // let url = "get_question_answer?question_category_id=7"
        let url = "get_question_category"
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
                        self.QueData = try newJSONDecoder().decode(rides.self, from: jsonData)
                        print(self.QueData)
                        self.mHelpTV.reloadData()
                    }catch{
                        
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    //MARK:-  complete ride api
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
    //MARK:- get question  and answer wirh question_category api 
    func get_question_category(id:String?){
        
       // let url = "get_question_answer?question_category_id=7"
        let url = "get_question_answer?question_category_id=" + id!
        Indicator.shared.showProgressView(self.view)
        if id == "1"{
            completedRides_tableView.isHidden = false
        }else{
            completedRides_tableView.isHidden = true
        }
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: url,authRequired: true) { (value) in
            
            print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                
                if (value["status"] as? Int ?? 0) == 1{
                    
                    print(value)
                    let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        self.QueData = try newJSONDecoder().decode(rides.self, from: jsonData)
                        print(self.QueData)
                        self.mHelpTV.reloadData()
                    }catch{
                        
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    
}
