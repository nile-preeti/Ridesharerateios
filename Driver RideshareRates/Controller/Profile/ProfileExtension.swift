//
//  ProfileExtension.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit
//MARK:- Table View Datasource
extension ProfileViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.profileDetails?.vehicleDetail?.count ?? 0
          }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = self.profileTableView.dequeueReusableCell(withIdentifier: "VechileDetailsTableViewCell") as! VechileDetailsTableViewCell
          //  cell.brandType_lbl.text = "\(self.profileDetails?.vehicleDetail?[indexPath.row].brand_name ?? "")"
            cell.modelName_lbl.text = "\(self.profileDetails?.vehicleDetail?[indexPath.row].model_name ?? "")"
            cell.vechileType_lbl.text =  "\(self.profileDetails?.vehicleDetail?[indexPath.row].vehicle_type ?? "")"
            cell.color_lbl.text = "\(self.profileDetails?.vehicleDetail?[indexPath.row].color ?? "")"
        
        if self.profileDetails?.vehicleDetail?[indexPath.row].seat_no == "9"{
            var arrayy = [String]()
            if self.profileDetails?.vehicleDetail?[indexPath.row].premium_facility != "" && self.profileDetails?.vehicleDetail?[indexPath.row].premium_facility != nil{
                arrayy = self.profileDetails?.vehicleDetail?[indexPath.row].premium_facility!.components(separatedBy: ",") ?? [""]
                cell.seatNo_lbl.text = "8"
            }else{
                cell.seatNo_lbl.text = "above 8"
            }
        }else{
          //  cell.seatNo_lbl.text = self.profileDetails?.vehicleDetail?[indexPath.row].seat_no ?? ""
            cell.seatNo_lbl.text = self.profileDetails?.vehicleDetail?[indexPath.row].seat_no ?? ""
        }
        
            
            cell.year_lbl.text = self.profileDetails?.vehicleDetail?[indexPath.row].year ?? ""
            cell.vechileNo_lbl.text =  "\(self.profileDetails?.vehicleDetail?[indexPath.row].vehicle_no ?? "")"
            let picNew =   self.profileDetails?.vehicleDetail?[indexPath.row].car_pic ?? ""
            cell.carInsurance.sd_setImage(with:URL(string: picNew ), placeholderImage: UIImage(named: "upload"), completed: nil)
            cell.edit_btn.tag = indexPath.row
            cell.edit_btn.addTarget(self, action: #selector(tapVechileEdit), for: .touchUpInside)
            cell.tick_btn.addTarget(self, action: #selector(checkBoxBtn), for: .touchUpInside)
            cell.tick_btn.tag = indexPath.row
            let model =  self.profileDetails?.vehicleDetail?[indexPath.row].status ?? ""
            if model == "2"{
                cell.tick_btn.setImage(UIImage(named: "uncheck"), for: .normal)
            }
            else{
                cell.tick_btn.setImage(UIImage(named: "check"), for: .normal)
            }
            if checkBtnStatus == true  {
                if self.selectedIndex == indexPath.row{
                    cell.tick_btn.isSelected  = true
                    cell.tick_btn.setImage(UIImage(named: "check"), for: .normal)
                }else{
                    cell.tick_btn.isSelected  = false
                    cell.tick_btn.setImage(UIImage(named: "uncheck"), for: .normal)
                }
            }
            cell.delete_btn.tag = indexPath.row
            cell.configure(indexPath: indexPath)
            cell.callBackDropDown = {index in
                self.showAlertWithActionOkandCancel(Title: "Delete", Message: "Are you sure you want to delete?", OkButtonTitle: "Yes", CancelButtonTitle: "No") {
                    let card_id = self.profileDetails?.vehicleDetail?[indexPath.row].vehicle_detail_id ?? ""
                  
                    let param = ["vehicle_detail_id": card_id  , "status" :  "3"] as [String : Any]
                    print(param)
                    
                    Indicator.shared.showProgressView(self.view)
                    self.conn.startConnectionWithPostType(getUrlString: "update_vehicle_status", params: param,authRequired: true) { (Value) in
                        Indicator.shared.hideProgressView()
                        if self.conn.responseCode == 1{
                            let msg = (Value["message"] as? String ?? "")
                            if (Value["status"] as? Int ?? 0) == 1{
                                self.getProfileDataApi()
                               
                                self.showToast(message: "\(msg)")
                            }else{
                                self.showAlert("Driver RideshareRates", message: msg)
                            }
                        }
                    }
                    
                }
            }
            return cell
    }
    
    @objc func checkBoxBtn(_ sender: UIButton) {
        checkBtnStatus = true
        kProfileInputStatus = true
        self.selectedIndex = sender.tag
        activeInactiveVehicleApi(vehicleId: self.profileDetails?.vehicleDetail?[sender.tag].vehicle_detail_id ?? "", activeInactiveStatus: "1")
        profileTableView.reloadData()
    }
}
//MARK:- Table View Delegate
//extension ProfileViewController: UITableViewDelegate{
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//      return 200
//    }
//}
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        tblHeightConstraint.constant = profileTableView.contentSize.height
//
//    }
//}
extension ProfileViewController : UserDetailsTableViewCellDelegate {
    func inputEdit(flag: Bool, with name: String?, phone: String?, for cell: UserDetailsTableViewCell) {
        if flag == true {
            kProfileInputStatus = true
            kProfileName = name ?? ""
            kProfileEditMobile = phone ?? ""
        }
    }
}
