//
//  BaseError.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/28.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import Foundation

enum BaseError: Error {
    
    case networkError1
    case httpError(httpCode: Int)
    case unexpectedError
    
    public var errorMessage: String? {
        switch self {
        case .networkError1:
            return "Network Error"
        
        default:
            return "Unexpected Error"
        }
    }
}
