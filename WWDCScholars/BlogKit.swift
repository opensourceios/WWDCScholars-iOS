//
//  BlogKit.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 15/04/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation

class BlogKit {
    
    /// Server URL of the database (with API) where the blog posts are saved
    var scholarsServerURL = "http://wwdcscholarsadmin.herokuapp.com"
    
    /// Shared Instance of the BlogKit
    static let sharedInstance = BlogKit()
    
    let dbManager = DatabaseManager.sharedInstance
    
    private init() {
    }
    
    /**
     Loads all blog posts from the online database
     */
    func loadBlogPosts(completionHandler: () -> Void) {
        request(.GET, "https://wwdcscholarsadmin.herokuapp.com/api/posts")
            .responseString() { response in
                if let data = response.result.value {
//                    print (data)
                    let json = JSON.parse(data)
//                    print("JSON: \(json)")
                    if let array = json.array {
                        self.parseBlogPosts(array)
                        completionHandler()
                    }
                }
        }
    }
    
    func parseBlogPosts(jsonArr: [JSON]) {
        for postJson in jsonArr {
            if let post = parseBlogPost(postJson) {
                dbManager.addBlogPost(post)
            }else {
                print("BlogPost (with id \(postJson["_id"].string)) missing items!")
            }
        }
    }
    
    func parseBlogPost(json: JSON) -> BlogPost? {
        if let id = json["_id"].string {
            return nil
        }else {
            return nil
        }
    }
}