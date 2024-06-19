//
//  HTClassTimeSlider.swift
//  HTClassPlayer
//
//  Created by 李雪健 on 2024/6/5.
//

import Foundation
import UIKit

public class HTClassTimeSlider: UISlider {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setThumbImage(ht_createThumbImage(var_size: CGSizeMake(15, 15)), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        
        let var_trackHeight: CGFloat = 2
        let var_position = CGPoint(x: 0, y: 14)
        let var_customBounds = CGRect(origin: var_position, size: CGSize(width: bounds.size.width, height: var_trackHeight))
        super.trackRect(forBounds: var_customBounds)
        return var_customBounds
    }
    
    override open func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        
        let var_rect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        let var_newx = var_rect.origin.x - 10
        let var_newRect = CGRect(x: var_newx, y: 0, width: 30, height: 30)
        return var_newRect
    }
    
    func ht_createThumbImage(var_size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(var_size, false, UIScreen.main.scale)
        let var_context = UIGraphicsGetCurrentContext()
        let var_rect = CGRect(origin: .zero, size: var_size)
        var_context?.setFillColor(UIColor.white.cgColor)
        var_context?.fillEllipse(in: var_rect)
        let var_image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return var_image
    }
}
