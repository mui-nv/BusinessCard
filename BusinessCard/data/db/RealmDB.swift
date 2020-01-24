//
//  RealmDB.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDB {
    
    func saveUser(user: CreateUserResponse) {
        let realm = try! Realm()
        
        let userObject: UserObject = UserObject()
        userObject.userID = user.id
        userObject.user = user.user
        userObject.password = user.password
        
        autoreleasepool {
            try! realm.write {
                realm.add(userObject, update: Realm.UpdatePolicy.modified)
                
                let objects = realm.objects(UserObject.self)
//                print(objects)
            }
        }
    }
}
