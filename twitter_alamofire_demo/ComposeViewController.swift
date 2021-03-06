//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Pedro Daniel Sanchez on 10/13/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

protocol ComposeViewControllerDelegate {
    func did(post: Tweet)
}

class ComposeViewController: UIViewController, UITextViewDelegate {

    
    var tweet: Tweet!
    
    @IBOutlet weak var photoImageView: UIImageView!

    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var charCountLabel: UILabel!
    
    var user = User.current!
    weak var delegate: TimelineViewController?
    
    
    @IBAction func tweetButton(_ sender: Any) {
        APIManager.shared.composeTweet(with: textView.text) { (tweet, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Error Tweeting", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textView.delegate = self
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.setToolbarHidden(false, animated: true)
        
        let cancellButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButton))
        
        self.navigationItem.leftBarButtonItem = cancellButton
        
        
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 15.0
        textView.backgroundColor = UIColor.lightGray

        
        photoImageView.af_setImage(withURL: tweet.user.profileImageUrl)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    // Set the max character limit
    let characterLimit = 140
    
    // Construct what the new text would be if we allowed the user's latest edit
    let newText = NSString(string: self.textView.text!).replacingCharacters(in: range, with: text)
    
    // to handle user pasting over the character limit
    if newText.count > 140 {
    charCountLabel.text = "140"
    } else {
    charCountLabel.text = "\(140 - newText.count)"
    }
    
    // The new text should be allowed? True/False
    return newText.count < characterLimit
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
