//
//  NoPasteTextField.swift
//  Driver RideshareRates
//
//  Created by malika on 05/01/24.
//

import Foundation
import UIKit

class NoPasteTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override func target(forAction action: Selector, withSender sender: Any?) -> Any? {
        return nil
    }
}
