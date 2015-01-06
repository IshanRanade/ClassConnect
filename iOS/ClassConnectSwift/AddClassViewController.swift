//
//  AddClassViewController.swift
//  ClassConnectSwift
//
//  Created by Ishan Ranade on 12/25/14.
//  Copyright (c) 2014 Ishan Sanjay Ranade. All rights reserved.
//

import UIKit
import Parse
import Foundation

class AddClassViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var universityPickerData:[String] = []
    var departmentPickerData:[String] = []
    var coursePickerData:[String] = []
    
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var universityButton: UIButton!
    @IBOutlet var departmentButton: UIButton!
    @IBOutlet var courseButton: UIButton!
    
    var universityPickerChosen = false
    var departmentPickerChosen = false
    var coursePickerChosen = false
    
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set the delegate and data source of the picker
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        //Hide the pickerview to start out
        self.pickerView.hidden = true
        
        //When the page loads, the Department and Course buttons are disabled
        self.departmentButton.enabled = false
        self.courseButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func loadUniversityPickerData(sender: AnyObject) {
        if(self.selectedRow == self.pickerView.selectedRowInComponent(0)) {
            //Initially hide the picker view until data is loaded
            self.pickerView.hidden = true
            
            //Set the booleans to know which picker data should be loaded up
            universityPickerChosen = true
            departmentPickerChosen = false
            coursePickerChosen = false
            
            //Reset the course button but keep it disabled
            courseButton.setTitle("Choose Course", forState: UIControlState.Normal)
            courseButton.enabled = false
            
            //Initially disable the department button until data is loaded
            departmentButton.setTitle("Choose Department", forState: UIControlState.Normal)
            departmentButton.enabled = false
            
            //Get the data for all the available universities
            var err: NSError?
            PFCloud.callFunctionInBackground("returnAllUniversities", withParameters: [:]) {
                (result: AnyObject!, error: NSError!) -> Void in
                
                if(error == nil) {
                    var jsonStr = result as String // JSON string
                    var data = jsonStr.dataUsingEncoding(NSUTF16StringEncoding)
                    var jsonError: NSError?
                    var jsonObject:AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as [AnyObject]
                    
                    self.universityPickerData.removeAll(keepCapacity: false)
                    //Load up the data for the universities
                    if let mainArray = jsonObject as? NSArray {
                        for var i = 0; i < mainArray.count; i++ {
                            if let university = mainArray[i] as? NSDictionary {
                                self.universityPickerData.append(university["universityName"] as String)
                            }
                        }
                    }
                    
                    //Sort the array of universities
                    self.universityPickerData = self.universityPickerData.sorted(<)
                }
                
                //Take care of the case in which nothing is returned and there is an error
                if(self.universityPickerData.count == 0) {
                    self.universityPickerData.append("Network Error")
                }
                
                //Because the initial selection does not change the text of the button, do it manually
                //Also, make it go back up to the first row
                self.universityButton.setTitle(self.universityPickerData[0], forState: UIControlState.Normal)
                
                self.pickerView.reloadAllComponents()
                self.pickerView.selectRow(0, inComponent: 0, animated: true)
                self.selectedRow = 0
                
                //Unhide the picker view
                self.pickerView.hidden = false
                
                //Enable the department button but reset its value
                self.departmentButton.enabled = true
            }
        }
    }

    @IBAction func loadDepartmentPickerData(sender: AnyObject) {
        if(self.selectedRow == self.pickerView.selectedRowInComponent(0)) {

            //Initially hide the picker view until data is loaded
            self.pickerView.hidden = true
            
            universityPickerChosen = false
            departmentPickerChosen = true
            coursePickerChosen = false
            
            //Initially disable the course button until data is loaded
            self.courseButton.enabled = false
            self.courseButton.setTitle("Choose Course", forState: UIControlState.Normal)
            
            PFCloud.callFunctionInBackground("returnDepartmentsForUniversity", withParameters: ["university":self.universityButton.titleForState(UIControlState.Normal)!]) {
                (result: AnyObject!, error: NSError!) -> Void in
                
                if(error == nil) {
                    var jsonStr = result as String // JSON string
                    var data = jsonStr.dataUsingEncoding(NSUTF16StringEncoding)
                    var jsonError: NSError?
                    var jsonObject:AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as [AnyObject]
                    
                    self.departmentPickerData.removeAll(keepCapacity: false)
                    //Load up the data for the departments
                    if let mainArray = jsonObject as? NSArray {
                        for var i = 0; i < mainArray.count; i++ {
                            if let university = mainArray[i] as? NSDictionary {
                                self.departmentPickerData.append(university["departmentName"] as String)
                            }
                        }
                    }
                    
                    //Sort the array of departments
                    self.departmentPickerData = self.departmentPickerData.sorted(<)
                }
                
                //Take care of the case in which nothing is returned and there is an error
                if(self.departmentPickerData.count == 0) {
                    self.departmentPickerData.append("Network Error")
                }
                
                //Because the initial selection does not change the text of the button, do it manually
                self.departmentButton.setTitle(self.departmentPickerData[0] as String, forState: UIControlState.Normal)
                
                self.pickerView.reloadAllComponents()
                self.pickerView.selectRow(0, inComponent: 0, animated: true)
                self.selectedRow = 0
                
                //Unhide the picker view
                self.pickerView.hidden = false
                
                //Also enable the course button now
                self.courseButton.enabled = true
            }
        }
    }
    
    @IBAction func loadCoursePickerData(sender: AnyObject) {
        if(self.selectedRow == self.pickerView.selectedRowInComponent(0)) {

            //Initially hide the picker view until data is loaded
            self.pickerView.hidden = true
            
            universityPickerChosen = false
            departmentPickerChosen = false
            coursePickerChosen = true

            PFCloud.callFunctionInBackground("returnSpecificDepartment", withParameters: ["university":self.universityButton.titleForState(UIControlState.Normal)!, "department":self.departmentButton.titleForState(UIControlState.Normal)!]) {
                (result: AnyObject!, error: NSError!) -> Void in
                
                if(error == nil) {
                    var jsonStr = result as String // JSON string
                    var data = jsonStr.dataUsingEncoding(NSUTF16StringEncoding)
                    var jsonError: NSError?
                    var jsonObject:AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as [AnyObject]
                    
                    self.coursePickerData.removeAll(keepCapacity: false)
                    //Load up the data for the departments
                    if let mainArray = jsonObject as? NSArray {
                        if let department = mainArray[0] as? NSDictionary {
                            if let courses = department["courses"] as? NSArray {
                                for var i = 0; i < courses.count; i++ {
                                    let course = String(courses[i] as NSInteger as CLong as Int)
                                    self.coursePickerData.append(course)
                                }
                            }
                        }
                    }
                    
                    //Sort the array of classes
                    self.coursePickerData = self.coursePickerData.sorted(<)
                }
                
                //Take care of the case in which nothing is returned and there is an error
                if(self.coursePickerData.count == 0) {
                    self.coursePickerData.append("None")
                }
                
                //Because the initial selection does not change the text of the button, do it manually
                self.courseButton.setTitle(self.coursePickerData[0] as String, forState: UIControlState.Normal)
                
                self.pickerView.reloadAllComponents()
                self.pickerView.selectRow(0, inComponent: 0, animated: true)
                self.selectedRow = 0
                
                //Unhide the picker view
                self.pickerView.hidden = false
            }
        }
    }
    
    
    //Picker code
    //The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //The number of rows per column
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(self.universityPickerChosen) {
            return self.universityPickerData.count
        } else if(self.departmentPickerChosen) {
            return self.departmentPickerData.count
        } else if(self.coursePickerChosen) {
            return self.coursePickerData.count
        } else {
            return 0
        }
    }
    
    //The values in each row
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if(self.universityPickerChosen) {
            return self.universityPickerData[row] as String
        } else if(self.departmentPickerChosen) {
            return self.departmentPickerData[row] as String
        } else if(self.coursePickerChosen) {
            return self.coursePickerData[row] as String
        }
        return nil
    }
    
    //Change the button text based on selection to let user know what is chosen
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row
        if(self.universityPickerChosen) {
            self.universityButton.setTitle(self.universityPickerData[row] as String, forState: UIControlState.Normal)
        } else if(self.departmentPickerChosen) {
            self.departmentButton.setTitle(self.departmentPickerData[row] as String, forState: UIControlState.Normal)
        } else if(self.coursePickerChosen) {
            self.courseButton.setTitle(self.coursePickerData[row] as String, forState: UIControlState.Normal)
        }
    }
}