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

@objc enum HTEnumPlayerState: Int {

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
