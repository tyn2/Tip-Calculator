//
//  ViewController.swift
//  Tip Calculator
//
//  Created by Tiffany Ng on 8/21/15.
//  Copyright (c) 2015 Tiffany Ng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var tipAmount: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var tipSection: UIView!
    var timer: NSTimer!
    var runloop: NSRunLoop!
    var billAmount: Double!
    
    // Reset app to original position
    func reset(){
        pageTitle.text = "How much was the bill?"
        billField.text = nil
        billField.textAlignment = NSTextAlignment.Right
        billAmount = 0.0
        
        tipControl.selectedSegmentIndex = UISegmentedControlNoSegment
        tipAmount.text = "$0.00"
        totalAmount.text = "$0.00"
        
        tipSection.alpha = 0
        billField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        runloop = NSRunLoop.currentRunLoop()
    }

    // Show tips 
    @IBAction func onEditingChanged(sender: AnyObject) {
        if(timer != nil){
            timer.invalidate()
        }
        
        // Detect when user stops typing
        timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: ("showTips"), userInfo: nil, repeats: false)
        runloop.addTimer(timer, forMode: NSRunLoopCommonModes)
        
        // Prefix with $ sign
        if(first(billField.text) != "$"){
            billField.text = "$" + billField.text
        }
        
        billAmount = NSString(string: billField.text.substringFromIndex(advance(billField.text.startIndex, 1))).doubleValue
        totalAmount.text = String(format: "$%.2f", billAmount)
        
        billField.textAlignment = NSTextAlignment.Center
    }
    
    // Update tip and total amounts
    @IBAction func onChoseTip(sender: AnyObject) {
            
        pageTitle.text = "Here's your total."
        
        var tipPercentages = [0.18, 0.20, 0.25]
        var tipPercentage = 0.0
        
        if(tipControl.selectedSegmentIndex != UISegmentedControlNoSegment){
            tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        }
        
        var tip = billAmount * tipPercentage
        var total = billAmount + tip
        
        tipAmount.text = String(format: "$%.2f", tip)
        totalAmount.text = String(format: "$%.2f", total)

    }
    
    // Dismiss keypad when tapped outside
    @IBAction func onTap(sender:AnyObject){
        view.endEditing(true)
    }
    
    // Reset app to original state
    @IBAction func onClear(){
        reset()
        
        UIView.animateWithDuration(0.7, animations: {
            self.pageTitle.transform = CGAffineTransformMakeTranslation(0, 10)
            self.billField.transform = CGAffineTransformMakeTranslation(0, 10)
            self.tipSection.alpha = 0
            self.tipSection.transform = CGAffineTransformMakeTranslation(0, 40)
        })
    }
    
    // Reveal tips section when bill amount is entered
    func showTips(){
        if(timer != nil){
            timer.invalidate()
        }
        
        view.endEditing(true)
        pageTitle.text = "Choose your tip amount."
        
        UIView.animateWithDuration(0.7, animations: {
            self.pageTitle.transform = CGAffineTransformMakeTranslation(0, -40)
            self.billField.transform = CGAffineTransformMakeTranslation(0, -40)
            
            self.tipSection.alpha = 1
            self.tipSection.transform = CGAffineTransformMakeTranslation(0, -40)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

