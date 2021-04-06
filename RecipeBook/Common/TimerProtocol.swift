//
//  TimerProtocol.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/11/25.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import RxCocoa

protocol TimerProtocol: AnyObject {
    var timer: Timer? { get set }
    var timerCompleteObserver: PublishRelay<Void> { get set }
    func initTimer(timeInterval: TimeInterval)
}

extension TimerProtocol {
    
    func initTimer(timeInterval: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { [weak self] _ in
            self?.timerCompleteObserver.accept(())
            self?.timer?.invalidate()
        })
    }
}
