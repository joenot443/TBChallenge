//
//  DecodableModels.swift
//  TouchBistroChallenge
//
//  Created by Joseph Crozier on 2019-06-25.
//  Copyright © 2019 Joe Crozier. All rights reserved.
//

import UIKit

struct MenuData: Decodable {
    let groups: [GroupData]
}

struct GroupData: Decodable {
    let name: String
    let imageUrl: String
    let items: [ItemData]
}

struct ItemData: Decodable {
    let name: String
    let imageUrl: String
    let price: Float
}
