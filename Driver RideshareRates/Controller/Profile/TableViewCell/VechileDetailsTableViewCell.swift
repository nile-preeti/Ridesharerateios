//
//  VechileDetailsTableViewCell.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit

class VechileDetailsTableViewCell: UITableViewCell {

    //MARK:- OUTLETS
    @IBOutlet weak var modelName_lbl: UILabel!
   // @IBOutlet weak var brandType_lbl: UILabel!
    @IBOutlet weak var vechileType_lbl: UILabel!
    @IBOutlet weak var color_lbl: UILabel!
    @IBOutlet weak var year_lbl: UILabel!
    @IBOutlet weak var vechileNo_lbl: UILabel!
    @IBOutlet weak var tick_btn: SetButton!
    @IBOutlet weak var edit_btn: SetButton!
    @IBOutlet weak var delete_btn: UIButton!
    @IBOutlet weak var seatNo_lbl: UILabel!
    
    @IBOutlet weak var carInsurance: SetImageView!
    var callBackDropDown : ((IndexPath) -> Void)?
    var callCheckBox : ((IndexPath) -> Void)?
    var index = IndexPath()
    //MARK:- Default Func
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func actionDropDown(_ sender: Any) {
          callBackDropDown?(self.index)
      }
    @IBAction func checkBoxBtnAction(_ sender: Any) {
        callCheckBox?(self.index)
      }
    func configure(indexPath:IndexPath){
          self.index = indexPath
      }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
