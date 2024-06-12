//
//  ButtonTableViewCell.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    //MARK:- OUTLETS
    
    @IBOutlet weak var addVechile_btn: SetButton!
    @IBOutlet weak var update_btn: SetButton!
    @IBOutlet weak var changePass_btn: SetButton!
    
    
    //MARK:- Default Func
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
