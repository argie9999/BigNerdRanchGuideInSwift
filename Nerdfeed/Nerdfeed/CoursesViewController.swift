//
//  CoursesViewController.swift
//  Nerdfeed
//
//  Created by Akshay Hegde on 7/2/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit

class CoursesViewController: UITableViewController {

     var session: NSURLSession?

    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(style: UITableViewStyle)
    {
        self.init(nibName: nil, bundle: nil)

        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config, delegate: nil, delegateQueue: nil)
        navigationItem.title = "BNR Courses"
        fetchFeed()
    }

    func fetchFeed()
    {
        if session {
            let requestString = "http://bookapi.bignerdranch.com/courses.json"
            let url = NSURL(string: requestString)
            let request = NSURLRequest(URL: url)
            let dataTask = session!.dataTaskWithRequest(request) {
                (data: NSData!, _: NSURLResponse!, _: NSError!) in
                let jsonObject: AnyObject! = NSJSONSerialization.JSONObjectWithData(data,
                    options: nil, error: nil)

                println(jsonObject)
            }
            dataTask.resume()
        }
    }

    // MARK: UITableViewController methods
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }

    override func tableView(tableView: UITableView!,
        cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        return nil
    }
}
