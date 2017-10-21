//
//  SimpleCalcModel.swift
//  SimpleCalc-iOS
//
//  Created by studentuser on 10/19/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import Foundation

class SimpleCalcModel {
    // Enumeration of possible types of operation
    enum Operation {
        // User type one operand, operation, followed by operand. Operation is then performed
        case binaryOperation((Int, Int) -> Int)
        // User type one operand, followed by operation. Operation is then performed
        case unaryOperation((Int) -> Int)
        // User type the operands, then operation is then typed and performed
        case aggregateOperation(([Int]) -> Int)
    }
    
    // Dictionary of possible operations
    private var operations: Dictionary<String,Operation> = [
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "-" : Operation.binaryOperation({ $0 - $1 }),
        "*" : Operation.binaryOperation({ $0 * $1 }),
        "/" : Operation.binaryOperation({ $0 / $1 }),
        "%" : Operation.binaryOperation({ ($0 * $1) * (1 - $1) }),
        "count" : Operation.aggregateOperation({ $0.count }),
        "avg" : Operation.aggregateOperation({
            var sum = 0
            for num in $0 {
                sum += num
            }
            return sum / $0.count
        }),
        "fact" : Operation.unaryOperation({
            var accumulator = 1
            if $0 == 0 {
                return 0
            } else if $0 < 0 {
                accumulator = -1
            }
            
            for i in 1...abs($0) {
                accumulator *= i
            }
            return accumulator
        }),
        ]
    
    
    var inputEnded = false
    var operands: [Int] = []
    var mathOperator: Operation?
    var result: Int?
    
    func resetAndRaiseError(error:String) {
        print(error)
        operands = []
        mathOperator = nil
    }
    
    // Reads input from the console
    let response = readLine(strippingNewline: true)!
    
    // Verify the given operand
    func verifyOperand() {
        if  let value = Int(response){
            operands.append(value)
            switch mathOperator {
            case .binaryOperation?:
                inputEnded = true
            case .aggregateOperation?:
                resetAndRaiseError(error: "Unexpected Operand. Please try again.")
            default:
                break
            }
        }
    }
    
    // Verify the given operator
    func verifyOperator() {
        if mathOperator == nil, let thisOperation = operations[response]{
            switch thisOperation {
            case .binaryOperation:
                if operands.count != 1{
                    resetAndRaiseError(error: "Unexpected Operation. Please try again.")
                } else {
                    mathOperator = thisOperation
                }
            case .aggregateOperation:
                if operands.count < 1{
                    resetAndRaiseError(error: "Required at least one operand. please try again.")
                } else {
                    inputEnded = true
                    mathOperator = thisOperation
                }
            case .unaryOperation:
                if operands.count != 1 {
                    resetAndRaiseError(error: "Expected one operand. Please try again.")
                } else {
                    inputEnded = true
                }
            }
        } else {
            resetAndRaiseError(error: "Invalid Input. Please try again.")
        }
    }
    
    // Perform the operation
    func performOperation() {
        if let operation = mathOperator {
            switch operation {
            case .binaryOperation(let function):
                result = function(operands[0], operands[1])
            case .aggregateOperation(let function):
                result = function(operands)
            case .unaryOperation(let function):
                result = function(operands[0])
            }
        }
    }
    
}




