//
//  PaymentHistoryModal.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import Foundation

struct PaymentHistoryModal : Codable {
    let ride_id : String?
    let user_id : String?
    let driver_id : String?
    let vehicle_type_id : String?
    let pickup_adress : String?
    let drop_address : String?
    let user_lastname : String?
    let pikup_location : String?
    let pickup_lat : String?
    let pickup_long : String?
    let drop_locatoin : String?
    let drop_lat : String?
    let drop_long : String?
    let distance : String?
    let status : String?
    let cancelled_by : String?
    let cancelled_count : String?
    let payment_status : String?
    let pay_driver : String?
    let payment_mode : String?
    let amount : String?
    let time : String?
    let tip_amount : String?
    let user_mobile : String?
    let user_avatar : String?
    let driver_avatar : String?
    let user_name : String?
    let driver_mobile : String?
    let driver_name : String?
    let vehicle_type_name : String?
    let txn_id : String?
    let date : String?
    let payout_amount : String?
    let payout_status : String?

    enum CodingKeys: String, CodingKey {

        case ride_id = "ride_id"
        case user_id = "user_id"
        case user_lastname = "user_lastname"
        case driver_id = "driver_id"
        case vehicle_type_id = "vehicle_type_id"
        case pickup_adress = "pickup_adress"
        case drop_address = "drop_address"
        case pikup_location = "pikup_location"
        case pickup_lat = "pickup_lat"
        case pickup_long = "pickup_long"
        case drop_locatoin = "drop_locatoin"
        case drop_lat = "drop_lat"
        case drop_long = "drop_long"
        case distance = "distance"
        case status = "status"
        case cancelled_by = "cancelled_by"
        case cancelled_count = "cancelled_count"
        case payment_status = "payment_status"
        case pay_driver = "pay_driver"
        case payment_mode = "payment_mode"
        case amount = "amount"
        case time = "time"
        case user_mobile = "user_mobile"
        case user_avatar = "user_avatar"
        case driver_avatar = "driver_avatar"
        case user_name = "user_name"
        case driver_mobile = "driver_mobile"
        case driver_name = "driver_name"
        case vehicle_type_name = "vehicle_type_name"
        case txn_id = "txn_id"
        case date = "date"
        case payout_amount = "payout_amount"
        case payout_status = "payout_status"
        case tip_amount = "tip_amount"
    }
}
typealias userPaymentHistoryModal = [PaymentHistoryModal]
