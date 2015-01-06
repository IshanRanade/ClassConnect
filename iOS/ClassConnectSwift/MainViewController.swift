//
//  MainViewController.swift
//  ClassConnectSwift
//
//  Created by Ishan Ranade on 12/25/14.
//  Copyright (c) 2014 Ishan Sanjay Ranade. All rights reserved.
//

import UIKit
import Parse

class MainViewController: UIViewController {
    //let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*var testObject = PFObject(className: "TestObject")
        testObject.saveInBackgroundWithTarget(nil, selector: nil)
        for universityName in universitiesArray {
            var course1 = PFObject(className: "Bob")
            var university = PFObject(className: "University")
            university["universityName"] = universityName
            university.saveInBackgroundWithTarget(nil, selector: nil)
            
            for departmentName in departmentsArray {
                var department = PFObject(className: "Department")
                department["departmentName"] = departmentName
                var departmentRelation = university.relationForKey("departments")
                departmentRelation.addObject(department)
                university.saveInBackgroundWithTarget(nil, selector: nil)
                
                for courseName in coursesArray {
                    var course = PFObject(className: "Course")
                    course["courseName"] = courseName
                    course.saveInBackgroundWithTarget(nil, selector: nil)
                    /*var courseRelation = department.relationForKey("courses")
                    department.saveInBackgroundWithTarget(nil, selector: nil)
                    courseRelation.addObject(course)
                    department.saveInBackgroundWithTarget(nil, selector: nil)
                    course.saveInBackgroundWithTarget(nil, selector: nil)*/
                }
            }
            university.saveInBackgroundWithTarget(nil, selector: nil)
        }*/
        
        /*var universityQuery = PFQuery(className: "University")
        universityQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if(error == nil) {
                for universityObject in objects {
                    var relation = universityObject.relationForKey("departments")
                    relation.query().findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]!, error: NSError!) -> Void in
                        if(error == nil) {
                            for departmentObject in objects {
                                println(departmentObject["departmentName"])
                            }
                        }
                    }
                }
            }
        }*/
        
        //PFCloud.callFunctionInBackground(nil, withParameters: nil, block: nil)
        /*PFCloud.callFunctionInBackground("hello", withParameters: [:]) {
                (result: AnyObject!, error: NSError!) -> Void in
                println("hello")
        }
        var object = PFObject(className: "Object")*/
        
        /*PFCloud.callFunctionInBackground("createClassesDatabase", withParameters: [:]) {
            (result: AnyObject!, error: NSError!) -> Void in
            println(result)
        }*/
        /*let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("allCoursesJSON", ofType: "txt")
     
        if((path) != nil) {
            println("found path")
        } else {
            println("no path")
        }
        
        var content = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
        */
        /*var err: NSError?
        PFCloud.callFunctionInBackground("returnAllUniversities", withParameters: ["universityName": "University of Washington"]) {
            (result: AnyObject!, error: NSError!) -> Void in
            println()
            println(result)
            let result = PFObject()
            //println(result["universityName"])
            /*var jsonResult = NSJSONSerialization.JSONObjectWithData(result as NSData, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if(err != nil) {
                println("problem")
            }
            println(jsonResult)*/
        }*/
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func returnToMainView(sender: UIStoryboardSegue) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

