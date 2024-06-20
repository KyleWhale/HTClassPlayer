//
//  HTClassSubtitleLabel.swift
//  HTClassPlayer
//
//  Created by 李雪健 on 2024/6/18.
//

import Foundation
import UIKit

public class HTClassSubtitleLabel: UILabel {
    
    public var var_edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    public override func drawText(in rect: CGRect) {
        let var_insetRect = rect.inset(by: var_edgeInsets)
        super.drawText(in: var_insetRect)
    }
    
    public override var intrinsicContentSize: CGSize {
        let var_size = super.intrinsicContentSize
        let var_width = var_size.width + var_edgeInsets.left + var_edgeInsets.right
        let var_height = var_size.height + var_edgeInsets.top + var_edgeInsets.bottom
        return CGSize(width: ceil(var_width), height: ceil(var_height))
    }
}
