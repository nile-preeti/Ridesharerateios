//
//  BookingFeeVC.swift
//  Rider ridesharerates
//
//  Created by malika on 26/12/23.
//

import UIKit
import WebKit

class BookingFeeVC: UIViewController {

    @IBOutlet var mWebview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "Booking fees"
        // Do any additional setup after loading the view.
        setNavButton()
        let myURL = URL(string:"\(baseURL)app-booking-charges")
        let myRequest = URLRequest(url: myURL!)
        mWebview.load(myRequest)
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
}
