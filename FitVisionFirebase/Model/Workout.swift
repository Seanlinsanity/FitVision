//
//  Workout.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/4/9.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

struct Workout {
    var day: String?
    var videoId: String?
    var dayOrder: NSNumber?{
        if day == "週一"{
            return 2
        }else if day == "週二"{
            return 3
        }else if day == "週三"{
            return 4
        }else if day == "週四"{
            return 5
        }else if day == "週五"{
            return 6
        }else if day == "週六"{
            return 7
        }else if day == "週日"{
            return 1
        }else{
            return 2
        }
    }
    
    init(day: String?, videoId: String?) {
        self.day = day
        self.videoId = videoId
    }
    
}

