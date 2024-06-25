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
    
    public static let htEnumControlTypeSpacer = HTEnumControlType(1) //空间隔 自动拉伸 如果想加入固定间距 可以扩展新类型，设置ht_customeView(HTClassCustomView()).ht_size(CGSize(width:22, height22))
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
    // 标题 文本自适应宽高 如果固定大小需要ht_customView
    @discardableResult
    public func ht_title(_ var_string: String) -> Self {
        self.var_title = var_string
        var_updateValue?()
        return self
    }
    // 图片 支持String UIImage URL
    @discardableResult
    public func ht_image(_ var_string: Any) -> Self {
        self.var_image = var_string
        var_updateValue?()
        return self
    }
    // 图片选中 支持String UIImage URL 使用ht_setSelected切换
    @discardableResult
    public func ht_selectImage(_ var_selectImage: Any) -> Self {
        self.var_selectImage = var_selectImage
        var_updateValue?()
        return self
    }
    // 切换选中非选中图片
    @discardableResult
    public func ht_setSelected(_ var_isSelected: Bool) -> Self {
        self.var_isSelected = var_isSelected
        var_updateValue?()
        return self
    }
    // 类型 用来回调时确定点击的是哪个按钮
    @discardableResult
    public func ht_type(_ var_type: HTEnumControlType) -> Self {
        self.var_type = var_type
        return self
    }
    // 尺寸 默认22*22 设置title自适应尺寸
    @discardableResult
    public func ht_size(_ var_size: CGSize) -> Self {
        self.var_size = var_size
        return self
    }
    // 自定义view
    @discardableResult
    public func ht_customView(_ var_view: HTClassControlView) -> Self {
        self.var_customView = var_view
        return self
    }
    
    public var var_title: String? //标题
    public var var_image: Any? //图片
    public var var_selectImage: Any? //图片
    public var var_isSelected: Bool = false
    public var var_type: HTEnumControlType = .htEnumControlTypeSpacer
    public var var_size: CGSize = CGSize(width: 22, height: 22)
    public var var_customView: HTClassControlView? // 自定义view
    public var var_updateValue: (() -> Void)?
}
