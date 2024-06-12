//
//  VechileDM.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//


import Foundation
// MARK: - WelcomeElement
struct VechileData: Codable {
    let id, title, rate, shortDescription: String?
    let vehicle_id : String?
    let hold_amount : String?
    let category_name :String?
    let carPic,totalAmount : String?
    let vehicle_image : String?
    let vehicles : [VechileData]?
    let vhicle_name : String?

    enum CodingKeys: String, CodingKey {
        case id, title, rate
        case hold_amount = "hold_amount"
        case vehicle_id = "vehicle_id"
        case vehicle_image = "vehicle_image"
        case category_name = "category_name"
        case vhicle_name = "vehicle_name"
        case shortDescription = "short_description"
        case carPic = "car_pic"
        case totalAmount = "total_amount"
        case vehicles = "vehicles"
    }
}

typealias vechile = [VechileData]
