//
//  GlobalVariables.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//


import Foundation
let kis_card = "is_card"
let accessToken = "token"
let kDeviceToken = "fcmToken"
let kFcmToken = "fcmToken"
let kUserID = "userID"
let kVideoPlay = ""
let kUserLogin = "isUserLoggedIn"
let kUpdateDriveStatus = "updateDriveStatus"
let kEmail = "email"
let kName = "name"
let kProfilePic = "profilePic"
let kCurrentLat = "latitude"
let kCurrentAddress = ""
let kpCurrentAdd = "kpCurrentAdd"
let kdroploc = "kdroploc"
let kCurrentLong = "longitude"
var kNotificationAction = ""
var kConfirmationAction = ""
let kFeedBack = "FeedBack"
let NSUSERDEFAULT = UserDefaults.standard
var kConfirmationStatus = ""
var kCustomerMobile = "1234567890"
var kCurrentLocaLatLongTap = ""
var kDestinationLatLongTap = ""
var kDropAddress = ""
var kCurrentLocaLatLong = ""
var kDestinationLatLong = ""
var kRideStatus = ""
var kpickupAddress = ""
var kPickLat =  ""
var kPickLatTap =  ""
var kPickLong =  ""
var kPickLongTap =  ""
var kCurrentAddressMarker = ""
var kDropAddressMarker = ""
var kDropLat =  ""
var kDropLong =  ""
var kstoplat = ""
var kstoplong = ""
var kCurrentLocaLat = ""
var kCurrentLocaLong = ""
var kDistanceInMiles = ""
var kFinalAmountMile = ""
var vehicleTypeId = ""
var cardID = ""
var holdAmount = ""
var txnID = ""
var rideAmount = ""
var kTotalRideAmountPerKmInt = ""
var kRating = ""
var kCommentRating = ""
let kdriverName = "driverName"
let kdriverTime = "driverTime"
let kdriverDistance = "driverDistance"
let kdriverRating = "driverRating"
let kdriverAmountPay = "driverAmountPay"
var kRideId = ""
var kVehicle_no = ""
var kDriverId = ""
var kCardId = ""
var kProfileEditMobile = ""
let kPassword = "password"
var kPickUpLatFinal = ""
var kPickUpLongFinal = ""
var kPaymentRideId = ""
var kPaymentDriverName = ""
var kPaymentRideAmount = ""
var kstops = [""]


enum driverConfirmStatus {
    case notConfirmed
}
enum comeFrom {
    case CompletedRequest
    case AddCard
}
enum paymentType {
    case withCard
    case withoutCard
}
enum chooseRideList {
    case hide
    case show
}

var kProfileInputStatus = false
var kProfileName = ""
var kProfileMobile = ""
var kProfileImageUpdateStatus = false
var kProfileDOCImageUpdateStatus = false
