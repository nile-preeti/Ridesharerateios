//
//  SearchTableViewCell.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    //MARK:- OUTLETS
    
    @IBOutlet weak var locationName_lbl: UILabel!
    @IBOutlet weak var countryName_lbl: UILabel!
    
    
    
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
