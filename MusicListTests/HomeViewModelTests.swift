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
        let service = MockNetworkService.shared
        
        // Act
        let viewModel = HomeViewModel(service: service, audioPlayer: AudioPlayer())
        
        // Assert
        XCTAssertNotNil(viewModel, "The view model should not be nil")
    }

    func testSuccessFulMusicListFetch() {
        // Arrange
        let service = MockNetworkService.shared
        let viewModel = HomeViewModel(service: service, audioPlayer: AudioPlayer())
        
        // Act
        viewModel.fetchMediaItems(with: "test")
    
        // Assert
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
    
    func testSelectItems() {
        // Arrange
        let service = MockNetworkService.shared
        let mockDelegate = MockHomeViewModelDelegate()
        let viewModel = HomeViewModel(service: service, audioPlayer: AudioPlayer())
        viewModel.delegate = mockDelegate
        viewModel.fetchMediaItems(with: "test")
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
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
        })
    }
    
    func testFormateTime() {
        // Arrange
        let service = MockNetworkService.shared
        let mockDelegate = MockHomeViewModelDelegate()
        let viewModel = HomeViewModel(service: service, audioPlayer: AudioPlayer())
        
        // Test case 1: Zero seconds
        XCTAssertEqual(viewModel.formatTime(seconds: 0), "0:00")
        
        // Test case 2: Less than a minute
        XCTAssertEqual(viewModel.formatTime(seconds: 45000), "0:45")
        
        // Test case 3: Exactly one minute
        XCTAssertEqual(viewModel.formatTime(seconds: 60000), "1:00")
        
        // Test case 4: More than a minute
        XCTAssertEqual(viewModel.formatTime(seconds: 75000), "1:15")
        
        // Test case 5: Multiple minutes
        XCTAssertEqual(viewModel.formatTime(seconds: 360000), "6:00")
        
        // Test case 6: Mixed minutes and seconds
        XCTAssertEqual(viewModel.formatTime(seconds: 366000), "6:06")
        
        // Test case 7: Edge case with 999 milliseconds
        XCTAssertEqual(viewModel.formatTime(seconds: 59999), "0:59")

    }
}
