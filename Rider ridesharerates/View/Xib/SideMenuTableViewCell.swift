//
//  SideMenuTableViewCell.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    //MARK:- OUTLETS
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var vechileName_lbl: UILabel!
    @IBOutlet weak var description_lbl: UILabel!
    @IBOutlet weak var amount_lbl: UILabel!
    
    
    //MARK:- Default Func
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //MARK:- Default Func
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
