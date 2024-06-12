//
//  SideMenuViewController.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit

class SideMenuViewController: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var mStartRatingLBL: UILabel!
    @IBOutlet weak var sideMenu_tableView: UITableView!
    @IBOutlet weak var userName_lbl: UILabel!
    @IBOutlet weak var email_lbl: UILabel!
    @IBOutlet weak var userProfileImg: SetImageView!
    @IBOutlet weak var mTimerLBL: UILabel!
    
    var secs = 0
    var timer = Timer()
    var count = 0
    //MARK:- Variables
    var sideMenuNameArr = ["Home","Documents","Pending Rides","Accepted Rides","Completed Rides","Cancelled Rides","My Earnings","Profile","Help","Bank Detail","Privacy Policy","About Us","Delete Account","Logout"]
    var sideIcon = [UIImage(named: "home"),UIImage(named: "document-text"),UIImage(named: "pending_request"),UIImage(named: "accepted_req"),UIImage(named: "completed_rides"),UIImage(named: "cancelled_rides"),UIImage(named: "payment-history"),UIImage(named: "profile"),UIImage(named: "help"),UIImage(named: "bank-detail"),UIImage(named: "policy"),UIImage(named: "policy"),UIImage(named: "DeleteAccount"),UIImage(named: "logout")]
    var conn = webservices()
    var profileDetails : ProfileData?
    
    var screen = ""
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //UIImage(named: "pending_request")
        self.sideMenu_tableView.dataSource = self
        self.sideMenu_tableView.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        self.registerCell()
        self.gettingProfileApiData()
        
    //    count = NSUSERDEFAULT.value(forKey: Ktimer) as? Int ?? 0
       
      }
      func timeString(time: TimeInterval) -> String {
          let hours = Int(time) / 3600
          let minutes = Int(time) / 60 % 60
          let seconds = Int(time) % 60
          return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
      }
    @objc func update() {
        if screen == "inscreen"{
            let status = NSUSERDEFAULT.value(forKey: KOnOffStatus) as? String ?? ""

            if status == "online"{
                let time = timeString(time: TimeInterval(count))
                count = count + 1
                NSUSERDEFAULT.set((count), forKey: Ktimer)
               // UserDefaults.standard.set(count, forKey: Ktimer)
                mTimerLBL.text = time
            }else{
                let time = timeString(time: TimeInterval(count))
               // count = count + 1
                NSUSERDEFAULT.set((count), forKey: Ktimer)
               // UserDefaults.standard.set(count, forKey: Ktimer)
                mTimerLBL.text = time
            }
            
            
          
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        screen = "inscreen"
        count = NSUSERDEFAULT.value(forKey: Ktimer) as? Int ?? 0
        NavigationManager.pushToLoginVC(from: self)
        var timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
//    
//    
//     func checkdevicetokenAPI(){
//        self.conn.startConnectionWithPostType(getUrlString: "checkdevicetoken", params: ["":""], authRequired: true) { (value) in
//            Indicator.shared.hideProgressView()
//            if self.conn.responseCode == 1{
//                print(value)
//               // let device_type = (value["device_type"] as? String ?? "")
//                let device_token = (value["device_token"] as? String ?? "")
//                let deviceID =  UIDevice.current.identifierForVendor?.uuidString
//                if device_token != deviceID{
//                    NavigationManager.pushToLoginVC(from: self)
//                }
//            }
//        }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        screen = ""
        timer.invalidate()
     //   timer = nil
    }
    
    //MARK:- get profile api
    func gettingProfileApiData(){
      
        self.userName_lbl.text = NSUSERDEFAULT.value(forKey: kName) as? String ?? ""
        self.mStartRatingLBL.text = NSUSERDEFAULT.value(forKey: ktotal_rating) as? String ?? ""
        self.email_lbl.text = NSUSERDEFAULT.value(forKey: kEmail) as? String ?? ""
        getProfileDataApi()
        UserDefaults.standard.setValue((self.profileDetails?.profile_pic ?? ""), forKey: "pic")
        let pic =   NSUSERDEFAULT.value(forKey: kProfilePic) as? String ?? ""
        print("Content\(pic)")
        if pic == " " {
            var yourImage: UIImage = UIImage(named: "user")!
            self.userProfileImg.image = yourImage
        }
        else{
            self.userProfileImg.sd_setImage(with:URL(string: pic ), placeholderImage: UIImage(named: ""), completed: nil)
        }
    }
    
    func getProfileDataApi() {
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "get_profile",authRequired: true) { (value) in
            print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                
                print(value)
                if (value["status"] as? Int ?? 0) == 1{
                    let data = (value["data"] as? [String:AnyObject] ?? [:])
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        self.profileDetails = try newJSONDecoder().decode(ProfileData.self, from: jsonData)
                        kProfileName =    self.profileDetails?.name ?? ""
                        kProfileMobile = self.profileDetails?.mobile ?? ""
                        if self.profileDetails?.last_name ?? "" == "" {
                            self.userName_lbl.text = "Boss"
                        }else{
                            self.userName_lbl.text = (self.profileDetails?.name_title ?? "")! + " " + (self.profileDetails?.last_name ?? "")!
                        }
                       
                       // self.setData()
                      //  self.profileTableView.reloadData()
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    func registerCell(){
        let sideMenuNib = UINib(nibName: "SideMenuTableViewCell", bundle: nil)
        self.sideMenu_tableView.register(sideMenuNib, forCellReuseIdentifier: "SideMenuTableViewCell")
    }
    //MARK:- Button Action
    @IBAction func tapHideShowMenu_btn(_ sender: Any) {
        if let presentedVC = presentedViewController {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            presentedVC.view.window!.layer.add(transition, forKey: kCATransition)
        }
        dismiss(animated: false, completion: nil)
    }
}

//MARK:- Table View Datasource
extension SideMenuViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sideMenuNameArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.sideMenu_tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell") as! SideMenuTableViewCell
        cell.sideMenu_icon.image = self.sideIcon[indexPath.row]
        cell.sideMenuTitle_lbl.text = self.sideMenuNameArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
//MARK:- Table View Delegate
extension SideMenuViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = self.storyboard?.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(vc, animated: true)
//        }else if indexPath.row == {
//            let vc = self.storyboard?.instantiateViewController(identifier: "SetDestinationViewController") as! SetDestinationViewController
//            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1{
            let vc = self.storyboard?.instantiateViewController(identifier: "DocumentVCID") as! DocumentVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 2{
            let vc = self.storyboard?.instantiateViewController(identifier: "PendingRequestViewController") as! PendingRequestViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 3{
            let vc = self.storyboard?.instantiateViewController(identifier: "AcceptedRequestViewController") as! AcceptedRequestViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 4{
            let vc = self.storyboard?.instantiateViewController(identifier: "CompletedRidesViewController") as! CompletedRidesViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 5{
            let vc = self.storyboard?.instantiateViewController(identifier: "CancelledRequestViewController") as! CancelledRequestViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 6{
            let vc = self.storyboard?.instantiateViewController(identifier: "PaymentHistoryViewController") as! PaymentHistoryViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 7{
            let vc = self.storyboard?.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 8{
            let vc = self.storyboard?.instantiateViewController(identifier: "helpVCID") as! helpVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 9{
            let vc = self.storyboard?.instantiateViewController(identifier: "BankDetailVC") as! BankDetailVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 10{
            let vc = self.storyboard?.instantiateViewController(identifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            vc.screen = "privacy-policy"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 11{
            let vc = self.storyboard?.instantiateViewController(identifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            vc.screen = "aboutUS"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 12{
            DispatchQueue.main.async {
                NavigationManager.pushToLoginVC(from: self)
            }
            
            let refreshAlert = UIAlertController(title: "Are you sure you want to delete account?" , message: " When you delete your account. you won't be able to retrieve the content and ride information on app.", preferredStyle: UIAlertController.Style.alert)
            let titleAttributes: [NSAttributedString.Key: Any] = [
                
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.white,
            ]
            let messageAttributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                .foregroundColor: UIColor.white,
            ]

            let attributedTitle = NSAttributedString(string: "Are you sure you want to delete account?", attributes: titleAttributes)
            let attributedMessage = NSAttributedString(string: " When you delete your account. you won't be able to retrieve the content and ride information on app.", attributes: messageAttributes)

            // Set the attributed title and message
            refreshAlert.setValue(attributedTitle, forKey: "attributedTitle")
            refreshAlert.setValue(attributedMessage, forKey: "attributedMessage")
            refreshAlert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.96)
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
                DispatchQueue.main.async {
                    NavigationManager.pushToLoginVC(from: self)
                }
                self.DeleteAccount()
              //  self.updateStatus(updateStatus: "3")

            }))
            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(refreshAlert, animated: true, completion: nil)
//            let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            self.navigationController?.setViewControllers([loginVc], animated: true)
         //  logout()
        }else if indexPath.row == 13{
            logout()
        }
    }
}
//MARK:- Web Api
extension SideMenuViewController {
    //MARK:- logout popup
    func logout() {
        let refreshAlert = UIAlertController(title: "Logout" , message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]
        let messageAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.white,
        ]

        let attributedTitle = NSAttributedString(string: "Logout", attributes: titleAttributes)
        let attributedMessage = NSAttributedString(string: "Are you sure you want to logout?", attributes: messageAttributes)

        // Set the attributed title and message
        refreshAlert.setValue(attributedTitle, forKey: "attributedTitle")
        refreshAlert.setValue(attributedMessage, forKey: "attributedMessage")
        refreshAlert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.96)
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
        //    self.logO()
            self.updateStatus(updateStatus: "3")

        }))
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    //MARK:- update driver status api
    func updateStatus(updateStatus : String){
        let param = ["is_online":updateStatus]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "update_driver_status", params: param,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            print("Updating Driver Status Data Api  \(value)")
            let msg = (value["message"] as? String ?? "")
            if ((value["status"] as? Int ?? 0) == 1){
                print(value)
                self.logoutt()
//                UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
//                if let appDomain = Bundle.main.bundleIdentifier {
//                    UserDefaults.standard.removePersistentDomain(forName: appDomain)
//                }
//                UserDefaults.standard.synchronize()
//                let domain = Bundle.main.bundleIdentifier!
//                UserDefaults.standard.removePersistentDomain(forName: domain)
//                UserDefaults.standard.synchronize()
//                let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                self.navigationController?.setViewControllers([loginVc], animated: true)

            }else{
                self.logoutt()
            }
        }
    }
    //MARK:- delete account api
    func DeleteAccount(){
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "delete_account",authRequired: true) { (value) in
            print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                self.logoutt()
            }
        }
    }
    //MARK:-logout api
    func logoutt(){
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "logout", params: [String : String](), authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                self.logO()
            }
        }
    }
    //MARK:- after logut move to login screen 
    func logO(){
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
        UserDefaults.standard.synchronize()
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.setViewControllers([loginVc], animated: true)
    }
}
