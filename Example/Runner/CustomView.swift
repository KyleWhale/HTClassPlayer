//
//  CustomView.swift
//  Runner
//
//  Created by 李雪健 on 2024/6/13.
//

import Foundation
import HTClassPlayer

class CustomView: HTClassControlView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func ht_setupViews() {
        super.ht_setupViews()
        
        self.backgroundColor = UIColor.red
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
        self.var_titleLabel.textColor = .white
        self.var_titleLabel.textAlignment = .center
        self.var_titleLabel.adjustsFontSizeToFitWidth = true
    }
}
