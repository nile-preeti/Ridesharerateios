//
//  Singleton.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import Foundation
import UIKit

class Singleton {
    
    static var shared: Singleton? = Singleton()
    
    private init() {
        
    }
    
    deinit {
        print(#file , " Destructed")
    }
    let title = "Driver RideshareRates"
    var customerData : userCustomerModal?
    
}

