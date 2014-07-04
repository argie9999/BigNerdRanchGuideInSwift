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
    var courses: NSArray

    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        courses = []
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(style: UITableViewStyle)
    {
        self.init(nibName: nil, bundle: nil)

        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config, delegate: nil, delegateQueue: nil)
        navigationItem.title = "Courses"
        courses = []
        fetchFeed()
    }

    func fetchFeed()
    {
        if session {
            let requestString = "http://bookapi.bignerdranch.com/courses.json"
            let url = NSURL(string: requestString)
            let request = NSURLRequest(URL: url)
            let dataTask = session!.dataTaskWithRequest(request) {
                (data, _, _) in
                let jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.courses = jsonObject["courses"] as NSArray

                println(self.courses)

                // Reload table view data on the main thread
                dispatch_async(dispatch_get_main_queue()) { self.tableView.reloadData() }
            }
            dataTask.resume()
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
    }

    // MARK: UITableViewController methods
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return courses.count
    }

    override func tableView(tableView: UITableView!,
        cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        let course = courses[indexPath.row] as NSDictionary
        cell.textLabel.text = course["title"] as String

        return cell
    }
}
