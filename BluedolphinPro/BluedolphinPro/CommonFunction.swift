//
//  CommonFunction.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 29/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation

enum ErrorMessage:String{
    case UserNotFound = "User not found with that phone number in system,Please contact your administrator"
    case InternalServer = "We are facing some internal issue please try again after sometime"
    case NotValidData = "Input you send is not valid"
    case FECodeError = "Please enter the mobile number"
    case NetError = "Could not connect to internet please try again."
    case InvalidFECode = "Please enter valid mobile  number"
    case InvalidOtp = "Please enter valid otpcode"
}
