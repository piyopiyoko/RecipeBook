//
//  TimerIconView.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2021/04/21.
//  Copyright © 2021 Aimi Itagaki. All rights reserved.
//

import UIKit
import RxSwift

class TimerIconView: UIView {
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        initNib()
        bindTimer()
    }
    
    private func initNib() {
        guard let view = Bundle.main.loadNibNamed("TimerIconView", owner: self, options: nil)?.first as? UIView else { return }
        addSubview(view)
        view.frame = bounds
    }
    
    private func bindTimer() {
        SharedTimer.shared.countDownTimeRelay.map { $0.displayTime }.bind(to: countDownLabel.rx.text).disposed(by: disposeBag)
        
        SharedTimer.shared.playRelay.map { !$0 }.bind(to: countDownLabel.rx.isHidden).disposed(by: disposeBag)
    }
}
