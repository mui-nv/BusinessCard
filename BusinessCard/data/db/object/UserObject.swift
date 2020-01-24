//
//  User.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import Foundation
import RealmSwift

class UserObject: Object {
    @objc var userID: Int = 100
    @objc var user: String? = ""
    @objc var password: String? = ""
    
    override static func primaryKey() -> String? {
        return "userID"
    }
}
