//
//  PrivacyPolicyVC.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit
import WebKit

class PrivacyPolicyVC: UIViewController, WKUIDelegate, WKNavigationDelegate  {
    //  var webView: WKWebView!

      @IBOutlet var webView: WKWebView!
      var screen = ""
      override func viewDidLoad() {
          super.viewDidLoad()
          self.setNavButton()
          
          if screen == "privacy-policy"{
              let myURL = URL(string:"\(baseURL)app-privacy-policy")
              let myRequest = URLRequest(url: myURL!)
              webView.load(myRequest)
          }else  if screen == "aboutUS"{
              let myURL = URL(string:"\(baseURL)app-about-us")
              let myRequest = URLRequest(url: myURL!)
              webView.load(myRequest)
          }
         
          //  let myURL = URL(string:"https://someUrlToMyApp.appspot.com")
         
          
          if #available(iOS 11.0, *) {
              webView.scrollView.contentInsetAdjustmentBehavior = .never;
          }
          
          webView.navigationDelegate = self
          
      }
             
  //           override func loadView() {
  //
  //               let webConfiguration = WKWebViewConfiguration()
  //               webConfiguration.dataDetectorTypes = [.all]
  //               webView = WKWebView(frame: .zero, configuration: webConfiguration)
  //               webView.uiDelegate = self
  //               view = webView
  //
  //           }
      
      func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                      decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
             guard
                 let url = navigationAction.request.url else {
                     decisionHandler(.cancel)
                     return
             }
             
             let string = url.absoluteString
          if (string.contains("mailto:"))    {
              let alert = UIAlertController(title: "Open with", message: nil, preferredStyle: .actionSheet)
              
              let openMailAction = UIAlertAction(title: "Mail", style: .default) { _ in
                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
                  decisionHandler(.cancel)
              }
              
              let openGmailAction = UIAlertAction(title: "Gmail", style: .default) { _ in
                  // Open Gmail using a generic URL scheme
                  let googleUrlString = "googlegmail://"

                  if let googleUrl = URL(string: googleUrlString) {
                      UIApplication.shared.open(googleUrl, options: [:]) {
                          success in
                          if !success {
                              if #available(iOS 10.0, *) {
                                  UIApplication.shared.open(googleUrl)
                              } else {
                                  UIApplication.shared.openURL(googleUrl)
                              }
                          }
                      }
                  }
                  decisionHandler(.cancel)
              }
              
              let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                  decisionHandler(.allow)
              }
              
              alert.addAction(openMailAction)
              alert.addAction(openGmailAction)
              alert.addAction(cancelAction)
              
              // Present the action sheet
              if let popoverController = alert.popoverPresentationController {
                  popoverController.sourceView = webView
                  popoverController.sourceRect = CGRect(x: webView.bounds.midX, y: webView.bounds.midY, width: 0, height: 0)
                  popoverController.permittedArrowDirections = []
              }
              
              present(alert, animated: true, completion: nil)
              
          } else {
              decisionHandler(.allow)
          }

         }
      
      
      
      
      
      //MARK:- User Defined Func
      func setNavButton(){
          let logoBtn = UIButton(type: .custom)
          logoBtn.setImage(UIImage(named: "shape_28"), for: .normal)
          self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
          self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
          self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
          logoBtn.addTarget(self, action: #selector(tapNavButton), for: .touchUpInside)
          let barButton = UIBarButtonItem(customView: logoBtn)
          self.navigationItem.leftBarButtonItem = barButton
          self.navigationController?.isNavigationBarHidden = false
          self.navigationItem.title = "Privacy Policy"
          
          
          if screen == "privacy-policy"{
              self.navigationItem.title = "Privacy Policy"
          }else if screen == "aboutUS"{
              self.navigationItem.title = "About Us"
          }
      }
      @objc func tapNavButton(){
          let presentedVC = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController")
          let nvc = UINavigationController(rootViewController: presentedVC)
          present(nvc, animated: false, pushing: true, completion: nil)
      }


  }
