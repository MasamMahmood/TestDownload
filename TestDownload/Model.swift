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

struct AppointmentDetail : Codable {
    
    let projectId : Int?
    let address : String?
    let appointmentDate : String?
    let appointmentType : String?
    let appointmentId : Int?
    let buildingCode : String?
    let projectName : String?
    let projectNo : String?
    let projectType : String?
    let sectionList : [SectionList]?
    let isSuccess : Bool?
    let message : String?
    let statusCode : Int?
    
}

struct SectionList : Codable {
    
    let title : String?
    var items : [Item]?
    var modified: Bool? = false
}

struct Item : Codable {
    
    let actionType : Int?
    let actionUrl : String?
    let bgColor : String?
    let booleanValue : Bool?
    var textField : String?
    var textValue : String?
    let unitId : Int?
    let latitude : Double?
    let longitude : Double?
    let actionParamData: String?
    let actionTitle: String?
    let pickList: [SectionList]?
    var selection: [Item]?
    let multiSelect: Bool?
    let selectedValue: [String]?
    let version: Int?
    let masterId: Int?
    let actionId: Int?
    let itemValue: String?
    var required: Bool? = false
}

