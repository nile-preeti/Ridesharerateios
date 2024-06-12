//
//  AcceptedReqDM.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//

import Foundation
import UIKit
// MARK: - WelcomeElement
struct RidesData: Codable {
    let rideID, userID: String?
    let driverID: String?
    let pickupAdress: String?
    let dropAddress: String?
    let pikupLocation, pickupLat, pickupLong: String?
    let dropLocatoin: String?
    let dropLat, dropLong, distance: String?
    let status: String?
    let paymentStatus, payDriver, paymentMode, amount: String?
    let trip_fare, subtotal, booking_fee, cancellation_charge, tax_charge : String?
    let time, userMobile: String?
    let userAvatar: String?
    let driverAvatar: String?
    let userName: String?
    let driverMobile, driverName,driver_lastname, vehicle_name, category_name: String?
    let vehicleTypeName: String?
    let audio: [Audio]?
    let document_name: String?
    let id: String?
    let question: String?
    let total_waiting_time : String?
    let total_waiting_charge : String?

    let email : String?
    enum CodingKeys: String, CodingKey {
        case rideID = "ride_id"
        case total_waiting_time = "total_waiting_time"
        case total_waiting_charge = "total_waiting_charge"
        case email = "email"
        case driver_lastname = "driver_lastname"
        case vehicle_name = "vehicle_name"
        case category_name = "category_name"
        case trip_fare = "trip_fare"
        case cancellation_charge = "cancellation_charge"
        case subtotal = "subtotal"
        case booking_fee = "booking_fee"
        case tax_charge = "tax_charge"
        case question = "question"
        case userID = "user_id"
        case driverID = "driver_id"
        case pickupAdress = "pickup_adress"
        case dropAddress = "drop_address"
        case pikupLocation = "pikup_location"
        case pickupLat = "pickup_lat"
        case pickupLong = "pickup_long"
        case dropLocatoin = "drop_locatoin"
        case dropLat = "drop_lat"
        case dropLong = "drop_long"
        case distance, status
        case paymentStatus = "payment_status"
        case payDriver = "pay_driver"
        case paymentMode = "payment_mode"
        case amount, time
        case userMobile = "user_mobile"
        case userAvatar = "user_avatar"
        case driverAvatar = "driver_avatar"
        case userName = "user_name"
        case driverMobile = "driver_mobile"
        case driverName = "driver_name"
        case document_name = "document_name"
        case id = "id"
        case vehicleTypeName = "vehicle_type_name"
        case audio
    }
}
// MARK: - Audio
struct Audio: Codable {
    let audio: String?
}
//enum Drop: String, Codable {
//    case noidaSector18NoidaUttarPradesh201301India = "Noida Sector 18, Noida, Uttar Pradesh 201301, India"
//    case rampurUttarPradesh244901India = "Rampur, Uttar Pradesh 244901, India"
//    case saiyadrajaUttarPradesh232110India = "Saiyadraja, Uttar Pradesh 232110, India"
//}
//
//enum Status: String, Codable {
//    case accepted = "ACCEPTED"
//    case startRide = "START_RIDE"
//}
//
//enum UserAvatar: String, Codable {
//}
//
//enum UserName: String, Codable {
//    case vibhutiUser = "Vibhuti User"
//}

typealias rides = [RidesData]
