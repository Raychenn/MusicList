//
//  MockHomeViewModelDelegate.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/17.
//

import Foundation

class MockHomeViewModelDelegate: HomeViewModelDelegate {
    var didReceiveDataCalled = false
    var didReceiveErrorCalled = false
    var receivedErrorMessage: String?
    var didUpdateUICallCount = 0
    var lastPlayStatusText: String?
    var lastIndexPath: IndexPath?

    func didLoadData(_ self: HomeViewModel) {
        didReceiveDataCalled = true
    }
    
    func didUpdateUI(_ self: HomeViewModel, playStatusText: String?, indexPath: IndexPath) {
        didUpdateUICallCount += 1
        lastPlayStatusText = playStatusText
        lastIndexPath = indexPath
    }
    
    func didStartLoading() {
        
    }
    
    func didFinishLoading() {
        
    }
    
    func didFailToFetchData(_ self: HomeViewModel, error: APIError) {
        didReceiveErrorCalled = true
        receivedErrorMessage = error.customDescription
    }

}
