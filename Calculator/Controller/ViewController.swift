//
//  ViewController.swift
//  Calculator
//
//  Created by Ömer Faruk Şahin on 23.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var resultDisplay: UILabel!
    @IBOutlet var operationDisplay: UILabel!
    let calculator = Calculator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func updateDisplays(_ sender: UIButton) {
        guard let buttonCharacter = sender.titleLabel?.text else {
            return }
        let expression = operationDisplay.text ?? ""
        let result = calculator.prepareValidOutput(expression, buttonCharacter)
        operationDisplay.text = result
    }
    
    @IBAction func clearDisplay(_ sender: UIButton) {
        operationDisplay.text = ""
    }
    
    @IBAction func deleteLastCharacter(_ sender: UIButton) {
        let expression = operationDisplay.text ?? ""
        let result = calculator.deleteLastCharacter(expression)
        operationDisplay.text = result
    }
    
    @IBAction func operateExpression(_ sender: UIButton) {
        let expression = operationDisplay.text ?? ""
        let result = calculator.evaluate(expression)
        resultDisplay.text = expression
        operationDisplay.text = result
        
    }
    @IBAction func getPercentage(_ sender: UIButton) {
        let expression = operationDisplay.text ?? ""
        let result = calculator.getPercentage(expression)
        operationDisplay.text = result
    }
    
    @IBAction func getPlusMinus(_ sender: UIButton) {
        let expression = operationDisplay.text ?? ""
        let result = calculator.getPlusMinus(expression)
        operationDisplay.text = result
    }
}

