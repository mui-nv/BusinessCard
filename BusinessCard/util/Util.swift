//
//  Util.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import Foundation

class Util {
    static func stringToData(string: String) -> Data? {
        return string.data(using: String.Encoding.utf8)
    }
    
    static func dataToString(dataIn: Data?) -> String {
        return String(data: dataIn!, encoding: String.Encoding.utf8)!
    }
}
