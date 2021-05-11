//
//  GifAnimateView.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2021/04/16.
//  Copyright © 2021 Aimi Itagaki. All rights reserved.
//

import UIKit
import WebKit

class GifAnimateView: WKWebView {

    private var data: Data?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }

    private override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        self.initialize()
    }
    
    func load(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "gif") else { return }
        guard let gifData = NSData(contentsOf: url) else { return }
        self.data = gifData as Data
    }

    private func initialize() {
        self.scrollView.isScrollEnabled = false
        self.scrollView.isUserInteractionEnabled = false
    }
    
    func startAnimate() {
        guard let data = self.data else { return }
        self.load(data, mimeType: "image/gif", characterEncodingName: "utf-8", baseURL: NSURL() as URL)
    }
    
    func clear() {
        guard let url = URL(string: "about:blank") else { return }
        self.load(URLRequest(url: url))
    }
}
