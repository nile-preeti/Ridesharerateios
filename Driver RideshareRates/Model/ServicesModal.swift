//
//  ServicesModal.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import Foundation
struct ServicesModel : Codable {
    let id : String?
    let category_title : String?
    let status : String?
    let title : String?
    let service_id : String?

    let vehicle_type : String?
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case category_title = "category_title"
        case status = "status"
        case title = "title"
        case vehicle_type = "vehicle_type"
        case service_id = "service_id"
        
    }
}
typealias selectServicesModal = [ServicesModel]
