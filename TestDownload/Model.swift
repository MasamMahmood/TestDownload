//
//  Model.swift
//  TestDownload
//
//  Created by Masam Mahmood on 23.01.2020.
//  Copyright © 2020 Masam Mahmood. All rights reserved.
//

import Foundation

struct ResponseData: Codable {
    
    let appointments : [Appointment]?
    let isSuccess : Bool?
    let statusCode : Int?
    let message : String?
    let reasons : [String]?

}

struct Appointment : Codable {
    
    let appointmentHour : String?
    let backgroundColorDark : String?
    let backgroundColorLight : String?
    let controlHour : String?
    let date : String?
    let id : Int?
    let isProjectManual : Bool?
    let projectDistrict : String?
    let projectFirmName : String?
    let projectName : String?
    let projectType : String?
    let subTitle : String?
    let warmingType : String?
}
