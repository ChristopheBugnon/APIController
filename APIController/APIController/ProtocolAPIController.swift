//
//  ProtocolAPIController.swift
//  APIController
//
//  Created by Christophe Bugnon on 03/11/2021.
//

import Foundation

class ProtocolAPIClient {
    typealias Result = Swift.Result<[Item], Error>
    func load(completion: @escaping (Result) -> Void) {}
}


class ProtocolAPIController {
    let client: ProtocolAPIClient
    var router: APIRouter?
    var items: [Item]?

    init(client: ProtocolAPIClient) {
        self.client = client
    }

    func load() {
        client.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.items = feed
            case let .failure(error):
                self?.router?.display(error)
            }
        }
    }
}
