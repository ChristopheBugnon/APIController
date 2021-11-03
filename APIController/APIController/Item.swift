//
//  Item.swift
//  APIController
//
//  Created by Christophe Bugnon on 03/11/2021.
//

import Foundation

enum Gender: Equatable {
    case female
    case male
}

struct Item: Equatable {
    let name: String
    let age: Int
    let gender: Gender
}
