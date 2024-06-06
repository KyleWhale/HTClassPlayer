//
//  HTClassPlayerControlModel.swift
//  HTClassPlayer
//
//  Created by 李雪健 on 2024/6/5.
//

import Foundation

// 使用struct 方便扩展
public struct HTEnumControlType: Equatable {
    
    public let var_rawValue: Int
    
    public init(_ var_rawValue: Int) {
        self.var_rawValue = var_rawValue
    }
    
    public static let htEnumControlTypeSpacer = HTEnumControlType(1) //空间隔
    public static let htEnumControlTypeBack = HTEnumControlType(2) //返回按钮
    public static let htEnumControlTypeTitle = HTEnumControlType(3) //标题
    public static let htEnumControlTypeCast = HTEnumControlType(4) //投屏
    public static let htEnumControlTypeShare = HTEnumControlType(5) //分享
    public static let htEnumControlTypeCC = HTEnumControlType(6) //字幕
    public static let htEnumControlTypeCollection = HTEnumControlType(7) //收藏
    public static let htEnumControlTypeRemoveAd = HTEnumControlType(8) //去广告
    public static let htEnumControlTypeLock = HTEnumControlType(9) // 锁
    public static let htEnumControlTypeBackward = HTEnumControlType(10) // 后退 10s
    public static let htEnumControlTypeForward = HTEnumControlType(11) // 前进 10s
    public static let htEnumControlTypeFullScreenPlayPause = HTEnumControlType(12) // 横屏播放暂停
    public static let htEnumControlTypePlayPause = HTEnumControlType(13) //播放暂停
    public static let htEnumControlTypeNextEpisode = HTEnumControlType(14) //下一集
    public static let htEnumControlTypeProgresss = HTEnumControlType(15) //进度 包括当前时间、slider、总时长
    public static let htEnumControlTypeEpisodes = HTEnumControlType(16) //集
    public static let htEnumControlTypeFullscreen = HTEnumControlType(17) //全屏
}

// 这里注意使用方法赋值
@objc public class HTClassPlayerControlModel: NSObject {
    
    @discardableResult
    public func ht_title(_ var_string: String) -> Self {
        self.var_title = var_string
        var_updateValue?()
        return self
    }
    
    @discardableResult
    public func ht_image(_ var_string: String) -> Self {
        self.var_image = var_string
        var_updateValue?()
        return self
    }
    
    @discardableResult
    public func ht_selectImage(_ var_selectImage: String) -> Self {
        self.var_selectImage = var_selectImage
        var_updateValue?()
        return self
    }
    
    @discardableResult
    public func ht_setSelected(_ var_isSelected: Bool) -> Self {
        self.var_isSelected = var_isSelected
        var_updateValue?()
        return self
    }
    
    @discardableResult
    public func ht_type(_ var_type: HTEnumControlType) -> Self {
        self.var_type = var_type
        return self
    }
    
    @discardableResult
    public func ht_imageWidth(_ var_imageWidth: CGFloat) -> Self {
        self.var_imageWidth = var_imageWidth
        return self
    }
    
    public var var_title: String? //标题
    public var var_image: String? //图片地址
    public var var_selectImage: String? //图片地址 给播放暂停使用的
    public var var_isSelected: Bool = false
    public var var_type: HTEnumControlType = .htEnumControlTypeSpacer
    public var var_imageWidth: CGFloat = 22 //图片显示宽度 默认22
    public var var_updateValue: (() -> Void)?
}
