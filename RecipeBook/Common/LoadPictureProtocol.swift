//
//  LoadPictureProtocol.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/09/09.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import Foundation

protocol LoadPictureProtocol {
    func load(path: String) -> Data?
}

extension LoadPictureProtocol {
    
    func load(path: String) -> Data? {
        let data = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        return FileManager.default.contents(atPath: data + "/image/" + path)
    }
}
