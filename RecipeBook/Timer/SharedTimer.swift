//
//  TopTimerViewModel.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2021/04/21.
//  Copyright © 2021 Aimi Itagaki. All rights reserved.
//

import RxCocoa
import RxSwift

class SharedTimer {
    
    static let shared = SharedTimer()
    
    var time = Time(hour: 0, minutes: 0, second: 0)
    let countDownTimeRelay = BehaviorRelay<Time>(value: Time(hour: 0, minutes: 0, second: 0))
    let playRelay = BehaviorRelay<Bool>(value: false)
    var timeUpObserver: Observable<String> { timeUpRelay.asObservable() }
    private let timeUpRelay = PublishRelay<String>()
    private var updateTimeIntervalSinceNow = Date()
    
    private let disposeBag = DisposeBag()
    
    init() {
        initCountDownTime()
    }
    
    private func initCountDownTime() {
        playRelay
            .flatMapLatest { $0 ?  Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) : Observable.empty() }
            .subscribe(onNext: { [weak self] _ in
                self?.updateCountDownTimeRelay()
            }).disposed(by: disposeBag)
        
        playRelay
            .subscribe(onNext: { [weak self] _ in
                self?.updateTimeIntervalSinceNow = Date()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateCountDownTimeRelay() {
        var coutnDownTime = countDownTimeRelay.value
        let interval = Int(updateTimeIntervalSinceNow.timeIntervalSince(Date()))
        let now = Int(time.intervalTime) + interval
        coutnDownTime.set(now: now)
        countDownTimeRelay.accept(coutnDownTime)
        if coutnDownTime.timeUp {
            playRelay.accept(false)
            timeUpRelay.accept(self.time.displayTime)
        }
    }
}
