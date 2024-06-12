//
//  customtbl.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import Foundation
import UIKit



class SelfSizingTableView: UITableView {
    var maxHeight = CGFloat.infinity

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    override var intrinsicContentSize: CGSize {
        let height = min(maxHeight, contentSize.height)
        return CGSize(width: contentSize.width, height: height)
    }
}
