//
//  SideMenuViewController.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var mStartBTN: UIButton!
    @IBOutlet weak var sUser_img: SetImageView!
    @IBOutlet weak var sUserName_lbl: UILabel!
    @IBOutlet weak var sUserEmail_lbl: UILabel!
    @IBOutlet weak var sideMenu_tableView: UITableView!
    var conn = webservices()
    var profileDetails : ProfileData?
    //MARK:- Variables
    
    var sideMenuNameArr = ["Home","Pending Rides","Accepted Rides","Completed Rides","Cancelled Rides","Spend Details", "Payment Method" ,"Profile","Pre-authorized Policy","Privacy Policy","About Us","Delete Account","Log out"]
    var sideIcon = [UIImage(named: "home"),UIImage(named: "pending_request"),UIImage(named: "accepted_req"),UIImage(named: "completed_rides"),UIImage(named: "cancelled_rides"),UIImage(named: "money-send"),UIImage(named: "payment-history"),UIImage(named: "profile"),UIImage(named: "preauth"),UIImage(named: "privacy"),UIImage(named: "aboutus"),UIImage(named: "DeleteAccount"),UIImage(named: "logout")]
    
    
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.sideMenu_tableView.dataSource = self
        self.sideMenu_tableView.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        self.gettingProfileApiData()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .default
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
    }
    
      //MARK:- User Defined Func
      func gettingProfileApiData(){
          
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
                          self.mStartBTN.setTitle(self.profileDetails?.rider_total_rating, for: .normal)
                         // self.setData()
                          self.sUserName_lbl.text = (self.profileDetails?.name_title ?? "")! + " " + (self.profileDetails?.last_name ?? "")! 
                          
                          //                        self.userImg.isUserInteractionEnabled = false
                          //                        self.name_txtField.isUserInteractionEnabled = false
                          //                        self.email_txtField.isUserInteractionEnabled = false
                          //                        self.mobile_txtField.isUserInteractionEnabled = false
                      }catch{
                          print(error.localizedDescription)
                      }
                  }
              }
          }
          
           let pic =   NSUSERDEFAULT.value(forKey: kProfilePic) as? String ?? ""
          self.sUser_img.sd_setImage(with:URL(string: pic ), placeholderImage: UIImage(named: ""), completed: nil)
          self.sUser_img.layer.borderWidth = 1
          self.sUser_img.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.631372549, blue: 0.262745098, alpha: 1)
         
        //  self.sUserName_lbl.text = NSUSERDEFAULT.value(forKey: kName) as? String ?? ""
          self.sUserEmail_lbl.text = NSUSERDEFAULT.value(forKey: kEmail) as? String ?? ""
      }

    //MARK:- User Defined Func
    
    func registerCell(){
        
        let sideMenuNib = UINib(nibName: "SideTableViewCell", bundle: nil)
        self.sideMenu_tableView.register(sideMenuNib, forCellReuseIdentifier: "SideTableViewCell")
        
    }
    
    //MARK:- Button Action
    
    @IBAction func tapHideSideMenu(_ sender: Any) {
        
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
//MARK:- Side Table View Datasource

extension SideMenuViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sideMenuNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.sideMenu_tableView.dequeueReusableCell(withIdentifier: "SideTableViewCell", for: indexPath) as! SideTableViewCell
        
        cell.sideName_lbl.text = self.sideMenuNameArr[indexPath.row]
        cell.side_icon.image = self.sideIcon[indexPath.row]
        return cell
    }
    
}
//MARK:- Side Table View Delegate

extension SideMenuViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        if indexPath.row == 0{
            let vc = self.storyboard?.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 1{
            let vc = self.storyboard?.instantiateViewController(identifier: "PendingViewController") as! PendingViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 2{
            let vc = self.storyboard?.instantiateViewController(identifier: "AcceptedRequestViewController") as! AcceptedRequestViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 3{
            let vc = self.storyboard?.instantiateViewController(identifier: "CompletedRidesViewController") as! CompletedRidesViewController
            vc.vcCome = .CompletedRequest
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 4{
            
            let vc = self.storyboard?.instantiateViewController(identifier: "CancelledRequestsViewController") as! CancelledRequestsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 5{
            
            let vc = self.storyboard?.instantiateViewController(identifier: "MySpentVC") as! MySpentVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 6{
            let vc = self.storyboard?.instantiateViewController(identifier: "PaymentVC") as! PaymentVC
            vc.vcCome = .AddCard
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 7{
            let vc = self.storyboard?.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 8{
            let vc = self.storyboard?.instantiateViewController(identifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            vc.screen = "pre-authorized-policy"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 9{
            let vc = self.storyboard?.instantiateViewController(identifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            vc.screen = "privacy-policy"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 10{
            let vc = self.storyboard?.instantiateViewController(identifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            vc.screen = "aboutUS"
            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        else if indexPath.row == 11{
//           // logout()
//            let vc = self.storyboard?.instantiateViewController(identifier: "helpVCID") as! helpVC
//            self.navigationController?.pushViewController(vc, animated: true)
//            
        }else if indexPath.row == 11{
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
        }else if indexPath.row == 12{
            let refreshAlert = UIAlertController(title: "Logout" , message: "Are you sure you want to Logout?", preferredStyle: UIAlertController.Style.alert)
            let titleAttributes: [NSAttributedString.Key: Any] = [
                
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.white,
            ]
            let messageAttributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                .foregroundColor: UIColor.white,
            ]

            let attributedTitle = NSAttributedString(string: "Logout", attributes: titleAttributes)
            let attributedMessage = NSAttributedString(string: "Are you sure you want to Logout?", attributes: messageAttributes)

            // Set the attributed title and message
            refreshAlert.setValue(attributedTitle, forKey: "attributedTitle")
            refreshAlert.setValue(attributedMessage, forKey: "attributedMessage")
            refreshAlert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.96)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
                self.logout()
//                UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
//                UserDefaults.standard.synchronize()
//                let domain = Bundle.main.bundleIdentifier!
//                UserDefaults.standard.removePersistentDomain(forName: domain)
//                UserDefaults.standard.synchronize()
//                let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                self.navigationController?.setViewControllers([loginVc], animated: true)

            }))
            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
    }
}

extension SideMenuViewController {
    //MARK:- API for delete account
    func DeleteAccount(){
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "delete_account",authRequired: true) { (value) in
            print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                self.logO()
            }
        }
    }
//    func logout() {
//        let refreshAlert = UIAlertController(title: "Logout" , message: "Are you sure you want to Logout?", preferredStyle: UIAlertController.Style.alert)
//        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
//            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
//            UserDefaults.standard.synchronize()
//            let domain = Bundle.main.bundleIdentifier!
//            UserDefaults.standard.removePersistentDomain(forName: domain)
//            UserDefaults.standard.synchronize()
//            let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            self.navigationController?.setViewControllers([loginVc], animated: true)
//
//        }))
//        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
//        }))
//        present(refreshAlert, animated: true, completion: nil)
//    }
    //MARK:- logout api
    func logout(){
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "logout", params: [String : String](), authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                self.logO()
            }
        }
    }
    //MARK:- after login clear token and move to signin screen
    func logO(){
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.setViewControllers([loginVc], animated: true)
    }
}
