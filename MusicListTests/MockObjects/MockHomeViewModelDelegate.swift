//
//  MockHomeViewModelDelegate.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/17.
//

import XCTest
@testable import MusicList

class MockHomeViewModelDelegate: HomeViewModelDelegate {
    let expectation: XCTestExpectation
    
    var didReceiveDataCalled = false
    var didReceiveErrorCalled = false
    var receivedErrorMessage: String?
    var didUpdateUICallCount = 0
    var lastPlayStatusText: String?
    var lastIndexPath: IndexPath?

    init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }
    
    func homeViewModelDidLoadData(_ self: HomeViewModel) {
        didReceiveDataCalled = true
        
        expectation.fulfill()
    }
    
    func homeViewModel(_ self: HomeViewModel, didUpdateUIWithPlayStatusText playStatusText: String?, indexPath: IndexPath) {
        didUpdateUICallCount += 1
        lastPlayStatusText = playStatusText
        lastIndexPath = indexPath
        
        expectation.fulfill()
    }
    
    func homeViewModel(_ self: HomeViewModel, didFailToFetchDataWithError error: APIError) {
        didReceiveErrorCalled = true
        receivedErrorMessage = error.customDescription
        
        expectation.fulfill()
    }
    
    func homeViewModel(_ self: HomeViewModel, didFailToLoadPlayerWithError error: any Error) {
        
    }
    
    func homeViewModelDidStartLoading(_ self: HomeViewModel) {
        
    }
    
    func homeViewModelDidFinishLoading(_ self: HomeViewModel) {
        
    }
}
