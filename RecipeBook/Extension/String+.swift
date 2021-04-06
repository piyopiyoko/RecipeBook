//
//  String+.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/09/02.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import Foundation

extension String {
    
    private var ns: NSString {
        return (self as NSString)
    }
    
    public var lastPathComponent: String {
        return ns.lastPathComponent
    }
}
