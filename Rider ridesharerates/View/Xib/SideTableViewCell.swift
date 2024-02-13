//
//  SideTableViewCell.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//

import UIKit

class SideTableViewCell: UITableViewCell {

    //MARK:- OUTLETS
    
    @IBOutlet weak var side_icon: UIImageView!
    @IBOutlet weak var sideName_lbl: UILabel!
    
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
