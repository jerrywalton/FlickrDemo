//
//  FlickrDemoTests.swift
//  FlickrDemoTests
//
//  Created by Jerry Walton on 3/17/25.
//
import Testing
@testable import FlickrDemo

struct FlickrDemoTests {

    // Test view model
    @Test("Test FlickrViewModel")
    func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        let viewModel = FlickrViewModel()
        #expect(viewModel.testMe() != true)
    }

}
