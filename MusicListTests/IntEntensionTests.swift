//
//  Int+EntensionTests.swift
//  MusicListTests
//
//  Created by Boray Chen on 2024/7/19.
//

import Foundation
import XCTest
@testable import MusicList

final class IntEntensionTests: XCTestCase {

    func testFormateTime() {
        
        // Test case 1: Zero seconds
        XCTAssertEqual(0.formatTime(), "0:00")
        
        // Test case 2: Less than a minute
        XCTAssertEqual(45000.formatTime(), "0:45")
        
        // Test case 3: Exactly one minute
        XCTAssertEqual(60000.formatTime(), "1:00")
        
        // Test case 4: More than a minute
        XCTAssertEqual(75000.formatTime(), "1:15")
        
        // Test case 5: Multiple minutes
        XCTAssertEqual(360000.formatTime(), "6:00")
        
        // Test case 6: Mixed minutes and seconds
        XCTAssertEqual(366000.formatTime(), "6:06")
        
        // Test case 7: Edge case with 999 milliseconds
        XCTAssertEqual(59999.formatTime(), "0:59")
    
    }

}
