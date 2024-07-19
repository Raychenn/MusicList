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

    func homeViewModelDidLoadData(_ self: HomeViewModel) {
        didReceiveDataCalled = true
    }
    
    func homeViewModel(_ self: HomeViewModel, didUpdateUIWithPlayStatusText playStatusText: String?, indexPath: IndexPath) {
        didUpdateUICallCount += 1
        lastPlayStatusText = playStatusText
        lastIndexPath = indexPath
    }
    
    func homeViewModel(_ self: HomeViewModel, didFailToFetchDataWithError error: APIError) {
        didReceiveErrorCalled = true
        receivedErrorMessage = error.customDescription
    }
    
    func homeViewModel(_ self: HomeViewModel, didFailToLoadPlayerWithError error: any Error) {
        
    }
    
    func homeViewModelDidStartLoading(_ self: HomeViewModel) {
        
    }
    
    func homeViewModelDidFinishLoading(_ self: HomeViewModel) {
        
    }
}
