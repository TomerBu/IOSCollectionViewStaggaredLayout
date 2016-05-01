//
//  PinDataSource.swift
//  PinterestCustomLayoutDemo
//
//  Created by Tomer Buzaglo on 21/04/2016.
//  Copyright © 2016 iTomerBu. All rights reserved.
//

import UIKit

class PinDataSource {
    var pallete = [UIColor.orangeColor(), UIColor.blueColor(), UIColor.yellowColor(), UIColor.purpleColor(), UIColor.greenColor(), UIColor.redColor()]
    var colors = [UIColor]()
    
    init(){
        for i in 0..<16{
            colors.append(pallete[i % pallete.count])
        }
    }
}
