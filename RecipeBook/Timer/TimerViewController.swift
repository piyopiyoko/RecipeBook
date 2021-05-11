//
//  TimerViewController.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/11/16.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import UIKit
import RxSwift

class TimerViewController: UIViewController, ShowTimeUpViewControllerProtocol {
    
    @IBOutlet weak var hourPickerView: UIPickerView!
    @IBOutlet weak var minutesPickerView: UIPickerView!
    @IBOutlet weak var secondPickerView: UIPickerView!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    private let viewModel = TimerViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindHourPicker()
        bindMinutesPicker()
        bindSecondPicker()
        bindTimerView()
        bindTimerLabel()
        bindHidePause()
        bindShowTimeUpViewController()
    }
    
    @IBAction func tapPlay(_ sender: Any) {
        viewModel.play()
    }
    
    @IBAction func tapPause(_ sender: Any) {
        viewModel.pause()
    }
    
    @IBAction func tapStop(_ sender: Any) {
        viewModel.stop()
    }
    
    private func bindHourPicker() {
        viewModel.hourObserver.bind(to: hourPickerView.rx.itemTitles) { _, str in
            return str
        }.disposed(by: disposeBag)
        
        hourPickerView.rx.modelSelected(String.self)
            .map { $0.first }
            .subscribe(onNext: { [weak self] hour in
                self?.viewModel.set(hour: hour)
            }).disposed(by: disposeBag)
    }
    
    private func bindMinutesPicker() {
        viewModel.minutesObserver.bind(to: minutesPickerView.rx.itemTitles) { _, str in
            return str
        }.disposed(by: disposeBag)
        
        minutesPickerView.rx.modelSelected(String.self)
            .map { $0.first }
            .subscribe(onNext: { [weak self] minutes in
                self?.viewModel.set(minutes: minutes)
            }).disposed(by: disposeBag)
    }
    
    private func bindSecondPicker() {
        viewModel.secondObserver.bind(to: secondPickerView.rx.itemTitles) { _, str in
            return str
        }.disposed(by: disposeBag)
        
        secondPickerView.rx.modelSelected(String.self)
            .map { $0.first }
            .subscribe(onNext: { [weak self] second in
                self?.viewModel.set(second: second)
            }).disposed(by: disposeBag)
    }
    
    private func bindTimerView() {
        viewModel.hideTimerObserver.bind(to: timerView.rx.isHidden).disposed(by: disposeBag)
    }
    
    private func bindTimerLabel() {
        viewModel.countDownTimeObserver.bind(to: timerLabel.rx.text).disposed(by: disposeBag)
    }
    
    private func bindHidePause() {
        viewModel.hidePauseObserver.bind(to: pauseButton.rx.isHidden).disposed(by: disposeBag)
    }
    
    private func bindShowTimeUpViewController() {
        viewModel.timeUpObserver
            .subscribe(onNext: { [weak self] time in
                self?.showTimeUpViewController(time: time)
            })
            .disposed(by: disposeBag)
    }
}

extension TimerViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
