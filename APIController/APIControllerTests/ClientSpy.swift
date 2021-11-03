//
//  ClientSpy.swift
//  APIControllerTests
//
//  Created by Christophe Bugnon on 03/11/2021.
//

import Foundation
@testable import APIController

class ClientSpy: FeedClient {
    var requestCallCount = 0
    private var completions = [(Result) -> Void]()

    override func load(completion: @escaping (Result) -> Void) {
        requestCallCount += 1
        completions.append(completion)
    }

    func complete(with feed: [Item], at index: Int = 0) {
        completions[index](.success(feed))
    }

    func complete(with error: Error, at index: Int = 0) {
        completions[index](.failure(error))
    }
}
