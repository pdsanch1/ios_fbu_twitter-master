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
    
   // var selectedIndexPath: IndexPath? // for TweetController
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func logoutButton(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        // Hoy
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.setToolbarHidden(false, animated: true)

        let addButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutButton))

        self.navigationItem.rightBarButtonItem = addButton
        
        
        
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


        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Home"
        
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let tweetController = segue.destination as! TweetViewController
            tweetController.tweet = tweets[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
            //selectedIndexPath = indexPath
            
        }
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
