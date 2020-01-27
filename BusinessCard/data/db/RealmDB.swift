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
    
    func findUser() -> UserObject? {
        let realm = try! Realm()
        var objects:[UserObject] = []
        autoreleasepool {
            let objectList = realm.objects(UserObject.self)
            for object in objectList {
                objects.append(object)
            }
        }
        
        return objects.count > 0 ? objects[0] : nil
    }
    
    func saveInfo(info: Information) {
        let realm = try! Realm()
        
        let infoObject: InformationObject = InformationObject()
        infoObject.id = info.id
        infoObject.name1 = info.name1
        infoObject.name2 = info.name2
        infoObject.company = info.company
        infoObject.department = info.department
        infoObject.postal = info.postal
        infoObject.address1 = info.address1
        infoObject.address2 = info.address2
        infoObject.longitude = info.longitude!
        infoObject.latitude = info.latitude!
        infoObject.image = info.image!
        
        autoreleasepool {
            try! realm.write {
                realm.add(infoObject, update: Realm.UpdatePolicy.modified)
                
                let objects = realm.objects(InformationObject.self)
                print(objects)
            }
        }
    }
    
    func saveInfo(infos: [Information]) {
        let realm = try! Realm()
        var objects:[InformationObject] = []
        for info in infos {
            objects.append(dataMapObject(info: info))
        }
        
        autoreleasepool {
            try! realm.write {
                
                realm.add(objects, update: Realm.UpdatePolicy.modified)
                
                let objectss = realm.objects(InformationObject.self)
                print(objectss)
            }
        }
    }
    
    func dataMapObject(info: Information) -> InformationObject {
        let infoObject: InformationObject = InformationObject()
        infoObject.id = info.id
        infoObject.name1 = info.name1
        infoObject.name2 = info.name2
        infoObject.company = info.company
        infoObject.department = info.department
        infoObject.postal = info.postal
        infoObject.address1 = info.address1
        infoObject.address2 = info.address2
        infoObject.longitude = info.longitude!
        infoObject.latitude = info.latitude!
        infoObject.image = info.image == nil ? "" : info.image!
        
        return infoObject
    }
}
