//
//  MutableGlobalStapeAPIController.swift
//  APIController
//
//  Created by Christophe Bugnon on 03/11/2021.
//

import Foundation

class MutableGlobalStateAPIClient {
    typealias Result = Swift.Result<[Item], Error>
    static var shared = MutableGlobalStateAPIClient()

    init() {}

    func load(completion: @escaping (Result) -> Void) {}
}

class MutableGlobalStateAPIController {
    let api = MutableGlobalStateAPIClient.shared
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
