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

public func ht_convertSecondsToHMS(_ var_seconds: Int) -> String {
    let var_hours = var_seconds / 3600
    let var_minutes = (var_seconds % 3600) / 60
    let var_seconds = var_seconds % 60
    return String(format: "%02d:%02d:%02d", var_hours, var_minutes, var_seconds)
}

/*测试 临时使用 上线前删除*/
func ht_AsciiString(_ string: String) -> String {
    return string
}
