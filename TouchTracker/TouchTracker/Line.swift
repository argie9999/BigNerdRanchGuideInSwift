//
//  Line.swift
//  TouchTracker
//
//  Created by ajh17 on 6/25/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit

class Line {
    var begin: CGPoint
    var end: CGPoint

    init(begin: CGPoint, end: CGPoint) {
        self.begin = begin
        self.end = end
    }
}