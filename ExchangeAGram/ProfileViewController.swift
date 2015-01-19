//
//  ProfileViewController.swift
//  ExchangeAGram
//
//  Created by Clint on 1/18/15.
//  Copyright (c) 2015 Republic. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, FBLoginViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var fbLoginView: FBLoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "publish_actions"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //these 4 functions are needed to conform to the FBloginviewdelegate class
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        
        profileImageView.hidden = false
        nameLabel.hidden = false
        
    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        //this function is called after we're successfully logged in and FB sends us info about user
        //we get a 'user' from facebook and we use their objectID to get their photo into a URL
        //we pull the contens from teh URL and convert it using UIImage
        
        println(user)
        
        nameLabel.text = user.name
        
        let userImageURL = "https://graph.facebook.com/\(user.objectID)/picture?type=small"
        let url = NSURL(string: userImageURL)
        //this is just image data that needs to be converted
        let imageData = NSData(contentsOfURL: url!)
        let image = UIImage(data: imageData!)
        profileImageView.image = image
        
        
        
    }
    
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        profileImageView.hidden = true
        nameLabel.hidden = true
    }
    
    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        //handles errors by just printing it out
        println("Error: \(error.localizedDescription)")
    }
    

    
}
