//
//  UploadDocTableViewCell.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit

class UploadDocTableViewCell: UITableViewCell {

    //MARK:- OUTLETS
    
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var uploadBtn: UIButton!
    
    
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
