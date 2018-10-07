//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Pedro Daniel Sanchez on 10/6/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import Foundation

class User {
    
    var name: String
    var screenName: String
    var profileImageUrl: URL
    var followersCount: Int
    var followingsCount: Int
    var backgroundImageUrl: URL
    // for persisting user
    var dictionary: [String: Any]?
    private static var _current: User?
    static var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary: dictionary)
                }
            }
            return _current
        }
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
    
    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
        name = dictionary["name"] as! String
        screenName = dictionary["screen_name"] as! String
        profileImageUrl = URL(string: dictionary["profile_image_url_https"] as! String)!
        backgroundImageUrl = profileImageUrl
//        backgroundImageUrl = URL(string: dictionary["profile_background_image_url_https"] as! String)!
        followersCount = dictionary["followers_count"] as! Int
        followingsCount = dictionary["friends_count"] as! Int
    }
}
