//
//  MusicListTests.swift
//  MusicListTests
//
//  Created by Boray Chen on 2024/7/14.
//

import XCTest
@testable import MusicList

final class MusicListTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodeMusicListIntoArray() throws {
        do {
            let musicListResponse = try JSONDecoder().decode(SearchResponse.self, from: testMusicListData)
            XCTAssertEqual(musicListResponse.results.count, 3)
        } catch {
            print("error decode test: \(error)")
        }
    }

}
