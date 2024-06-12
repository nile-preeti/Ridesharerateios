//
//  HomeSectionsTableViewCell.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//


import UIKit

class HomeSectionsTableViewCell: UITableViewCell {

    @IBOutlet var mRate: UILabel!
    @IBOutlet var carImageView: UIImageView!
    @IBOutlet var mLBL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with text: String) {
        mLBL.text = text
        }
}
