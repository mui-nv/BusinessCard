//
//  UserRepository.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import Foundation

class UserRepository: BaseRepository {
    let apiService = ApiService()
    let realmDB = RealmDB()
    
    func createUser(data: CreateUserParam, createSuccess: (CreateUserResponse?) -> (), createError: (String) -> ()) {
        let requestUrl = ApiService.baseUrl + ApiService.createUserUrl
        apiService.createUser(url: requestUrl, data: data, createSuccess: createSuccess, createError: createError)
    }
    
    func selectUser(data: CreateUserParam, selectSuccess: (CreateUserResponse?) -> (), selectError: (String) -> ()) {
        let requestUrl = ApiService.baseUrl + ApiService.selectUserUrl
        
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        
        let userData = try! encoder.encode(data)
        let stringData = "{\"param\":\"" + encodeString(data: Util.dataToString(dataIn: userData)) + "\"}"
        let dataObject = Util.stringToData(string: stringData)
        apiService.selectUser(url: requestUrl, data: dataObject!, selectSuccess: { paramData in
            let stringResult = decodeString(data: paramData!.param)
            let resultData = Util.stringToData(string: stringResult)
            
            do {
                let json:CreateUserResponse = try decoder.decode(CreateUserResponse.self, from: resultData! as Data)
                realmDB.saveUser(user: json)
                selectSuccess(json)
            } catch let error as NSError {
                selectError(error.description)
            }
        }, selectError: selectError)
    }
}
