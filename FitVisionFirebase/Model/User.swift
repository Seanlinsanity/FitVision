//
//  User.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class UserModel: NSObject {

    @objc var name: String?{
        didSet{
            self.userAbbreviation = ""
            
            if let componentOfName = name?.components(separatedBy: " "){
                
                if componentOfName.count > 2 {
                    let firstName = componentOfName[0]
                    let secondName = componentOfName[1]
                    if firstName != ""{
                        self.userAbbreviation += String(firstName[firstName.startIndex])
                    }
                    if secondName != ""{
                        self.userAbbreviation += String(secondName[secondName.startIndex])

                    }
                    
                }else{
                    
                    for name in componentOfName{
                        if name != ""{
                            self.userAbbreviation += String(name[name.startIndex])
                        }
                    }
                }
            }
            
        }
    }
    
    var userAbbreviation = ""
    @objc var email: String?
    var profileImageUrl: String?
    
}
