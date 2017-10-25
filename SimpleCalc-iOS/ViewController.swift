//
//  ViewController.swift
//  SimpleCalc-iOS
//
//  Created by studentuser on 10/19/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var mainInputView: UIStackView!
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var firstOperatorView: UIStackView!
    @IBOutlet weak var secondOperatorView: UIStackView!
    
    
    override func viewDidLoad() {
        secondOperatorView.isHidden = true
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Calculator Interface
    
    // State of the input
    var userIsTyping = false
    var decimalInput = false
    var isRpnMode = false
    private var calculatorModel = SimpleCalcModel()
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        // If the user is in the middle of typing digits. (Typing following digits.)
        if userIsTyping && digit != "."{
            let textInDisplay = display.text!
            display.text = textInDisplay + digit
            // If the user types decimal, when the input is not decimal
        } else if digit == "." && !decimalInput {
            let textInDisplay = display.text!
            display.text = textInDisplay + digit
            userIsTyping = true
            decimalInput = true
            // If the user types zero
        } else if digit != "0" && !decimalInput {
            display.text = digit
            userIsTyping = true
        }
    }
    
    
    @IBAction func touchOperation(_ sender: UIButton) {
        userIsTyping = false
        if let mathOperations = sender.currentTitle {
            switch mathOperations {
            case "π":
                displayValue = Double.pi
            case "√":
                displayValue = sqrt(displayValue)
            case "AC":
                display.text = "0"
                decimalInput = false
                calculatorModel = SimpleCalcModel()
            case "=":
                calculatorModel.inputOperand(display.text!)
                if !isRpnMode, let result = calculatorModel.performOperation() {
                    display.text = result
                }
            case "...":
                firstOperatorView.isHidden = !firstOperatorView.isHidden
                secondOperatorView.isHidden = !secondOperatorView.isHidden
                break
            case "fact":
                calculatorModel = SimpleCalcModel()
                calculatorModel.inputOperand(display.text!)
                calculatorModel.inputOperator(mathOperations)
                if let result = calculatorModel.performOperation() {
                    display.text = result
                }
            case "BASIC":
                isRpnMode = true
                sender.setTitle("RPN", for: .normal)
            case "RPN":
                isRpnMode = false
                sender.setTitle("BASIC", for: .normal)
            default:
                if isRpnMode {
                    calculatorModel.inputOperator(mathOperations + mathOperations)
                    calculatorModel.inputOperand(display.text!)
                    display.text = calculatorModel.performOperation()
                } else {
                    calculatorModel.inputOperand(display.text!)
                    calculatorModel.inputOperator(mathOperations)
                }
                userIsTyping = false
                decimalInput = false
            }
        }
    }
}

class SimpleCalcModel {
    // Enumeration of possible types of operation
    enum Operation {
        // User type one operand, operation, followed by operand. Operation is then performed
        case binaryOperation((Double, Double) -> Double)
        // User type one operand, followed by operation. Operation is then performed
        case unaryOperation((Double) -> Double)
        // User type the operands, then operation is then typed and performed
        case aggregateOperation(([Double]) -> Double)
        case arrayOperation(([Double]) -> Double)
    }
    
    // Dictionary of possible operations
    private var operations: Dictionary<String,Operation> = [
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "-" : Operation.binaryOperation({ $0 - $1 }),
        "*" : Operation.binaryOperation({ $0 * $1 }),
        "/" : Operation.binaryOperation({ $0 / $1 }),
        "%" : Operation.binaryOperation({ ($0 * $1) * (1 - $1) }),
        "count" : Operation.aggregateOperation({ Double($0.count) }),
        "avg" : Operation.aggregateOperation({
            var sum = 0.0
            for num in $0 {
                sum += num
            }
            return sum / Double($0.count)
        }),
        "fact" : Operation.unaryOperation({
            var accumulator = 1
            if $0 == 0 {
                return 0
            } else if $0 < 0 {
                accumulator = -1
            }
            for i in 1...Int(abs($0)) {
                accumulator *= i
            }
            return Double(accumulator)
        }),
        "++" : Operation.arrayOperation({
            var sum = 0.0
            for num in $0 {
                sum += num
            }
            return sum
            }),
        "--" : Operation.arrayOperation({
            var accumulator = 0.0
            for num in $0 {
                accumulator -= num
            }
            return accumulator
        }),
        "**" : Operation.arrayOperation({
            var accumulator = 0.0
            for num in $0 {
                accumulator *= num
            }
            return accumulator
        }),
        "//" : Operation.arrayOperation({
            var accumulator = 0.0
            for num in $0 {
                accumulator /= num
            }
            return accumulator
        })
        
        ]
    
    var operands: [Double] = []
    var mathOperator: Operation?
    var result: Double?
    
    func resetAndRaiseError(error:String) {
        print(error)
        operands = []
        mathOperator = nil
    }
    
    // Verify and append the given operand
    func inputOperand(_ input:String) {
        if  let value = Double(input){
            operands.append(value)
        }
    }
    
    // Verify and keep the given operator
    func inputOperator(_ input:String) {
        if mathOperator == nil, let thisOperation = operations[input]{
            switch thisOperation {
            case .binaryOperation:
                mathOperator = thisOperation
            case .aggregateOperation:
                if operands.count < 1{
                    resetAndRaiseError(error: "Required at least one operand. please try again.")
                } else {
                    mathOperator = thisOperation
                }
            case .unaryOperation:
                if operands.count != 1 {
                    print(operands.count)
                    resetAndRaiseError(error: "Expected one operand. Please try again.")
                } else {
                    mathOperator = thisOperation
                }
            case .arrayOperation:
                if operands.count < 1{
                    resetAndRaiseError(error: "Required at least one operand. please try again.")
                } else {
                    mathOperator = thisOperation
                }
            }
        }
    }
    
    // Perform the operation
    func performOperation() -> String? {
        if let operation = mathOperator {
            switch operation {
            case .binaryOperation(let function):
                result = function(operands[0], operands[1])
            case .aggregateOperation(let function):
                result = function(operands)
            case .unaryOperation(let function):
                result = function(operands[0])
            case .arrayOperation(let function):
                result = function(operands)
            }
            operands = []
            mathOperator = nil
            return String(result!)
        }
        return nil
    }
    
}


