//
//  AcceptedReqDM.swift
//  Driver RideshareRates
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
    let tip_amount : String?
    let status: String?
    let paymentStatus, payDriver, paymentMode : String?
    
    let amount: String?
    let time, userMobile: String?
    let userAvatar: String?
    let driverAvatar: String?
    let userName, user_lastname: String?
    let driverMobile, driverName: String?
    let vehicleTypeName: String?
    let question_category: String?
    let question: String?
    let email : String?
    let month : String?
    let id: String?

    let audio: [Audio]?
    
  //  let amount : Double?
   
    
//    audio =             (
//                        {
//            audio = 
//    )
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case question = "question"
        case email = "email"

        case user_lastname = "user_lastname"
        case tip_amount = "tip_amount"
        case question_category = "question_category"
        case rideID = "ride_id"
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
        case amount = "amount", time
        case userMobile = "user_mobile"
        case userAvatar = "user_avatar"
        case driverAvatar = "driver_avatar"
        case userName = "user_name"
        case driverMobile = "driver_mobile"
        case driverName = "driver_name"
        case vehicleTypeName = "vehicle_type_name"
        case month = "month"
        case audio
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)

        self.user_lastname = try container.decodeIfPresent(String.self, forKey: .user_lastname)
        self.question = try container.decodeIfPresent(String.self, forKey: .question)
        self.tip_amount = try container.decodeIfPresent(String.self, forKey: .tip_amount)
        self.question_category = try container.decodeIfPresent(String.self, forKey: .question_category)
        self.rideID = try container.decodeIfPresent(String.self, forKey: .rideID)
        self.userID = try container.decodeIfPresent(String.self, forKey: .userID)
        self.driverID = try container.decodeIfPresent(String.self, forKey: .driverID)
        self.pickupAdress = try container.decodeIfPresent(String.self, forKey: .pickupAdress)
        self.dropAddress = try container.decodeIfPresent(String.self, forKey: .dropAddress)
        self.pikupLocation = try container.decodeIfPresent(String.self, forKey: .pikupLocation)
        self.pickupLat = try container.decodeIfPresent(String.self, forKey: .pickupLat)
        self.pickupLong = try container.decodeIfPresent(String.self, forKey: .pickupLong)
        self.dropLocatoin = try container.decodeIfPresent(String.self, forKey: .dropLocatoin)
        self.dropLat = try container.decodeIfPresent(String.self, forKey: .dropLat)
        self.dropLong = try container.decodeIfPresent(String.self, forKey: .dropLong)
        self.distance = try container.decodeIfPresent(String.self, forKey: .distance)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.paymentStatus = try container.decodeIfPresent(String.self, forKey: .paymentStatus)
        self.payDriver = try container.decodeIfPresent(String.self, forKey: .payDriver)
        self.paymentMode = try container.decodeIfPresent(String.self, forKey: .paymentMode)
        self.amount = try container.decodeIfPresent(String.self, forKey: .amount)
        self.time = try container.decodeIfPresent(String.self, forKey: .time)
        self.userMobile = try container.decodeIfPresent(String.self, forKey: .userMobile)
        self.userAvatar = try container.decodeIfPresent(String.self, forKey: .userAvatar)
        self.driverAvatar = try container.decodeIfPresent(String.self, forKey: .driverAvatar)
        self.userName = try container.decodeIfPresent(String.self, forKey: .userName)
        self.driverMobile = try container.decodeIfPresent(String.self, forKey: .driverMobile)
        self.driverName = try container.decodeIfPresent(String.self, forKey: .driverName)
        self.vehicleTypeName = try container.decodeIfPresent(String.self, forKey: .vehicleTypeName)
        self.month = try container.decodeIfPresent(String.self, forKey: .month)
        self.audio = try container.decodeIfPresent([Audio].self, forKey: .audio)
    }
}

typealias rides = [RidesData]

//MARK:- Completed Rides

struct CompletedRidesData: Codable {
    let rideID, userID,email, driverID, pickupAdress: String?
    let dropAddress, pikupLocation, pickupLat, pickupLong: String?
    let short_drop_address , short_pick_address : String?
    let dropLocatoin, dropLat, dropLong, distance: String?
    let tip_amount : String?
    let status: String?
    let paymentStatus, payDriver, paymentMode, amount: String?
    let time, userMobile: String?
    let total_waiting_time, total_waiting_charge : String?
    let userAvatar: String?
    let driverAvatar: String?
    let userName: String?
    let user_lastname : String?
    let driverMobile: String?
    let driverName: String?
    let vehicleTypeName: String?
    let audio: [Audio]?
    let document_name: String?
    let id: String?
    enum CodingKeys: String, CodingKey{
        case rideID = "ride_id"
        case email = "email"
        case userID = "user_id"
        case driverID = "driver_id"
        case total_waiting_charge = "total_waiting_charge"
        case total_waiting_time = "total_waiting_time"
        case short_drop_address = "short_drop_address"
        case short_pick_address = "short_pick_address"
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
        case user_lastname = "user_lastname"
        case driverMobile = "driver_mobile"
        case driverName = "driver_name"
        case vehicleTypeName = "vehicle_type_name"
        case document_name = "document_name"
        case id = "id"
        case tip_amount = "tip_amount"
        case audio
    }
}

// MARK: - Audio
struct Audio: Codable {
    let audio: String?
}

typealias completed = [CompletedRidesData]


//MARK:- Profile Data Model

