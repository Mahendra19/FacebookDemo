//
//  SocialHandler.swift
//  FBUserInfo
//
//  Created by Mahendra Anand on 06/09/16.
//  Copyright © 2016 Aricent. All rights reserved.
//

import Foundation
import UIKit
import Social
import Accounts


// NSDate Extention to calculate 2 dates difference in years/months/weeks/days/hours/minutes/seconds

extension NSDate {
    func dateFromString(date: String, format: String) -> NSDate {
        let formatter = NSDateFormatter()
        let locale = NSLocale.currentLocale()
        
        formatter.locale = locale
        formatter.dateFormat = format
        return formatter.dateFromString(date)!
    }
    
    func yearsFromDate(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFromDate(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFromDate(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFromDate(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFromDate(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFromDate(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFromDate(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
}


let API_KEY_FB:String = "1088895414527460"

let FB_PERMISSSIONS:Array = ["public_profile", "email"]

// this enum will be usefull when using same class to access multiple social
//accounts//
public enum LoginType:Int {
    case LOGIN_FB = 0
    case LOGIN_NONE
}

class SocialHandler: NSObject {

    //static let sharedInstance = SocialHandler(type: .LOGIN_NONE)
    var loginType:LoginType = .LOGIN_NONE
    var account:ACAccount!
    var outh_Token:String!
    let store = ACAccountStore()
    
    init(type:LoginType) {
        
        super.init()
        self.loginType = type
        
    }
    

    func login(completion: (credential: ACAccountCredential?) -> Void) {
        
        var accountType:ACAccountType = store.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
        var appId = API_KEY_FB
        
        if self.loginType == .LOGIN_FB { //This condition will be usefull when writing generalised function//
            
            accountType = store.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
            appId = API_KEY_FB
            
            let loginParameters = [
                "ACFacebookAppIdKey" : appId,
                "ACFacebookPermissionsKey" : FB_PERMISSSIONS,
                "ACFacebookAudienceKey" : ACFacebookAudienceOnlyMe]
            
            store.requestAccessToAccountsWithType(accountType, options: loginParameters as [NSObject : AnyObject]) { granted, error in
                if granted {
                    let accounts = self.store.accountsWithAccountType(accountType)
                    self.account = accounts.last as? ACAccount
                    
                    let credentials = self.account?.credential
                    completion(credential: credentials)
                } else {
                     print("Error : \(error.localizedDescription)")
                    completion(credential: nil)
                }
            }
        }
        else if (self.loginType == .LOGIN_NONE){
            print("Login None")
        }
        
    }
    
    
    func getUserInfo(completion: (userInfo: Profile?) -> Void) {
        
        self.login { (credential) in
            
            if (credential != nil){
                
                var parameters = Dictionary<String, AnyObject>()
                parameters["access_token"] = credential!.oauthToken
                parameters["fields"] = "id, name, email, picture, first_name, last_name, gender, birthday, timezone"
                
                let infoURL = NSURL(string:
                    "https://graph.facebook.com/me/")
                
                let getRequest = SLRequest(forServiceType: SLServiceTypeFacebook, requestMethod: SLRequestMethod.GET, URL: infoURL, parameters: parameters)
                getRequest.account = self.socialAccount(self.store)
                
                getRequest.performRequestWithHandler(
                    {
                        (responseData: NSData!,
                        urlResponse: NSHTTPURLResponse!,
                        error: NSError!) -> Void in
                        
                        print("HTTP response \(urlResponse.statusCode)")
                        if(error == nil && urlResponse.statusCode == 200){
                            
                            do
                            {
                                let responseData = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                                
                                print("response date  : \(responseData)" )
                                
                                let profile = Profile(userInfo: responseData)
                                completion(userInfo: profile)
                            }
                            catch
                            {
                                completion(userInfo: nil)
                            }
                        }else{
                            completion(userInfo: nil)
                        }
                })
            }
            else{
                print("Need to add facebook account in settings applciation of device");
            }
        }
    }
    
    
    //MARK: - Private functions
    private func socialAccount(accountStore: ACAccountStore) -> ACAccount? {
        return accountStore.accountsWithAccountType(facebookAccountType(accountStore)).last as? ACAccount
    }
    
    private func accountProperties(accountStore: ACAccountStore) -> NSDictionary? {
        if let currentSocialAccount = socialAccount(accountStore) {
            currentSocialAccount.valueForKey("properties") as? NSDictionary
        }
        
        return nil
    }
    
    private func facebookAccountType(accountStore: ACAccountStore) -> ACAccountType {
        return accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
    }
    
    
}
