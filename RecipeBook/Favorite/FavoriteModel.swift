//
//  FavoriteModel.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/08/05.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import Foundation

struct FavoriteModel: AnyObjectModel {
    var order = 0
    var url = ""
    var title = ""
    var imgPath = ""
    
    init(obj: AnyObject) {
        order = obj.value(forKey: "order") as? Int ?? 0
        url = obj.value(forKey: "url") as? String ?? ""
        title = obj.value(forKey: "title") as? String ?? ""
        imgPath = obj.value(forKey: "imgPath") as? String ?? ""
    }
}