struct ProfileData: Codable {
    
    let user_id : String?
    let account_holder_name : String?
    let account_number : String?
    let name : String?
    let last_name : String?
    let name_title : String?
    let email : String?
    let mobile : String?
    let identification_issue_date : String?
    let identification_expiry_date : String?
    let verification_id : String?
    let identification_document_id : String?
    let identification_document_name : String?
    let country : String?
    let country_code : String?
    let total_rating : String?

    let state : String?
    let city : String?
    let profile_pic : String?
    let profile_image : String?
    let vehicleDetail: [VehicleDetail]?
    
    let license_expiry : Bool?
    let insurance_expiry : Bool?
    let car_expiry : Bool?
    let status : String?

    let driver_rest_time : Int?
    let change_vehicle : Int?
    let identification_expiry : Int?

    
    enum CodingKeys: String, CodingKey {
        
        case user_id = "user_id"
        case name_title = "name_title"
        case account_number = "account_number"
        case account_holder_name = "account_holder_name"
        case name = "name"
        case last_name = "last_name"
        case email = "email"
        case mobile = "mobile"
        case country = "country"
        case state = "state"
        case city = "city"
        case country_code = "country_code"
        case total_rating = "total_rating"
        case identification_document_name = "identification_document_name"

        case profile_pic = "profile_pic"
        case profile_image = "profile_image"
        case vehicleDetail = "vehicle_detail"
        case status = "status"
        case license_expiry = "license_expiry"
        case insurance_expiry = "insurance_expiry"
        case car_expiry = "car_expiry"
        case driver_rest_time = "driver_rest_time"
        case change_vehicle = "change_vehicle"
        case identification_expiry = "identification_expiry"

        case verification_id = "verification_id"
        case identification_document_id = "identification_document_id"

        case identification_issue_date = "identification_issue_date"
        case identification_expiry_date = "identification_expiry_date"

        
    }
}
typealias userProfileModal = [ProfileData]

// MARK: - VehicleDetail
struct VehicleDetail: Codable {
    let vehicle_detail_id : String?
    let model_name : String?
    let brand_name : String?
    
    let model_id : String?
    let brand_id : String?
    let year : String?
    let color : String?
    let vehicle_no : String?
    let vehicle_type : String?
    let vehicle_type_id : String?
    let status : String?
    let seat_no : String?
    let premium_facility : String?
    let license : String?
    let insurance : String?
    let permit : String?
    let car_pic : String?
    let car_registration : String?
    let subcat_id : String?
    let subcat_title : String?
  //  let car_registration : String?
    let car_expiry_date : String?
    let car_issue_date : String?
    let inspection_issue_date : String?
    let inspection_expiry_date : String?
    let insurance_expiry_date : String?
    let insurance_issue_date : String?
    let license_expiry_date : String?
    let license_issue_date : String?
    let inspection_document : String?
    let insurance_doc : String?
    let license_doc : String?
    let car_registration_doc : String?
    
    
    
    enum CodingKeys: String, CodingKey {
        case subcat_id = "subcat_id"
        case subcat_title = "subcat_title"
        case vehicle_detail_id = "vehicle_detail_id"
        case model_name = "model_name"
        case brand_name = "title"
        case model_id = "model_id"
        case brand_id = "brand_id"
        case year = "year"
        case color = "color"
        case vehicle_no = "vehicle_no"
        case vehicle_type = "vehicle_type"
        case vehicle_type_id = "vehicle_type_id"
        case status = "status"
        case seat_no = "seat_no"
        case license = "license"
        case insurance = "insurance"
        case permit = "permit"
        case car_pic = "car_pic"
        case car_registration = "car_registration"
        case car_expiry_date = "car_expiry_date"
        case car_issue_date = "car_issue_date"
        case inspection_issue_date = "inspection_issue_date"
        case inspection_expiry_date = "inspection_expiry_date"
        case insurance_expiry_date = "insurance_expiry_date"
        case insurance_issue_date = "insurance_issue_date"
        case license_expiry_date = "license_expiry_date"
        case license_issue_date = "license_issue_date"
        case inspection_document = "inspection_document"
        case insurance_doc = "insurance_doc"
        case license_doc = "license_doc"
        case car_registration_doc = "car_registration_doc"
        case premium_facility = "premium_facility"

        
        
    }
}

// MARK: - Get Brands
struct BrandDetails: Codable {
    let id, brandName, status, createdDate: String?
    let updatedDate: String?
    let year : [String]?
    let Subcategory : [VehicleDetail]?
   
    enum CodingKeys: String, CodingKey {
        case id
        case Subcategory = "Subcategory"
       
        case year = "year"
        case brandName = "title"
        case status
        case createdDate = "created_date"
        case updatedDate = "updated_date"
    }
}

typealias brand = [BrandDetails]

// MARK: - Model Data
struct ModelDetails: Codable {
    let id, brandID, modelName,seat, status,category_year: String?
    let createdDate, updatedDate: String?
    

    enum CodingKeys: String, CodingKey {
        case id
        case seat = "seat"
        case category_year = "category_year"
        case brandID = "brand_id"
        case modelName = "model_name"
        
        case status
        case createdDate = "created_date"
        case updatedDate = "updated_date"
    }
}

typealias model = [ModelDetails]


// MARK: - Model Data
struct vehicleDetail: Codable {
    let title,id,rate,car_pic,short_description: String?
}
typealias vehicleType = [vehicleDetail]



func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
