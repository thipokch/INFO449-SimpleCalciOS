//
//  SimpleCalcModelTests.swift
//  SimpleCalc-iOSTests
//
//  Created by studentuser on 10/20/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import XCTest
@testable import SimpleCalc_iOS

class SimpleCalcModelTests: XCTestCase {
    
    var simpleCalc:SimpleCalcModel? = SimpleCalcModel()
    
    func binaryInput(_ operandOne:String , _ operatorOne:String, _ operandTwo:String ) -> String? {
        simpleCalc!.inputOperand(operandOne)
        simpleCalc!.inputOperator(operatorOne)
        simpleCalc!.inputOperand(operandTwo)
        return simpleCalc!.performOperation()
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateSimpleCalcModel() {
        XCTAssert(simpleCalc != nil)
    }
    
    // Add Tests
    
    func testAddIntInt() {
        XCTAssert(binaryInput("1", "+", "13") == "14.0")
    }
    
    func testAddIntDouble() {
        XCTAssert(binaryInput("1", "+", "13.3") == "14.3")
    }
    
    func testAddDoubleInt() {
        XCTAssert(binaryInput("1.8", "+", "13.0") == "14.8")
    }
    
    // Subtract Tests
    
    func testSubtractIntInt() {
        XCTAssert(binaryInput("12", "-", "1") == "11.0")
    }
    
    func testSubtractIntDouble() {
        XCTAssert(binaryInput("13", "-", "13.0") == "0.0")
    }
    
    func testSubtractDoubleInt() {
        XCTAssert(binaryInput("1.8", "-", "1") == "0.8")
    }
    
    func testSubtractDoubleDouble() {
        XCTAssert(binaryInput("1.8", "-", "1.2") == "0.6")
    }
    
    func testSubtractIntIntToNeg() {
        XCTAssert(binaryInput("1", "-", "13") == "-12.0")
    }
    
    func testSubtractIntDoubleToNeg() {
        XCTAssert(binaryInput("1", "-", "13.3") == "-12.3")
    }
    
    func testSubtractDoubleIntToNeg() {
        XCTAssert(binaryInput("1.8", "-", "13") == "-11.2")
    }
    
    func testSubtractDoubleDoubleToNeg() {
        XCTAssert(binaryInput("1.6", "-", "1.9") == "-0.3")
    }
    
    // Multiply Tests
    
    func testMultiplyIntInt() {
        XCTAssert(binaryInput("12", "*", "1") == "12.0")
    }
    
    func testMultiplyIntDouble() {
        XCTAssert(binaryInput("13", "*", "13.3") == "172.9")
    }
    
    func testMultiplyDoubleInt() {
        XCTAssert(binaryInput("0.8", "*", "1") == "0.8")
    }
    
    func testMultiplyDoubleDouble() {
        XCTAssert(binaryInput("0.8", "*", "1.9") == "1.52")
    }
    
    func testMultiplyIntIntToNeg() {
        XCTAssert(binaryInput("-12", "*", "1") == "-12.0")
    }
    
    func testMultiplyIntDoubleToNeg() {
        XCTAssert(binaryInput("13", "*", "-13.3") == "-172.9")
    }
    
    func testMultiplyDoubleIntToNeg() {
        XCTAssert(binaryInput("0.8", "*", "-1") == "-0.8")
    }
    
    func testMultiplyDoubleDoubleToNeg() {
        XCTAssert(binaryInput("0.8", "*", "-1.9") == "-1.52")
    }
    
    // Divide Tests
    
    func testDivideIntInt() {
        XCTAssert(binaryInput("12", "/", "1") == "12.0")
    }
    
    func testDivideIntDouble() {
        XCTAssert(binaryInput("13", "/", "13.0") == "1.0")
    }
    
    func testDivideDoubleInt() {
        XCTAssert(binaryInput("0.8", "/", "1") == "0.8")
    }
    
    func testDivideDoubleDouble() {
        XCTAssert(binaryInput("0.8", "/", "0.8") == "1.0")
    }
    
    func testDivideIntIntToNeg() {
        XCTAssert(binaryInput("-12", "/", "1") == "-12.0")
    }
    
    func testDivideIntDoubleToNeg() {
        XCTAssert(binaryInput("13", "/", "-13.0") == "-1.0")
    }
    
    func testDivideDoubleIntToNeg() {
        XCTAssert(binaryInput("0.8", "/", "-1") == "-0.8")
    }
    
    func testDivideDoubleDoubleToNeg() {
        XCTAssert(binaryInput("0.8", "/", "-0.8") == "-1.0")
    }
}
