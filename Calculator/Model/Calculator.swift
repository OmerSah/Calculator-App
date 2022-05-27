//
//  Calculator.swift
//  Calculator
//
//  Created by Ömer Faruk Şahin on 25.05.2022.
//

import Foundation

class Calculator {    
    func prepareValidOutput(_ expression: String, _ input: String) -> String {
        if expression == "" && Character(input).isMathCharacter {
            return expression
        }
        if expression.last?.isMathCharacter ?? false && Character(input).isMathCharacter {
            if input == "." || expression.last ?? "." == "." {
                return expression
            }
            var lastRemoved = expression
            lastRemoved.removeLast()
            return lastRemoved + input
        }
        let numbers = expression.components(separatedBy: ["-", "*", "/", "+"])
        if input == "." && numbers.last?.contains(".") ?? true {
            return expression
        }
        if numbers.last ?? " " == "0" {
            if input == "0" {
                return expression
            }
            if !Character(input).isMathCharacter {
                var lastRemoved = expression
                lastRemoved.removeLast()
                return lastRemoved + input
            }
        }
        return expression + input
    }
    
    func evaluate(_ expression: String) -> String
    {
        if expression.last?.isMathCharacter ?? true {
            return expression
        }
        let expn = NSExpression(format:expression) 
        let result = expn.toFloatingPoint().expressionValue(with: nil, context: nil)
        let resultString = String(describing: result ?? expression)
        return resultString
    }
    
    func deleteLastCharacter(_ expression: String) -> String {
        if expression == "" { return expression }
        var lastCharDeleted = expression
        lastCharDeleted.removeLast()
        return lastCharDeleted
    }
    
    func getPercentage(_ expression: String) -> String {
        if expression.last?.isMathCharacter ?? true {
            return expression
        }
        let numbers = expression.components(separatedBy: ["-", "*", "/", "+"])
        let lastNumber = numbers.last ?? ""
        if let result = Double(lastNumber) {
            let lastNumberPercentage = result / 100
            let range = expression.range(of: String(lastNumber),options: String.CompareOptions.backwards,range: nil,locale: nil)!
            let withoutLastNumber = expression.replacingCharacters(in: range, with: "")
            return withoutLastNumber + String(lastNumberPercentage)
        }
        return expression
    }
    
    func getPlusMinus(_ expression: String) -> String {
        if expression.last?.isMathCharacter ?? true {
            return expression
        }
        let numbers = expression.components(separatedBy: ["-", "*", "/", "+"])
        let lastNumber = numbers.last ?? ""
        if let result = Double(lastNumber) {
            let resultNumber = -1 * result
            var lastNumberPlusMinus: String
            if resultNumber == floor(resultNumber){
                lastNumberPlusMinus = String(Int(resultNumber))
            } else {
                lastNumberPlusMinus = String(resultNumber)
            }
            let range = expression.range(of: String(lastNumber),options: String.CompareOptions.backwards,range: nil,locale: nil)!
            let parsed = expression.replacingCharacters(in: range, with: "")
            var resultString = parsed + String(lastNumberPlusMinus)
            if  parsed.count >= 2 && parsed.last! == "-"  &&  !Array(parsed)[parsed.count - 2].isArithmeticOperator {
                resultString = resultString.replacingOccurrences(of: "--", with: "+")
            } else {
                resultString = resultString.replacingOccurrences(of: "--", with: "")
            }
            return resultString
        }
        return expression
    }
}

extension NSExpression {
    func toFloatingPoint() -> NSExpression {
        switch expressionType {
        case .constantValue:
            if let value = constantValue as? NSNumber {
                return NSExpression(forConstantValue: NSNumber(value: value.doubleValue))
            }
        case .function:
           let newArgs = arguments.map { $0.map { $0.toFloatingPoint() } }
           return NSExpression(forFunction: operand, selectorName: function, arguments: newArgs)
        case .conditional:
           return NSExpression(forConditional: predicate, trueExpression: self.true.toFloatingPoint(), falseExpression: self.false.toFloatingPoint())
        case .unionSet:
            return NSExpression(forUnionSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .intersectSet:
            return NSExpression(forIntersectSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .minusSet:
            return NSExpression(forMinusSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .subquery:
            if let subQuery = collection as? NSExpression {
                return NSExpression(forSubquery: subQuery.toFloatingPoint(), usingIteratorVariable: variable, predicate: predicate)
            }
        case .aggregate:
            if let subExpressions = collection as? [NSExpression] {
                return NSExpression(forAggregate: subExpressions.map { $0.toFloatingPoint() })
            }
        case .evaluatedObject, .variable, .keyPath, .anyKey, .block:
            break
        default:
            break
        }
        return self
    }
}

extension Character {
    var isArithmeticOperator: Bool {
        return self == "+" || self == "-" || self == "*" || self == "/"
    }
    var isMathCharacter: Bool {
        return self == "+" || self == "-" || self == "*" || self == "/" || self == "."
    }
}
