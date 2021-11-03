//
//  MutableGlobalStateAPIControllerTest.swift
//  APIControllerTests
//
//  Created by Christophe Bugnon on 03/11/2021.
//

import Foundation
import XCTest
@testable import APIController

class MutableGlobalStateMockAPIClient: MutableGlobalStateAPIClient {
    var requestCallCount = 0
    private var completions = [(Result) -> Void]()

    override func load(completion: @escaping (Result) -> Void) {
        completions.append(completion)
        requestCallCount += 1
    }

    func complete(with feed: [Item], at index: Int = 0) {
        completions[index](.success(feed))
    }

    func complete(with error: Error, at index: Int = 0) {
        completions[index](.failure(error))
    }
}

class RouterSpy: APIRouter {
    var requestCallCount = 0

    func display(_ error: Error) {
        requestCallCount += 1
    }
}

class MutableGlobalStateAPIControllerTest: XCTestCase {
    var client: MutableGlobalStateMockAPIClient!
    override func setUp() {
        client = MutableGlobalStateMockAPIClient()
        MutableGlobalStateAPIClient.shared = client
    }

    override func tearDown() {
        MutableGlobalStateAPIClient.shared = MutableGlobalStateAPIClient()
    }

    func test_init_doesNotRequestLoadFromClient() {
        let _ = makeSUT()

        XCTAssertEqual(client.requestCallCount, 0)
    }

    func test_load_requestLoadFromClient() {
        let sut = makeSUT()

        sut.load()

        XCTAssertEqual(client.requestCallCount, 1)
    }

    func test_load_deliversFeedOnClientSuccessFullRequest() {
        let sut = makeSUT()
        let feed = [Item(name: "Paul", age: 10, gender: .male),
                    Item(name: "Huguette", age: 26, gender: .female)]

        sut.load()
        client.complete(with: feed)

        XCTAssertEqual(sut.items, feed)
    }

    func test_load_doesNotDeliversFeedOnClientError() {
        let sut = makeSUT()
        let clientError = NSError(domain: "any error", code: 0)

        sut.load()
        client.complete(with: clientError)

        XCTAssertNil(sut.items)
    }

    func test_load_requestRouterToDisplayErrorOnClientError() {
        let sut = makeSUT()
        let clientError = NSError(domain: "any error", code: 0)
        let router = SingletonAPIRouterSpy()
        sut.router = router

        sut.load()
        client.complete(with: clientError)

        XCTAssertEqual(router.requestCallCount, 1)
    }

    // MARK: - Helpers

    private func makeSUT() -> (MutableGlobalStateAPIController) {
        return MutableGlobalStateAPIController()
    }
}
