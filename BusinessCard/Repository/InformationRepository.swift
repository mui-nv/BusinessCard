//
//  InformationRepository.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import Foundation

class InformationRepository: BaseRepository {
    let apiService = ApiService()
    let realmDB = RealmDB()
    
    func createInfo(data: CreateInfoParam, createSuccess: (Information?) -> (), createError: (String) -> ()) {
        let requestUrl = ApiService.baseUrl + ApiService.createUrl
        
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        
        let userData = try! encoder.encode(data)
        let stringData = "{\"param\":\"" + encodeString(data: Util.dataToString(dataIn: userData)) + "\"}"
        let dataObject = Util.stringToData(string: stringData)
        apiService.requestApiData(url: requestUrl, data: dataObject!, onSuccess: { paramData in
            let stringResult = decodeString(data: paramData!.param)
            let resultData = Util.stringToData(string: stringResult)
            
            do {
                let json:Information = try decoder.decode(Information.self, from: resultData! as Data)
                createSuccess(json)
            } catch let error as NSError {
                createError(error.description)
            }
        }, onError: createError)
    }
    
    func deleteInfo(data: DeleteParam, deleteSuccess: (DeleteResponse?) -> (), deleteError: (String) -> ()) {
        let requestUrl = ApiService.baseUrl + ApiService.deleteUrl
        
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        
        let userData = try! encoder.encode(data)
        let stringData = "{\"param\":\"" + encodeString(data: Util.dataToString(dataIn: userData)) + "\"}"
        print(stringData)
        let dataObject = Util.stringToData(string: stringData)
        apiService.requestApiData(url: requestUrl, data: dataObject!, onSuccess: { paramData in
            let stringResult = decodeString(data: paramData!.param)
            let resultData = Util.stringToData(string: stringResult)
            
            do {
                let json:DeleteResponse = try decoder.decode(DeleteResponse.self, from: resultData! as Data)
                deleteSuccess(json)
            } catch let error as NSError {
                deleteError(error.description)
            }
        }, onError: deleteError)
    }
    
    func searchInfo(data: SearchParam, searchSuccess: ([Information]?) -> (), searchError: (String) -> ()) {
        let requestUrl = ApiService.baseUrl + ApiService.searchUrl
        
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        
        let userData = try! encoder.encode(data)
        let stringData = "{\"param\":\"" + encodeString(data: Util.dataToString(dataIn: userData)) + "\"}"
        let dataObject = Util.stringToData(string: stringData)
        apiService.requestApiData(url: requestUrl, data: dataObject!, onSuccess: { paramData in
            let stringResult = decodeString(data: paramData!.param)
            let resultData = Util.stringToData(string: stringResult)
            
            do {
                let json:[Information] = try decoder.decode([Information].self, from: resultData! as Data)
                searchSuccess(json)
                realmDB.saveInfo(infos: json)
            } catch let error as NSError {
                searchError(error.description)
            }
        }, onError: searchError)
    }
    
    func getImage(data: ImageParam, searchSuccess: (ImageResponse?) -> (), searchError: (String) -> ()) {
        let requestUrl = ApiService.baseUrl + ApiService.getImageUrl
        
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        
        let userData = try! encoder.encode(data)
        let stringData = "{\"param\":\"" + encodeString(data: Util.dataToString(dataIn: userData)) + "\"}"
        let dataObject = Util.stringToData(string: stringData)
        apiService.requestApiData(url: requestUrl, data: dataObject!, onSuccess: { paramData in
            let stringResult = decodeString(data: paramData!.param)
            let resultData = Util.stringToData(string: stringResult)
            
            do {
                let json:ImageResponse = try decoder.decode(ImageResponse.self, from: resultData! as Data)
                searchSuccess(json)
            } catch let error as NSError {
                searchError(error.description)
            }
        }, onError: searchError)
    }
    
    func updateInfo(data: CreateInfoParam, updateSuccess: (DeleteResponse?) -> (), updateError: (String) -> ()) {
        let requestUrl = ApiService.baseUrl + ApiService.updateUrl
        
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        
        let userData = try! encoder.encode(data)
        let stringData = "{\"param\":\"" + encodeString(data: Util.dataToString(dataIn: userData)) + "\"}"
        let dataObject = Util.stringToData(string: stringData)
        apiService.requestApiData(url: requestUrl, data: dataObject!, onSuccess: { paramData in
            let stringResult = decodeString(data: paramData!.param)
            let resultData = Util.stringToData(string: stringResult)
            
            do {
                let json:DeleteResponse = try decoder.decode(DeleteResponse.self, from: resultData! as Data)
                updateSuccess(json)
            } catch let error as NSError {
                updateError(error.description)
            }
        }, onError: updateError)
    }
}
