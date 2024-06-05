//
//  HTClassPlayerProgressView.swift
//  HTClassPlayer
//
//  Created by 李雪健 on 2024/6/5.
//

import Foundation

class HTClassPlayerProgressView: UIView {
    
    lazy var var_currentTimeLabel: UILabel = {
        let var_view = UILabel()
        var_view.text = ht_convertSecondsToHMS(0)
        var_view.textColor = .white
        var_view.font = .systemFont(ofSize: 14, weight: .regular)
        var_view.textAlignment = .left
        var_view.adjustsFontSizeToFitWidth = true
        return var_view
    }()
    
    lazy var var_slider: HTClassTimeSlider = {
        let var_view = HTClassTimeSlider()
        var_view.maximumValue = 1.0
        var_view.minimumValue = 0.0
        var_view.value        = 0
        var_view.maximumTrackTintColor = .gray
        var_view.minimumTrackTintColor = .white
        var_view.addTarget(self, action: #selector(ht_progressSliderTouchBegan(_:)), for: UIControl.Event.touchDown)
        var_view.addTarget(self, action: #selector(ht_progressSliderValueChanged(_:)), for: UIControl.Event.valueChanged)
        let var_touchEnd: UIControl.Event = [UIControl.Event.touchUpInside, UIControl.Event.touchCancel, UIControl.Event.touchUpOutside]
        var_view.addTarget(self, action: #selector(ht_progressSliderTouchEnded(_:)), for: var_touchEnd)
        return var_view
    }()
    
    lazy var var_totalTimeLabel: UILabel = {
        let var_view = UILabel()
        var_view.text = ht_convertSecondsToHMS(0)
        var_view.textColor = .white
        var_view.font = .systemFont(ofSize: 14, weight: .regular)
        var_view.textAlignment = .right
        var_view.adjustsFontSizeToFitWidth = true
        return var_view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ht_setupViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        ht_setupViews()
    }
    
    func ht_setupViews() {
        
        addSubview(var_currentTimeLabel)
        var_currentTimeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(70)
        }
        addSubview(var_totalTimeLabel)
        var_totalTimeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(70)
        }
        addSubview(var_slider)
        var_slider.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.left.equalTo(var_currentTimeLabel.snp.right).offset(10)
            make.right.equalTo(var_totalTimeLabel.snp.left).offset(-10)
        }
    }
    
    func ht_convertSecondsToHMS(_ var_seconds: Int) -> String {
        let var_hours = var_seconds / 3600
        let var_minutes = (var_seconds % 3600) / 60
        let var_seconds = var_seconds % 60
        return String(format: "%02d:%02d:%02d", var_hours, var_minutes, var_seconds)
    }
    
    @objc func ht_progressSliderTouchBegan(_ var_sender: UISlider)  {
        
    }
    
    @objc func ht_progressSliderValueChanged(_ var_sender: UISlider)  {
        
    }
    
    @objc func ht_progressSliderTouchEnded(_ var_sender: UISlider)  {
        
    }
}
