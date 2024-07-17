//
//  HomeViewModelTests.swift
//  MusicListTests
//
//  Created by Boray Chen on 2024/7/17.
//

import XCTest
@testable import MusicList

final class HomeViewModelTests: XCTestCase {

    func testInit() throws {
        let service = MockNetworkService.shared
        let viewModel = HomeViewModel(service: service, audioPlayer: AudioPlayer())
        
        XCTAssertNotNil(viewModel, "The view model should not be nil")
    }

    func testSuccessFulMusicListFetch() {
        let service = MockNetworkService.shared
        let viewModel = HomeViewModel(service: service, audioPlayer: AudioPlayer())
        viewModel.fetchMediaItems(with: "test")
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            XCTAssertEqual(viewModel.numberOfItems(), 3)
        })
    }
    
    func testMusicListInvalidJSON() {
        // Arrange
        let service = MockNetworkService.shared
        service.mockData = invalidMusicListData
        let mockDelegate = MockHomeViewModelDelegate()
        let viewModel = HomeViewModel(service: service, audioPlayer: AudioPlayer())
        viewModel.delegate = mockDelegate
        let errorMessage = "Failed to parse JSON"
        
        // Act
        viewModel.fetchMediaItems(with: "test")
    
        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            XCTAssertEqual(viewModel.numberOfItems(), 0)
            XCTAssertTrue(mockDelegate.didReceiveErrorCalled, "Delegate's didReceiveError should be called")
            XCTAssertEqual(mockDelegate.receivedErrorMessage, errorMessage, "Delegate should receive correct error message")
        })
    }
    
    func testInvalidDataError() {
        // Arrange
        let service = MockNetworkService.shared
        service.mockError = .invalidData
        let mockDelegate = MockHomeViewModelDelegate()
        let viewModel = HomeViewModel(service: service, audioPlayer: AudioPlayer())
        viewModel.delegate = mockDelegate
        let errorMessage = "Failed to parse JSON"
        
        // Act
        viewModel.fetchMediaItems(with: "test")
    
        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            XCTAssertEqual(viewModel.numberOfItems(), 0)
            XCTAssertTrue(mockDelegate.didReceiveErrorCalled, "Delegate's didReceiveError should be called")
            XCTAssertEqual(mockDelegate.receivedErrorMessage, APIError.invalidData.customDescription, "Delegate should receive correct error message")
        })
    }
    
    func testInvalidStatusCodeError() {
        // Arrange
        let service = MockNetworkService.shared
        service.mockError = .invalidStatusCode(statusCode: 404)
        let mockDelegate = MockHomeViewModelDelegate()
        let viewModel = HomeViewModel(service: service, audioPlayer: AudioPlayer())
        viewModel.delegate = mockDelegate
        let errorMessage = "Failed to parse JSON"
        
        // Act
        viewModel.fetchMediaItems(with: "test")
    
        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            XCTAssertEqual(viewModel.numberOfItems(), 0)
            XCTAssertTrue(mockDelegate.didReceiveErrorCalled, "Delegate's didReceiveError should be called")
            XCTAssertEqual(mockDelegate.receivedErrorMessage, APIError.invalidStatusCode(statusCode: 404).customDescription, "Delegate should receive correct error message")
        })
    }
    
    func testViewModelSelectItems() {
//        let indicesToClick = [0, 1, 2]
//        let service = MockNetworkService.shared
//        let viewModel = HomeViewModel(service: service, audioPlayer: AudioPlayer())
//        viewModel.fetchMediaItems(with: "test")
//    
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//            XCTAssertEqual(viewModel.numberOfItems(), 3)
//        })
        
    }
}
