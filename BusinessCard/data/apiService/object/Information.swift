//
//  Information.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import Foundation

class Information: Codable {
    var id: Int = 100
    var userID: Int?
    var name1: String = ""
    var name2: String = ""
    var company: String = ""
    var department: String = ""
    var postal: String = ""
    var address1: String = ""
    var address2: String = ""
    var latitude: Double?
    var longitude: Double?
    var image: String?
}
