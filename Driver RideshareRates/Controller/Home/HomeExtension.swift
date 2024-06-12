//
//  HomeExtension.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit

extension HomeViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.section.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if (self.servicesData.count ) == 0 {
                tableView.setEmptyMessage("No Data Found.")
            } else {
                tableView.removeErrorMessage()
            }
            return self.servicesData.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 40.0
        }
        else{
            return 50.0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("total COunt\(self.servicesData.count)")
            switch indexPath.section {
            case 0:
                let model =  servicesData[indexPath.row]
                 let cell = tableView.dequeueReusableCell(withIdentifier: "SelectServicesVC") as! SelectServicesVC
                 cell.vechileType_lbl.text =  "\(model.category_title ?? "") (\(model.vehicle_type ?? ""))"
                 cell.tick_btn.tag = indexPath.row
                 let status = model.status ?? ""
                 let statusID = model.service_id ?? ""
                 let id : Int = Int(model.service_id ?? "") ?? 0
                cell.tick_btn.tag = indexPath.row
                cell.tick_btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                 if status == "1"{
                     cell.tick_btn.setImage(UIImage(named: "check"), for: .normal)
                    arrSelectedRowsNew.append(id)
                    cell.tick_btn.isSelected = true
                 }else{
                     cell.tick_btn.setImage(UIImage(named: "uncheck"), for: .normal)
                     arrnotSelectedRowsNew.append(id)
                     cell.tick_btn.isSelected = false
                 }
                 return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitServicesCell") as! SubmitServicesCell
                cell.submitBtn.addTarget(self, action: #selector(sumbitServiceBtnAction), for: .touchUpInside)
                cell.submitBtn.tag = indexPath.row
                cell.mCancelBTN.addTarget(self, action: #selector(mCancelBtnAction), for: .touchUpInside)
                cell.mCancelBTN.tag = indexPath.row
                return cell
              
            default:
                return UITableViewCell()
            }
    }
    
      @objc func mCancelBtnAction( _ sender : UIButton){
          ServicesView.isHidden = true
    }
    @objc func buttonTapped(_ sender: UIButton){
        let model =  servicesData[sender.tag]
        let id : Int = Int(model.service_id ?? "") ?? 0
        if sender.isSelected == true {
            sender.isSelected = false
            sender.setImage(UIImage(named: "uncheck"), for: .normal)
           // arrSelectedRowsNew.remove(at: id)
            arrnotSelectedRowsNew.append(id)
            guard let index = arrSelectedRowsNew.firstIndex(of: id) else { return }
            arrSelectedRowsNew.remove(at: index)
        }else {
            sender.isSelected = true
            sender.setImage(UIImage(named: "check"), for: .normal)
            
            guard let index = arrnotSelectedRowsNew.firstIndex(of: id) else { return }
            arrnotSelectedRowsNew.remove(at: index)
            
            arrSelectedRowsNew.append(id)
        }
    }
    
      @objc func sumbitServiceBtnAction( _ sender : UIButton){
          
          NSUSERDEFAULT.set("no", forKey: checknotifi)
        print(arrSelectedRowsNew)
        if arrSelectedRowsNew.count !=  0 {
            self.addSelectedServicesApi()
        }
        else{
            self.showAlert("Driver RideshareRates", message: "Please select the services")
        }
    }
}
