//
//  HTClassPlayerHeaders.swift
//  HTClassPlayer
//
//  Created by 李雪健 on 2024/6/4.
//

@_exported import AVFoundation
@_exported import Foundation
@_exported import UIKit
@_exported import SnapKit
@_exported import Kingfisher

@objc public enum HTEnumPlayerState: Int {

    case htEnumPlayerStateNoURL
    case htEnumPlayerStateReadyToPlay
    case htEnumPlayerStateBuffering
    case htEnumPlayerStateBufferFinished
    case htEnumPlayerStatePlayToTheEnd
    case htEnumPlayerStateError
}

/*测试 临时使用 上线前删除*/
func ht_AsciiString(_ string: String) -> String {
    return string
}

func ht_randomColor() -> UIColor {
    let var_red = CGFloat(arc4random_uniform(256)) / 255.0
    let var_green = CGFloat(arc4random_uniform(256)) / 255.0
    let var_blue = CGFloat(arc4random_uniform(256)) / 255.0
    return UIColor(red: var_red, green: var_green, blue: var_blue, alpha: 1.0)
}
