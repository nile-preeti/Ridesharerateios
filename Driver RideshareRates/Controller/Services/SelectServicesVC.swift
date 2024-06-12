//
//  SelectServicesVC.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit

class SelectServicesVC: UITableViewCell {
    //MARK:- OUTLETS
    @IBOutlet weak var modelName_lbl: UILabel!
    @IBOutlet weak var vechileType_lbl: UILabel!
    @IBOutlet weak var vechileNo_lbl: UILabel!
    @IBOutlet weak var tick_btn: UIButton!
    var callCheckBox : ((IndexPath) -> Void)?
    var index = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func checkBoxBtnAction(_ sender: Any) {
        callCheckBox?(self.index)
      }
    func configure(indexPath:IndexPath){
          self.index = indexPath
      }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        if selected{
//            tick_btn.setImage(UIImage(named: "check"), for: .normal)
//        }else{
//            tick_btn.setImage(UIImage(named: "uncheck"), for: .normal)
//        }
    }
}
