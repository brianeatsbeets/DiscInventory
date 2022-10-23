//
//  DiscTests.swift
//  DiscInventoryTests
//
//  Created by Aguirre, Brian P. on 10/23/22.
//

// MARK: - Imported frameworks

import XCTest
@testable import DiscInventory

// MARK: - Main class

// This test class contains tests for the Disc model
final class DiscTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut: Disc!
    
    // MARK: - Life cycle functions
    
    // Initialize the SUT
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = Disc(name: "Aviar", color: .black, type: .putter, manufacturer: "Innova", plastic: "DX", weightInGrams: 175, speed: 2, glide: 3, turn: 0, fade: 1, condition: .great, notes: "", inBag: true)
    }

    // Deinitialize the SUT
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    // MARK: - Tests
    
    // Test getting the index of the disc type
    func testDiscTypeGetIndex() {
        // Given - Disc was initialized
        
        // When
        let index = sut.type.getIndex()
        
        // Then
        XCTAssertEqual(index, 0, "Result does not match type index")
    }
    
    // Test getting the index of the disc condition
    func testDiscConditionGetIndex() {
        // Given - Disc was initialized
        
        // When
        let index = sut.condition.getIndex()
        
        // Then
        XCTAssertEqual(index, 0, "Result does not match condition index")
    }

}
