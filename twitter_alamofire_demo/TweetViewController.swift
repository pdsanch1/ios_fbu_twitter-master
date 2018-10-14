//
//  TweetViewController.swift
//  twitter_alamofire_demo
//
//  Created by Pedro Daniel Sanchez on 10/13/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

@objcMembers class TweetViewController: UIViewController {
    
    var tweet: Tweet!
    
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var tweetTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var retweetButtonOutlet: UIButton!
    @IBOutlet weak var favoriteButtonOutlet: UIButton!
    
    @IBAction func replyButton(_ sender: Any) {
    }
    
    @IBAction func composeTweetButton(_ sender: Any) {
    }
    
    @IBAction func retweetButton(_ sender: Any) {
        if tweet.retweeted {
            APIManager.shared.unRetweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error retweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    self.tweet.retweeted = false
                    self.tweet.retweetCount -= 1
                    self.loadData()
                }
            }
        } else {
            APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error retweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    self.tweet.retweeted = true
                    self.tweet.retweetCount += 1
                    self.loadData()
                }
            }
        }
    }
    @IBAction func favoriteButton(_ sender: Any) {
        if tweet.favorited {
            APIManager.shared.unFavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    self.tweet.favorited = false
                    self.tweet.favoriteCount -= 1
                    self.loadData()
                }
            }
        } else {
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    self.tweet.favorited = true
                    self.tweet.favoriteCount += 1
                    self.loadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // Hoy
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.setToolbarHidden(false, animated: true)
        
        let addButton = UIBarButtonItem(title: "Reply", style: .done, target: self, action: #selector(composeTweetButton))
        
        self.navigationItem.rightBarButtonItem = addButton
        
        
        
        
        loadData()
    }
    
    
    func loadData() {
        tweetTextField.text = tweet.text
        nameLabel.text = tweet.user.name
        createdDateLabel.text = tweet.createdAtString
        screenNameLabel.text = "@" + tweet.user.screenName
        profileImageView.af_setImage(withURL: tweet.user.profileImageUrl)
        if tweet.favorited {
            favoriteButtonOutlet.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        } else {
            favoriteButtonOutlet.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
        if tweet.retweeted {
            retweetButtonOutlet.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
        } else {
            retweetButtonOutlet.setImage(UIImage(named: "retweet-icon"), for: .normal)
        }
        retweetCountLabel.text = String(describing: tweet.retweetCount)
        favoriteCountLabel.text = String(describing: tweet.favoriteCount)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.setToolbarHidden(false, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
