//
//  ClosureFeedControllerTest.swift
//  APIControllerTests
//
//  Created by Christophe Bugnon on 03/11/2021.
//

import XCTest
@testable import APIController

class ClosureFeedControllerTest: XCTestCase {
    func test_init_doesNotRequestLoadFromClient() {
        let (_, client) = makeSUT()

        XCTAssertEqual(client.requestCallCount, 0)
    }

    func test_load_requestLoadFromClient() {
        let (sut, client) = makeSUT()

        sut.load()

        XCTAssertEqual(client.requestCallCount, 1)
    }

    func test_load_deliversFeedOnClientSuccessFullRequest() {
        let (sut, client) = makeSUT()
        let feed = [Item(name: "Paul", age: 10, gender: .male),
                    Item(name: "Huguette", age: 26, gender: .female)]

        sut.load()
        client.complete(with: feed)

        XCTAssertEqual(sut.items, feed)
    }

    func test_load_doesNotDeliversFeedOnClientError() {
        let (sut, client) = makeSUT()
        let clientError = NSError(domain: "any error", code: 0)

        sut.load()
        client.complete(with: clientError)

        XCTAssertNil(sut.items)
    }

    func test_load_requestRouterToDisplayErrorOnClientError() {
        let (sut, client) = makeSUT()
        let clientError = NSError(domain: "any error", code: 0)
        let router = SingletonAPIRouterSpy()
        sut.router = router

        sut.load()
        client.complete(with: clientError)

        XCTAssertEqual(router.requestCallCount, 1)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: ClosureFeedController, client: ClientSpy) {
        let client = ClientSpy()
        let sut = ClosureFeedController()
        sut.loadFeed = client.load
        return (sut, client)
    }
}

