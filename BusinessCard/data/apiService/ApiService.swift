//
//  ApiService.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import Foundation

class ApiService {
    let key = "abcdefghijklmnop"
    let iv  = "1234567890123456"
    
    func encode(data: String) -> String {
        let aes = EncryptionAES()
        return aes.encrypt(key: key, iv: iv, text: data)
    }
    
    func decode(data: String) -> String {
        let aes = EncryptionAES()
        return aes.decrypt(key: key, iv: iv, base64: data)
    }
}
