//
//  CoursesViewController.swift
//  Nerdfeed
//
//  Created by Akshay Hegde on 7/2/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit

class CoursesViewController: UITableViewController, NSURLSessionDataDelegate {

    var session: NSURLSession?
    var courses: NSArray
    var webViewController: WebViewController?

    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        courses = []
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(style: UITableViewStyle) {
        self.init(nibName: nil, bundle: nil)

        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        navigationItem.title = "Courses"
        courses = []
        fetchFeed()
    }

    func fetchFeed() {
        if session {
            // the secure url given in the book is actually https://bookapi.bignerdranch.com/private/courses.json
            // but that doesn't seem to work :|
            let requestString = "https://bookapi.bignerdranch.com/courses.json"
            let url = NSURL(string: requestString)
            let request = NSURLRequest(URL: url)
            let dataTask = session!.dataTaskWithRequest(request) {
                (data, _, _) in
                let jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.courses = jsonObject["courses"] as Array<Dictionary<String, String>>

                println(self.courses)

                // Reload table view data on the main thread
                dispatch_async(dispatch_get_main_queue()) { self.tableView.reloadData() }
            }
            dataTask.resume()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
    }

    // MARK: UITableViewController methods
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    override func tableView(tableView: UITableView!,
        cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
            let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
            let course = courses[indexPath.row] as NSDictionary
            cell.textLabel.text = course["title"] as String

            return cell
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let course = courses[indexPath.row] as Dictionary<String, String>
        let url = NSURL(string: course["url"])

        webViewController!.title = course["title"]
        webViewController!.URL = url
        navigationController.pushViewController(webViewController, animated: true)
    }

    // NSURLSessionDataDelegate methods
    func URLSession(session: NSURLSession!, didReceiveChallenge challenge: NSURLAuthenticationChallenge!,
        completionHandler: ((NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void)!)
    {
        let cred = NSURLCredential(user: "BigNerdRanch", password: "AchieveNerdvana", persistence: .ForSession)
        completionHandler(.UseCredential, cred)
    }
}
