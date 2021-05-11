//
//  TimerViewModel.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/11/18.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import RxCocoa
import RxSwift

class TimerViewModel {
    
    var hourObserver: Observable<[String]> { hourRelay.asObservable() }
    var minutesObserver: Observable<[String]> { minutesRelay.asObservable() }
    var secondObserver: Observable<[String]> { secondRelay.asObservable() }
    var hideTimerObserver: Observable<Bool> { playRelay.map { !$0 } }
    var countDownTimeObserver: Observable<String> { countDownTimeRelay.map { $0.displayTime }.asObservable() }
    var hidePauseObserver: Observable<Bool> { playRelay.map { !$0 } }
    var playButtonEnableObserver: Observable<Bool> { playButtonEnableRelay.asObservable() }
    var timeUpObserver = SharedTimer.shared.timeUpObserver
    
    private let hourRelay = BehaviorRelay<[String]>(value: Array<Int>(0...23).map { String($0) })
    private let minutesRelay = BehaviorRelay<[String]>(value: Array<Int>(0...59).map { String($0) })
    private let secondRelay = BehaviorRelay<[String]>(value: Array<Int>(0...59).map { String($0) })
    
    private var time: Time {
        get { SharedTimer.shared.time }
        set { SharedTimer.shared.time = newValue }
    }
    private let countDownTimeRelay = SharedTimer.shared.countDownTimeRelay
    private var playRelay = SharedTimer.shared.playRelay
    
    private let hideTimerRelay = BehaviorRelay<Bool>(value: true)
    
    private let disposeBag = DisposeBag()
    
    private var playButtonEnableRelay = BehaviorRelay<Bool>(value: false)
    
    init() {
        bindUpdateCountDown()
    }
    
    func set(hour: String?) {
        time.set(hour: hour)
    }
    
    func set(minutes: String?) {
        time.set(minutes: minutes)
    }
    
    func set(second: String?) {
        time.set(second: second)
    }
    
    func play() {
        if time.isZero { return }
        playRelay.accept(true)
        hideTimerRelay.accept(false)
        countDownTimeRelay.accept(time)
        sendNotification()
    }
    
    func pause() {
        playRelay.accept(false)
    }
    
    func stop() {
        playRelay.accept(false)
        hideTimerRelay.accept(true)
    }
    
    private func bindUpdateCountDown() {
        SharedTimer.shared.timeUpObserver
            .subscribe(onNext: { [weak self] _ in
                self?.updateTimeUp()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateTimeUp() {
        hideTimerRelay.accept(true)
    }
    
    private func sendNotification() {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time.intervalTime, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = ""
        content.body = "\(time.hour)時間\(time.minutes)分\(time.second)秒経過しました。"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "uuid", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
