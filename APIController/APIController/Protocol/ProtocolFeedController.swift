//
//  ProtocolAPIController.swift
//  APIController
//
//  Created by Christophe Bugnon on 03/11/2021.
//

import Foundation

class FeedClient {
    typealias Result = Swift.Result<[Item], Error>
    func load(completion: @escaping (Result) -> Void) {}
}


class ProtocolFeedController {
    let client: FeedClient
    var router: APIRouter?
    var items: [Item]?

    init(client: FeedClient) {
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
