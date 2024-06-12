//
//  GlobalVariables.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import Foundation
let accessToken = "token"
let kDeviceToken = "gcmToken"
let kPassword = "password"
let kUserID = "userID"
let kUserLogin = "isUserLoggedIn"
let kUpdateDriveStatus = "updateDriveStatus"
let checknotifi = "checknotifi"
var kRating = ""
let kEmail = "email"
let kName = "name"
let ktotal_rating = "total_rating"
let Ktimer = "Ktimer"
let KOnOffStatus = "KOnOffStatus"

let kProfilePic = "profilePic"
let NSUSERDEFAULT = UserDefaults.standard
let kCurrentLat = "latitude"
let kCurrentLong = "longitude"
let kFcmToken = "fcmToken"
var kNotificationAction = ""
var kConfirmationAction = ""
var kRideId = ""
var kFromAddress = ""
var kToAddress = ""
var kTotalDistance = ""
var kTotalFare = ""
var kRideBookingDataStatus = "rideBookingDataStatus"
var kConfirmationStatus = ""
var kCustomerMobile = ""
var kDistanceInMiles = ""
var kRidername = ""
var kCurrentLocaLatLong = ""
var kDestinationLatLong = ""
let kPickLat =  ""
let kPickLong =  ""
let kDropLat =  ""
let kDropLong =  ""
var kCurrentLocaLat = ""
var kCurrentLocaLong = ""
var DcurrentLocation = ""
var kPickAddress =  ""
var kDropAddress =  ""
var kIsComeFromSignup = "online"
var kFromDate = ""
var kToDate = ""
var kSelectedStatus = ""
let kAccountHolderName = "account_holder_name"
let kAccountNumber = "account_number"
let kBankName = "bank_name"
let kRoutingNumber = "routing_number"
var kRequestStatus = ""

enum acceptReject {
    case acceptStatus
    case rejettStatus
    case completedStatus
    case startRideStatus
    case cancelStatus
    case pendingStatus
}
var kProfileInputStatus = false
var kProfileName = ""
var kProfileMobile = ""
var kProfileEditMobile = ""
var kProfileImageUpdateStatus = false

enum onOff {
    case online
    case offline
}
enum isComeFrom {
    case signUp
}
enum pickDate : String {
    case fromDate =  "fromDte"
    case toDate = "toDte"
}
enum selectServices {
    case isSelected
    case isNotSelected
}
