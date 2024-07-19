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
        // Arrange
        let service = MockNetworkService()
        
        // Act
        let viewModel = HomeViewModel(service: MockNetworkService(), audioPlayer: AudioPlayer())
        
        // Assert
        XCTAssertNotNil(viewModel, "The view model should not be nil")
    }

    func testSuccessFulMusicListFetch() {
        // Arrange
        let expectation = XCTestExpectation(description: "Asynchronous operation expectation")
        let viewModel = HomeViewModel(service: MockNetworkService(), audioPlayer: AudioPlayer())
        let mockDelgate = MockHomeViewModelDelegate(expectation: expectation)
        viewModel.delegate = mockDelgate
        
        // Act
        viewModel.fetchMediaItems(with: "test")
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 0.1)
    
        // Assert
        XCTAssertEqual(viewModel.numberOfItems(), 3)
    }
    
    func testMusicListInvalidJSON() {
        // Arrange
        let expectation = XCTestExpectation(description: "Asynchronous operation expectation")
        let service = MockNetworkService()
        service.mockData = invalidMusicListData
        let mockDelegate = MockHomeViewModelDelegate(expectation: expectation)
        let viewModel = HomeViewModel(service: service, audioPlayer: AudioPlayer())
        viewModel.delegate = mockDelegate
        let errorMessage = "Failed to parse JSON"
        
        // Act
        viewModel.fetchMediaItems(with: "test")
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 0.1)
        
        // Assert
        XCTAssertEqual(viewModel.numberOfItems(), 0)
        XCTAssertTrue(mockDelegate.didReceiveErrorCalled, "Delegate's didReceiveError should be called")
        XCTAssertEqual(mockDelegate.receivedErrorMessage, errorMessage, "Delegate should receive correct error message")
        
    }
    //
    func testInvalidDataError() {
        // Arrange
        let expectation = XCTestExpectation(description: "Asynchronous operation expectation")
        let service = MockNetworkService()
        service.mockError = .invalidData
        let mockDelegate = MockHomeViewModelDelegate(expectation: expectation)
        let viewModel = HomeViewModel(service: service, audioPlayer: AudioPlayer())
        viewModel.delegate = mockDelegate
        
        // Act
        viewModel.fetchMediaItems(with: "test")
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 0.1)
        
        // Assert
        XCTAssertEqual(viewModel.numberOfItems(), 0)
        XCTAssertTrue(mockDelegate.didReceiveErrorCalled, "Delegate's didReceiveError should be called")
        XCTAssertEqual(mockDelegate.receivedErrorMessage, APIError.invalidData.customDescription, "Delegate should receive correct error message")
    }
    
    func testInvalidStatusCodeError() {
        // Arrange
        let expectation = XCTestExpectation(description: "Asynchronous operation expectation")
        let service = MockNetworkService()
        service.mockError = .invalidStatusCode(statusCode: 404)
        let mockDelegate = MockHomeViewModelDelegate(expectation: expectation)
        let viewModel = HomeViewModel(service: service, audioPlayer: AudioPlayer())
        viewModel.delegate = mockDelegate
        
        // Act
        viewModel.fetchMediaItems(with: "test")
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 0.1)
        
        // Assert
        XCTAssertEqual(viewModel.numberOfItems(), 0)
        XCTAssertTrue(mockDelegate.didReceiveErrorCalled, "Delegate's didReceiveError should be called")
        XCTAssertEqual(mockDelegate.receivedErrorMessage, APIError.invalidStatusCode(statusCode: 404).customDescription, "Delegate should receive correct error message")
    }
    
    func testSelectItems() {
        // Arrange
        let expectation = XCTestExpectation(description: "Asynchronous operation expectation")
        let service = MockNetworkService()
        let mockDelegate = MockHomeViewModelDelegate(expectation: expectation)
        
        let musicListResponse = try! JSONDecoder().decode(SearchResponse.self, from: testMusicListData)
        let viewModel = HomeViewModel(service: service, audioPlayer: AudioPlayer(), mediaItems: musicListResponse.results)
        viewModel.delegate = mockDelegate
        
        // Act
        viewModel.selectItem(at: 0)
        
        // Assert
        XCTAssertEqual(mockDelegate.didUpdateUICallCount, 1, "Delegate's didUpdateUI should be called once")
        XCTAssertEqual(mockDelegate.lastPlayStatusText, "正在播放 ▶️", "Play status text should be '正在播放 ▶️'")
        XCTAssertEqual(mockDelegate.lastIndexPath, IndexPath(item: 0, section: 0), "Index path should be (0, 0)")
        
        // Act
        viewModel.selectItem(at: 1)
        
        // Assert
        XCTAssertEqual(mockDelegate.didUpdateUICallCount, 3, "Delegate's didUpdateUI should be called three times")
        XCTAssertEqual(viewModel.playListCellViewModels[0].isPlaying, false, "First item should not be playing")
        XCTAssertEqual(viewModel.playListCellViewModels[1].isPlaying, true, "Second item should be playing")
        XCTAssertEqual(mockDelegate.lastPlayStatusText, "正在播放 ▶️", "Play status text should be '正在播放 ▶️'")
        XCTAssertEqual(mockDelegate.lastIndexPath, IndexPath(item: 1, section: 0), "Index path should be (1, 0)")
        
    }
}
