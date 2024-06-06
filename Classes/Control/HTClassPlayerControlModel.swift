//
//  HTClassPlayerControlModel.swift
//  HTClassPlayer
//
//  Created by 李雪健 on 2024/6/5.
//

import Foundation

public enum HTEnumControlType {
    case htEnumControlTypeSpacer //空间隔
    case htEnumControlTypeBack //返回按钮
    case htEnumControlTypeTitle //标题
    case htEnumControlTypeCast //投屏
    case htEnumControlTypeShare //分享
    case htEnumControlTypeCC //字幕
    case htEnumControlTypeCollection //收藏
    case htEnumControlTypeRemoveAd //去广告
    case htEnumControlTypeLock // 锁
    case htEnumControlTypeBackward // 后退 10s
    case htEnumControlTypeForward // 前进 10s
    case htEnumControlTypeFullScreenPlayPause // 横屏播放暂停
    case htEnumControlTypePlayPause //播放暂停
    case htEnumControlTypeNextEpisode //下一集
    case htEnumControlTypeProgresss //进度 包括当前时间、slider、总时长
    case htEnumControlTypeEpisodes //集
    case htEnumControlTypeFullscreen //全屏
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
