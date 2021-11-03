//
//  ClosureFeedController.swift
//  APIController
//
//  Created by Christophe Bugnon on 03/11/2021.
//

import Foundation

class ClosureFeedController {
    typealias Result = Swift.Result<[Item], Error>
    var loadFeed: ((@escaping (Result) -> Void) -> Void)?
    var router: APIRouter?
    var items: [Item]?

    func load() {
        loadFeed? { [weak self] result in
            switch result {
            case let .success(feed):
                self?.items = feed
            case let .failure(error):
                self?.router?.display(error)
            }
        }
    }
}
