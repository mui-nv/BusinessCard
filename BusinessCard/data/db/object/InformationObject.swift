//
//  Infomation.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import Foundation
import RealmSwift

class InformationObject:Object {
    @objc var id: Int = 100
    @objc var name1: String = ""
    @objc var name2: String = ""
    @objc var company: String = ""
    @objc var department: String = ""
    @objc var postal: String = ""
    @objc var address1: String = ""
    @objc var address2: String = ""
    @objc var latitude: Double = 0.0
    @objc var longitude: Double = 0.0
    @objc var image: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
