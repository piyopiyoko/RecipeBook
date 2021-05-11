//
//  TimeUpViewController.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2021/04/19.
//  Copyright © 2021 Aimi Itagaki. All rights reserved.
//

import UIKit

final class TimeUpViewController: UIViewController {
    
    @IBOutlet weak var timeUpLabel: UILabel!
    @IBOutlet weak var gifWebView: GifAnimateView!
    
    private var countDownTime: String?
    private let audioPlayer = AudioPlayer()
    
    static func initTimeUpViewController(transitioningDelegate: UIViewControllerTransitioningDelegate?, countDownTime: String?) -> TimeUpViewController? {
        guard let modalViewController = R.storyboard.main.timeUpViewController() else { return nil }
        modalViewController.modalPresentationStyle = .custom
        modalViewController.transitioningDelegate = transitioningDelegate
        modalViewController.countDownTime = countDownTime
        return modalViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer?.playSound()
        initTimeUpLabel()
        initGifView()
    }
    
    @IBAction func tapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func initTimeUpLabel() {
        timeUpLabel.text = "\(countDownTime ?? "") 経過したよ！"
    }
    
    private func initGifView() {
        gifWebView.load(fileName: "hiyoko")
        gifWebView.startAnimate()
    }
}
