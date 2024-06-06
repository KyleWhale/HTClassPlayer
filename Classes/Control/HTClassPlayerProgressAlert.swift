//
//  HTClassPlayerProgressAlert.swift
//  HTClassPlayer
//
//  Created by 李雪健 on 2024/6/6.
//

import Foundation

open class HTClassPlayerProgressAlert: UIView {
    
    public lazy var var_progressLabel: UILabel = {
        let var_view = UILabel()
        var_view.textColor = .white
        var_view.font = .systemFont(ofSize: 14, weight: .regular)
        var_view.textAlignment = .center
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
        
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        layer.masksToBounds = true
        layer.cornerRadius = 12
        addSubview(var_progressLabel)
        var_progressLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func ht_show(var_currentTime: TimeInterval, var_totalTime: TimeInterval) {
        isHidden = false
        var_progressLabel.text = "\(ht_convertSecondsToHMS(Int(var_currentTime)))/\(ht_convertSecondsToHMS(Int(var_totalTime)))"
    }
    
    public func ht_dismiss() {
        isHidden = true
    }
}
