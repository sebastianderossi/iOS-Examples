//
//  SimpleCalculatorViewController.swift
//  SimpleCalculator
//
//  Created by Sebastian DeRossi on 2018-07-18.
//  Copyright © 2018 Sebastian DeRossi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    var previousNumber:Double = 0;
    var displayNumber:Double = 0;
    var selectedOperation:Int = -1;
    var isCalculating = false;
    var firstTime = true;
    
    struct buttons {
        var CLEAR_BUTTON:Int = 11;
        var DIVIDE_BUTTON:Int = 12;
        var MULTIPLE_BUTTON:Int = 13;
        var SUB_BUTTON:Int = 14;
        var ADD_BUTTON:Int = 15;
        var EQUALS_BUTTON:Int = 16;
        var NEGATIVE_BUTTON:Int = 46;
        var PERCENTAGE_BUTTON:Int = 45;
    }
    
    @IBAction func handleButtonClick(_ sender: UIButton) {
        var str = "";
        if (firstTime == true) {
             displayLabel.text = str;
            firstTime = false;
        }
        if (isCalculating == true) {
            str = String(sender.tag);
            isCalculating = false;
        }else {
            str = displayLabel.text! + String(sender.tag);
        }
        displayLabel.text = str;
        displayNumber = Double(displayLabel.text!)!;
    }
   
    @IBAction func handleOpertationClick(_ sender: UIButton) {
        let tag = sender.tag;
        if (tag != buttons().CLEAR_BUTTON && tag != buttons().EQUALS_BUTTON  && displayLabel.text != "" ) {
            if (selectedOperation != tag) {
                previousNumber = displayNumber;
                switch (tag) {
                case buttons().DIVIDE_BUTTON: // Divde
                    displayLabel.text = "÷";
                    break;
                case buttons().MULTIPLE_BUTTON: // Mulitpy
                    displayLabel.text = "x";
                    break;
                case buttons().SUB_BUTTON: //Minus
                    displayLabel.text = "-";
                    break;
                case buttons().ADD_BUTTON: //Addition
                    displayLabel.text = "+";
                    break;
                case buttons().NEGATIVE_BUTTON:
                     previousNumber *= -1;
                     displayLabel.text = String(previousNumber);
                     displayNumber = previousNumber;
                     return;
                    break;
                case buttons().PERCENTAGE_BUTTON:
                    //previousNumber /= 100;
                    //displayLabel.text = String(previousNumber);
                    //displayNumber = previousNumber;
                    showAlert(title:"TODO", message:"Add percentage logic");
                    return;
                    break;
                default:
                    print("tag:", tag);
                }
                selectedOperation = tag;
                isCalculating = true;
            }
        }
        if (sender.tag == buttons().EQUALS_BUTTON) {
            var result:Double = 0;
            
            switch(selectedOperation) {
                case buttons().ADD_BUTTON:
                    result = previousNumber + displayNumber;
                    print(result,previousNumber,displayNumber);
                    break;
                case buttons().MULTIPLE_BUTTON:
                    result = previousNumber * displayNumber;
                    break;
                case buttons().DIVIDE_BUTTON:
                    result = previousNumber / displayNumber;
                    break;
                case buttons().SUB_BUTTON:
                    result = previousNumber - displayNumber;
                    break;
            default:
                return;
            }
            if (result.truncatingRemainder(dividingBy: 1) <= 0.1) {
                let num = Int(result);
                displayLabel.text = String(num);
            }else {
                displayLabel.text = String(result);
            }
            print(result, selectedOperation);
            previousNumber = result;
        }
        
        if (sender.tag == buttons().CLEAR_BUTTON) {
            displayLabel.text = "0";
            previousNumber = 0;
            displayNumber = 0;
            isCalculating = false;
            selectedOperation = -1;
            firstTime = true;
        }
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}));
        self.present(alert, animated:true, completion: nil);
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

