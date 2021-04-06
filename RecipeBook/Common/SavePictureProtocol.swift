//
//  SavePictureProtocol.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/09/02.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import UIKit

protocol SavePictureProtocol {
    func save(image : UIImage, updatePath : String?) -> String?
}

extension SavePictureProtocol {
    func save(image: UIImage, updatePath: String?) -> String? {
        guard let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first else { return "" }
        let newPath = path + "/image"
        do {
            try FileManager.default.createDirectory(atPath: newPath, withIntermediateDirectories: true, attributes: nil)
            
        } catch {
            return nil
        }
        
        // 画像保存
        var fileName = ""
        if let updatePath = updatePath {
            fileName = updatePath
        }
        else {
            fileName = getNowClockString()
        }
        let savePath = newPath + "/" + fileName + ".png"
        if let data = crop(image: image)?.pngData() {
            FileManager.default.createFile(atPath: savePath, contents: data, attributes: nil)
        }
        return savePath.lastPathComponent
    }
    
    private func crop(image: UIImage) -> UIImage? {
        guard let img = image.cgImage,
        let cropImage = img.cropping(to: CGRect(x: 0, y: 0, width: img.width, height: img.width))
            else { return nil }
        
        return UIImage(cgImage: cropImage)
    }
    
    private func getNowClockString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let now = Date()
        return formatter.string(from: now)
    }
}
