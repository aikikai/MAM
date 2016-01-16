//
//  colorExtension.swift
//  MurAndMarti
//
//  Created by Luciano Wehrli on 15/1/16.
//  Copyright © 2016 Luciano Wehrli. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    
    static func RGBColor (red red:CGFloat, green:CGFloat, blue:CGFloat) -> UIColor{
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
    static func RGBColor (red red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat) -> UIColor{
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}