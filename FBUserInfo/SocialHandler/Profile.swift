//
//  Profile.swift
//  FBUserInfo
//
//  Created by Mahendra Anand on 06/09/16.
//  Copyright © 2016 Aricent. All rights reserved.
//

import Foundation
import UIKit
class Profile: NSObject {

    var firstName:String!
    var lastName:String!
    var name:String!
    var timeZone:String!
    var imageURL:String!
    var email:String!
    var age:String!
    var dob:String!
    
    init(userInfo:NSDictionary) {
        
        super.init()
        
        let pictureDict = userInfo.objectForKey("picture")
        
        if pictureDict != nil &&  pictureDict is NSDictionary{
            
            let picture = pictureDict?.objectForKey("data")
            if picture != nil &&  picture is NSDictionary{
                
                let url = picture?.objectForKey("url") as? String
                if url != nil {
                    self.imageURL = url!
                }
            }
        }
        
        self.firstName = userInfo.objectForKey("first_name") as! String
        self.lastName  = userInfo.objectForKey("last_name") as! String
        self.name      = userInfo.objectForKey("name") as! String
        self.email     = userInfo.objectForKey("email") as! String
        self.dob       = userInfo.objectForKey("birthday") as! String
        
        self.timeZone  = userInfo.objectForKey("timezone")?.stringValue
        
        self.age =  self .calculateAgeOfUser(self.dob)
    }
    
    func calculateAgeOfUser(dateOfBirth:String) -> String {
        
        let birthDate = NSDate().dateFromString(dateOfBirth, format:  "MM/dd/yyyy")
        let age  = NSDate().yearsFromDate(birthDate)
        
        return String(age)
    }
}
