//
//  DetailViewController.swift
//  FBUserInfo
//
//  Created by Mahendra Anand on 06/09/16.
//  Copyright © 2016 Aricent. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    internal var profileInfo:Profile!
    
    @IBOutlet weak var lblFirstName:UILabel!
    @IBOutlet weak var lblLastName:UILabel!
    @IBOutlet weak var lblTimeZone:UILabel!
    @IBOutlet weak var lblEmail:UILabel!
    @IBOutlet weak var lblAge:UILabel!
    @IBOutlet weak var profileImageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initiazeData()
    }
    
    
    func initiazeData() {
        
        self.title = "User Info"
        self.lblFirstName.text = profileInfo.firstName
        self.lblLastName.text = profileInfo.lastName
        self.lblEmail.text = profileInfo.email
        self.lblTimeZone.text = profileInfo.timeZone
        self.lblAge.text = profileInfo.age
        
        self.loadImageWithURL(self.profileInfo.imageURL!)

    }
    
    
    func loadImageWithURL(urlString:String){
        
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true) as NSArray
        let cacheDirectory = paths[0] as! String
        let path = (cacheDirectory as NSString).stringByAppendingPathComponent(urlString.stringByReplacingOccurrencesOfString("/", withString: "_"))
        
        let fileManager = NSFileManager.defaultManager()
        if(!fileManager.fileExistsAtPath(path)) {
            
            let url = NSURL(string: urlString)!
            let request:NSURLRequest = NSURLRequest(URL:url)
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
                let httpResponse = response as! NSHTTPURLResponse
                if(error == nil && httpResponse.statusCode == 200){
                    if(data != nil){
                        
                        do{
                            let result = try Bool(data!.writeToFile(path, options: NSDataWritingOptions.DataWritingAtomic))
                            print("file written successfully : \(result)")
                        }
                        catch let error as NSError {
                            print(error.localizedDescription)
                        }

                        let image : UIImage = UIImage(data: data!)!
                        
                        self.profileImageView.image = image
                    }else{}
                    
                }else{}
            });
            task.resume()
        }
        else {
            let image = UIImage(contentsOfFile: path)
            self.profileImageView.image = image
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
