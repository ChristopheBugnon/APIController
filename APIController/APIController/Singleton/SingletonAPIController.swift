//
//  SingletonAPIController.swift
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

class SingletonAPIClient {
    typealias Result = Swift.Result<[Item], Error>
    static let shared = SingletonAPIClient()

    init() {}

    func load(completion: @escaping (Result) -> Void) {}
}

protocol APIRouter {
    func display(_ error: Error)
}

class SingletonAPIController {
    var api = SingletonAPIClient.shared
    var router: APIRouter?
    var items: [Item]?

    func load() {
        api.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.items = feed
            case let .failure(error):
                self?.router?.display(error)
            }
        }
    }
}
