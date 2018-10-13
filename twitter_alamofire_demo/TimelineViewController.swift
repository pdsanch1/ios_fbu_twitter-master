//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Aristotle on 2018-08-11.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
// @objcMembers class
@objcMembers class TimelineViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet] = []
    var refreshControl: UIRefreshControl!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func logoutButton(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    
    @IBOutlet weak var logoutNavItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       //self.navigationController?.delegate = self
        //self.navigationController?.navigationController?.delegate = self
        //self.navigationController?.navigationBar.isHidden = false
       // view.addSubview(self.navigationController!.view)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.setToolbarHidden(false, animated: true)
        self.navigationController?.navigationItem.setRightBarButton(logoutNavItem, animated: true)

        //self.navigationController?.navigationBar.setItems([logoutButton], animated: true)
        
        // Do any additional setup after loading the view.
//        let addButton_1 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(logmeOutButton))
//        let addButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logmeOutButton))
//
        
        
//        self.navigationItem.rightBarButtonItem = addButton
        
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        // refresh control
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControl.Event.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("<><> Error getting home timeline: " + error.localizedDescription)
            }
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {

        //self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Home"
        
        //self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    // refresh controll
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                // Tell the refreshControl to stop spinning
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
    }
    
    // ComposeViewControllerDelegate protocol method
    func did(post: Tweet) {
        refreshControlAction(refreshControl)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
