//
//  Line.swift
//  TouchTracker
//
//  Created by ajh17 on 6/25/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit

class Line: Equatable {
    var begin: CGPoint
    var end: CGPoint
    var thickness: Double
    var color: UIColor

    init(begin: CGPoint, end: CGPoint) {
        self.begin = begin
        self.end = end
        thickness = 1.0
        color = UIColor.blackColor()
    }
}

// MARK: Equatable protocol
func == (lhs: Line, rhs: Line) -> Bool {
    if lhs.begin == rhs.begin && lhs.end == rhs.end {
        return true
    }
    return false
}
