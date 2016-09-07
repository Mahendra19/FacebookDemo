//
//  ViewController.swift
//  FBUserInfo
//
//  Created by Mahendra Anand on 06/09/16.
//  Copyright © 2016 Aricent. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginwithFBButton1:UIButton!
    @IBOutlet weak var loginwithFBButton2:UIButton!
    
    var socialHandler:SocialHandler = SocialHandler(type: .LOGIN_FB)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    
    @IBAction func loginWithFB1(sender:UIButton){
        
        self.socialHandler.getUserInfo { (userInfo) in
            
            dispatch_async(dispatch_get_main_queue(), { 
                let detailViewController:DetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
                
                
                detailViewController.profileInfo = userInfo
                self.navigationController?.pushViewController(detailViewController, animated: true)
            })
        }
        
    }
    
    @IBAction func loginWithFB2(sender:UIButton){

        self.socialHandler.getUserInfo { (userInfo) in
            print("user info == \(userInfo!)")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
}

