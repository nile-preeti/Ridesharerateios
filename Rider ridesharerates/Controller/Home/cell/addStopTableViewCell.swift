//
//  addStopTableViewCell.swift
//  Rider ridesharerates
//
//  Created by malika on 22/05/24.
//

import UIKit

class addStopTableViewCell: UITableViewCell {

    @IBOutlet var indexlblBTN : UIButton!
    @IBOutlet var crossbtn : UIButton!
    @IBOutlet var stoptextvie: UITextField!
    
    func configure(with data: CellData) {
            // Configure the cell with data if needed
        }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
