//
//  PaymentApi.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//


import UIKit
import Alamofire

extension PaymentVC {
    // MARK:- save card api
    func savedCardApi(){
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "card_list",authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                if (value["status"] as? Int ?? 0) == 1{
                    let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        self.cardData = try newJSONDecoder().decode(userCardData.self, from: jsonData)
                        if self.cardData.count == 0{
                            kCardId = ""
                        }
                        
                        for item in data {
                            if let isDefault = item["is_default"] as? Int, isDefault == 1 {
                                if let id = item["id"] as? String {
                                    kCardId = id
                                    break // Found the first matching object, no need to continue searching
                                }
                            }else{
                                kCardId = ""
                            }
                        }
                        
                        
//                        let card_id = self.cardData[index.row].id ?? ""
//                        kCardId = card_id
                        self.payment_tableView.reloadData()
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
            else{
                self.showAlert("Rider RideshareRates", message: "Could not get response")
            }
        }
    }
    
    // MARK:- pay tip amount api
    func TIPApi(rideId:String,amount:String,card_id:String){
        let param = ["ride_id":rideId,"tip_amount":amount ,"card_id" : card_id]
        print(param)
        Indicator.shared.showProgressView(self.view)
        let urlString = "\(baseURL)pay_tip_amount"
        let url = URL.init(string: urlString)
        print(urlString)
        var headers: HTTPHeaders = [:]
        headers = ["Authorization" : "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? "")
        ]
        print(headers)
        AF.request(urlString, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
            .responseString { response in
                print("responseString: \(response)")
                Indicator.shared.hideProgressView()
                switch (response.result) {
                case .success(let JSON):
                    print("JSON: \(JSON)")
                    
                      let str =  "\(JSON)"

                      let dict = self.convertStringToDictionary(text: str)
                      print("Finally dict is here=======\(dict)")
                      
                      if let detailsDict = dict as NSDictionary? {
                          print("Parse Data")
                          let msg = detailsDict["message"] as? String ?? ""
                          print(msg)
                          if (dict?["status"] as? Int ?? 0) == 1 {
                            self.setdefaultCardApi(card_id: card_id, is_default: "1")
                            self.showAlertWithBackButton("Rider RideshareRates", message: "\(msg)")
                          }
                          else{
                              self.showAlert("Rider RideshareRates", message: "\(msg)")
                          }
                      }
                    break;
                case .failure(let error):
                    print(error)
                    self.showAlert("Rider RideshareRates", message: "\(error.localizedDescription)")
                    break
                }
            }
    }
    // MARK:- payment api
    func payApi(rideId:String,amount:String,card_id:String){
        let param = ["ride_id":rideId,"amount":amount ,"card_id" : card_id, "txn_id" : txnID]
        print(param)
        Indicator.shared.showProgressView(self.view)
        let urlString = "\(baseURL)payment"
        let url = URL.init(string: urlString)
        var headers: HTTPHeaders = [:]
        headers = ["Authorization" : "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? "")
        ]
        print(headers)
        AF.request(urlString, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
            .responseString { response in
                print("responseString: \(response)")
                Indicator.shared.hideProgressView()
                switch (response.result) {
                case .success(let JSON):
                    print("JSON: \(JSON)")
                    
                      let str =  "\(JSON)"

                      let dict = self.convertStringToDictionary(text: str)
                      print("Finally dict is here=======\(dict)")
                      
                      if let detailsDict = dict as NSDictionary? {
                          print("Parse Data")
                          let msg = detailsDict["message"] as? String ?? ""
                          print(msg)
                          if (dict?["status"] as? Int ?? 0) == 1 {
                            self.setdefaultCardApi(card_id: card_id, is_default: "1")
                            self.showAlertWithBackButton("Rider RideshareRates", message: "\(msg)")
                          }
                          else{
                              self.showAlert("Rider RideshareRates", message: "\(msg)")
                          }
                      }
                    break;
                case .failure(let error):
                    print(error)
                    self.showAlert("Rider RideshareRates", message: "\(error.localizedDescription)")
                    break
                }
            }
    }
    // MARK:- make card default api
    func setdefaultCardApi(card_id:String,is_default:String){
        let param = ["card_id":card_id,"is_default":is_default]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "make_default", params: param,authRequired: true) { (Value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                let msg = (Value["message"] as? String ?? "")
                if (Value["status"] as? Int ?? 0) == 1{
                    print(Value)
                    self.savedCardApi()
                }else{
                    self.showAlert("Rider RideshareRates", message: msg)
                }
            }
        }
    }
    // MARK:- delete card api 
    func deleteCardApi(card_id:String){
        let param = ["card_id":card_id]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "delete_card", params: param,authRequired: true) { (Value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                let msg = (Value["message"] as? String ?? "")
                if (Value["status"] as? Int ?? 0) == 1{
                    print(Value)
                    self.savedCardApi()
                    //   self.showToast(message: "\(msg)")
                    self.payment_tableView.reloadData()
                }else{
                    self.showAlert("Rider RideshareRates", message: msg)
                }
            }
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
}
