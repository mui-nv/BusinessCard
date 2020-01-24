//
//  CreateUserResponse.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import Foundation

struct CreateUserResponse: Codable {
    var id: Int
    var user: String?
    var password: String?
}
