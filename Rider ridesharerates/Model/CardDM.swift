//
//  CardDM.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//


import Foundation
// MARK: - WelcomeElement


struct cardDataModal: Codable {
    var card_type, card_number, card_holder_name, bank_name,customer_id,expiry_date,expiry_month,id: String?
    let is_default : String?
}
typealias userCardData = [cardDataModal]



