//
//  ClassNameTests.swift
//  mParticle-MoEngage-iOS-Unit-Tests
//
//  Created by Uday Kiran on 15/04/25.
//

import XCTest
@testable import mParticle_MoEngage

final class ClassNameTests: XCTestCase {
    
    func testMParticleClassName() {
        let expectedString = "MPKitMoEngage"
        XCTAssertEqual(expectedString, NSStringFromClass(MPKitMoEngage.self))
    }
}
