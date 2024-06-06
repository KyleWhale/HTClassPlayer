//
//  HTClassPlayerControl.swift
//  HTClassPlayer
//
//  Created by 李雪健 on 2024/6/5.
//

import Foundation
import MediaPlayer

enum HTEnumPanDirection: Int {
    case htEnumHorizontal = 0
    case htEnumVertical   = 1
}

@objc public protocol HTClassPlayerControlDelegate: NSObjectProtocol {
    // 按钮点击
    @objc optional func ht_playerControl(var_playerControl: HTClassPlayerControl, var_didClickWith var_model: HTClassPlayerControlModel)
    // 是否正在播放
    @objc optional func ht_playerControl(var_playerControl: HTClassPlayerControl, var_isPlaying: Bool)
    // 播放状态
    @objc optional func ht_playerControl(var_playerControl: HTClassPlayerControl, var_playerStateDidChange var_state: HTEnumPlayerState)
    // 播放时长
    @objc optional func ht_playerControl(var_playerControl: HTClassPlayerControl, var_playTimeDidChange var_currentTime: TimeInterval, var_totalTime: TimeInterval)
    // 缓冲进度
    @objc optional func ht_playerControl(var_playerControl: HTClassPlayerControl, var_loadedTimeDidChange var_loadedDuration: TimeInterval, var_totalTime: TimeInterval)
    // 滑动结束 var_type 0 = slider 1 = 滑动手势
    @objc optional func ht_playerControl(var_playerControl: HTClassPlayerControl, var_sliderChangeEnd var_currentTime: TimeInterval, var_type: Int)
}

public class HTClassPlayerControl: UIView {
    
    // 循环播放
    public var var_isAutoLoop: Bool = false
    // 代理
    public weak var var_delegate: HTClassPlayerControlDelegate?
    // 计算属性来判断是否全屏
    public var var_isFullScreen: Bool {
        get {
            return UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height
        }
    }
    // 播放状态
    public var var_isPlaying: Bool {
        get {
            return var_player.var_isPlaying
        }
    }
    public var var_currentTime: TimeInterval {
        get {
            return var_player.var_currentTime
        }
    }
    public var var_isSeeking: Bool {
        get {
            return var_player.var_isSeeking
        }
    }
    // 是否显示控制层
    public var var_showControl: Bool = false
    // 标记滑动中 滑块或横滑
    private var var_sliding: Bool = false
    // 播放器
    public lazy var var_player: HTClassPlayerLayerView = {
        let var_view = HTClassPlayerLayerView()
        var_view.var_delegate = self
        return var_view
    }()
    // 顶部控制层
    public lazy var var_topControl: HTClassPlayerTopControl = {
        let var_view = HTClassPlayerTopControl()
        var_view.alpha = 0
        var_view.var_click = { [weak self] var_model in
            guard let self = self else {return}
            if let var_model = var_model {
                self.ht_didClickWith(var_model)
            }
        }
        return var_view
    }()
    // 中间控制层
    public lazy var var_centerControl: HTClassPlayerCenterControl = {
        let var_view = HTClassPlayerCenterControl()
        var_view.alpha = 0
        var_view.var_click = { [weak self] var_model in
            guard let self = self else {return}
            if let var_model = var_model {
                self.ht_didClickWith(var_model)
            }
        }
        return var_view
    }()
    // 左侧控制层 ad lock
    public lazy var var_leftControl: HTClassPlayerLeftControl = {
        let var_view = HTClassPlayerLeftControl()
        var_view.alpha = 0
        var_view.var_click = { [weak self] var_model in
            guard let self = self else {return}
            if let var_model = var_model {
                self.ht_didClickWith(var_model)
            }
        }
        return var_view
    }()
    // 底部控制层
    public lazy var var_bottomControl: HTClassPlayerBottomControl = {
        let var_view = HTClassPlayerBottomControl()
        var_view.alpha = 0
        var_view.var_click = { [weak self] var_model in
            guard let self = self else {return}
            if let var_model = var_model {
                self.ht_didClickWith(var_model)
            }
        }
        var_view.var_sliderChange = { [weak self] var_slider, var_eventType in
            guard let self = self else {return}
            // 滑块
            switch var_eventType {
            case .touchDown:
                var_sliding = true
                var_player.ht_pauseTimer()
                // 关闭自动隐藏
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(ht_auto), object: nil)
                break
            case .touchUpInside:
                var_sliding = true
                var_player.ht_pauseTimer()
                let var_target = var_player.var_totalTime * Double(var_slider.value)
                ht_seekToTime(var_target) { [weak self] in
                    guard let self = self else {return}
                    var_sliding = false
                    var_delegate?.ht_playerControl?(var_playerControl: self, var_sliderChangeEnd: var_currentTime, var_type: 0)
                }
                // 重置自动隐藏
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(ht_auto), object: nil)
                if var_showControl {
                    self.perform(#selector(ht_auto), with: nil, afterDelay: 5.0)
                }
                break
            case .valueChanged:
                let var_target = var_player.var_totalTime * Double(var_slider.value)
                if let var_progressView = ht_subviewWith(.htEnumControlTypeProgresss) as? HTClassPlayerProgressView {
                    var_progressView.var_currentTimeLabel.text = ht_convertSecondsToHMS(Int(var_target))
                }
                break
            default:
                break
            }
        }
        return var_view
    }()
    lazy var var_progressAlert: HTClassPlayerProgressAlert = {
        let var_view = HTClassPlayerProgressAlert()
        var_view.ht_dismiss()
        return var_view
    }()
    // loading
    lazy var var_loading: UIActivityIndicatorView = {
        let var_view = UIActivityIndicatorView(style: .medium)
        var_view.color = .white
        return var_view
    }()
    // 获取音量的slider
    fileprivate var var_volumeSlider: UISlider?
    // 保存时间
    fileprivate var var_sumTime: TimeInterval = 0
    // 是否调节音量
    fileprivate var var_isVolume: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        ht_setupViews()
        ht_singleTapAction()
        ht_configureVolume()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        ht_setupViews()
        ht_singleTapAction()
        ht_configureVolume()
    }
    // 添加控制层
    func ht_setupViews() {
        
        backgroundColor = UIColor.black
        
        ht_addGestureRecognizers()
        
        self.addSubview(var_player)
        var_player.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(var_leftControl)
        var_leftControl.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(var_topControl)
        var_topControl.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        self.addSubview(var_centerControl)
        var_centerControl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.addSubview(var_bottomControl)
        var_bottomControl.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
        }
        
        self.addSubview(var_loading)
        var_loading.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(15)
        }
        
        self.addSubview(var_progressAlert)
        var_progressAlert.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSizeMake(150, 44))
        }
    }
    // 横竖屏修改Layout
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if var_isFullScreen {
            var_leftControl.snp.remakeConstraints { make in
                make.left.equalTo(safeAreaLayoutGuide.snp.left)
                make.centerY.equalToSuperview()
            }
            var_topControl.snp.remakeConstraints { make in
                make.top.equalTo(10)
                make.left.right.equalToSuperview().inset(10)
            }
            var_centerControl.snp.remakeConstraints { make in
                make.center.equalToSuperview()
            }
            var_bottomControl.snp.remakeConstraints { make in
                make.bottom.equalToSuperview()
                make.left.right.equalToSuperview().inset(10)
            }
            var_progressAlert.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(var_topControl.snp.bottom).offset(20)
                make.size.equalTo(CGSizeMake(150, 44))
            }
        } else {
            var_leftControl.snp.remakeConstraints { make in
                make.left.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            var_topControl.snp.remakeConstraints { make in
                make.top.left.right.equalToSuperview()
            }
            var_centerControl.snp.remakeConstraints { make in
                make.center.equalToSuperview()
            }
            var_bottomControl.snp.remakeConstraints { make in
                make.bottom.left.right.equalToSuperview()
            }
            var_progressAlert.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalTo(CGSizeMake(150, 44))
            }
        }
    }
    // deinit中调用 需要释放
    public func ht_prepareToDeinit() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(ht_auto), object: nil)
        ht_resetPlayer()
    }
    // 重置播放状态
    public func ht_resetPlayer() {
        var_player.ht_resetPlayer()
    }
    // 开始播放｜替换URL
    public func ht_playVideo(_ var_url: URL) {
        ht_showLoading()
        var_player.ht_playVideo(var_url)
    }
    // 播放
    public func ht_play() {
        var_player.ht_play()
    }
    // 暂停
    public func ht_pause() {
        var_player.ht_pause()
    }
    // 停止
    public func ht_stop() {
        var_player.ht_stop()
    }
    // 显示菊花
    public func ht_showLoading() {
        var_loading.startAnimating()
    }
    // 隐藏菊花
    public func ht_hiddenLoading() {
        var_loading.stopAnimating()
    }
    // 横竖屏调用
    public func ht_fullScreen() {
        
        if var_isFullScreen {
            if #available(iOS 16.0, *) {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
            } else {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: ht_AsciiString("orientation"))
            }
        } else {
            if #available(iOS 16.0, *) {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
            } else {
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: ht_AsciiString("orientation"))
            }
        }
    }
    // seekto
    public func ht_seekToTime(_ var_time: TimeInterval, var_completion: (()->Void)? = nil) {
        var_player.ht_seekToTime(var_time, var_completion: var_completion)
    }
    // 按钮事件
    private func ht_didClickWith(_ var_model: HTClassPlayerControlModel) {
        // 重置控制层消失时间
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(ht_auto), object: nil)
        if self.var_showControl {
            self.perform(#selector(ht_auto), with: nil, afterDelay: 5.0)
        }
        self.var_delegate?.ht_playerControl?(var_playerControl: self, var_didClickWith: var_model)
    }
    // 正在显隐控制层
    private var var_isAnimating: Bool = false
    // 显隐控制层
    @objc func ht_auto() {
        // 自动显隐
        if var_isAnimating {
            return
        }
        self.var_showControl.toggle()
        var_isAnimating = true
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.var_topControl.alpha = abs(self.var_topControl.alpha - 1)
            self.var_leftControl.alpha = abs(self.var_leftControl.alpha - 1)
            self.var_centerControl.alpha = abs(self.var_centerControl.alpha - 1)
            self.var_bottomControl.alpha = abs(self.var_bottomControl.alpha - 1)
        } completion: { [weak self] var_completion in
            guard let self = self else {return}
            self.var_isAnimating = false
        }
    }
    // 通过枚举获取view
    func ht_subviewWith(_ var_type: HTEnumControlType) -> UIView? {
        
        for var_view in self.var_bottomControl.var_subviews {
            if let var_view = var_view as? HTClassControlView, var_view.var_model?.var_type == var_type {
                return var_view
            }
            if let var_view = var_view as? HTClassPlayerProgressView, var_type == .htEnumControlTypeProgresss {
                return var_view
            }
        }
        for var_view in self.var_topControl.var_subviews {
            if let var_view = var_view as? HTClassControlView, var_view.var_model?.var_type == var_type {
                return var_view
            }
            if let var_view = var_view as? HTClassPlayerProgressView, var_type == .htEnumControlTypeProgresss {
                return var_view
            }
        }
        for var_view in self.var_leftControl.var_subviews {
            if let var_view = var_view as? HTClassControlView, var_view.var_model?.var_type == var_type {
                return var_view
            }
            if let var_view = var_view as? HTClassPlayerProgressView, var_type == .htEnumControlTypeProgresss {
                return var_view
            }
        }
        for var_view in self.var_centerControl.var_subviews {
            if let var_view = var_view as? HTClassControlView, var_view.var_model?.var_type == var_type {
                return var_view
            }
            if let var_view = var_view as? HTClassPlayerProgressView, var_type == .htEnumControlTypeProgresss {
                return var_view
            }
        }
        return nil
    }
    // 添加手势
    private func ht_addGestureRecognizers() {
        // Single tap gesture
        let var_singleTap = UITapGestureRecognizer(target: self, action: #selector(ht_singleTapAction))
        var_singleTap.numberOfTapsRequired = 1
        addGestureRecognizer(var_singleTap)
        // Double tap gesture
        let var_doubleTap = UITapGestureRecognizer(target: self, action: #selector(ht_doubleTapAction))
        var_doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(var_doubleTap)
        // Prevent single tap from firing when double tap is recognized
        var_singleTap.require(toFail: var_doubleTap)
        // Pan gesture
        let var_panGesture = UIPanGestureRecognizer(target: self, action: #selector(ht_handlePanGesture(_:)))
        addGestureRecognizer(var_panGesture)
    }
    // 单击手势
    @objc private func ht_singleTapAction() {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(ht_auto), object: nil)
        ht_auto()
        if var_showControl {
            self.perform(#selector(ht_auto), with: nil, afterDelay: 5.0)
        }
    }
    // 双击手势
    @objc private func ht_doubleTapAction() {
        
        if var_player.var_isPlaying {
            ht_pause()
        } else {
            ht_play()
        }
    }
    // 滑动手势
    @objc private func ht_handlePanGesture(_ var_gesture: UIPanGestureRecognizer) {
        // 根据在view上Pan的位置，确定是调音量还是亮度
        let var_locationPoint = var_gesture.location(in: self)
        // 我们要响应水平移动和垂直移动、根据上次和本次移动的位置，算出一个速率的point
        let var_velocityPoint = var_gesture.velocity(in: self)
        switch var_gesture.state {
        case .began:
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(ht_auto), object: nil)
            let x = abs(var_velocityPoint.x)
            let y = abs(var_velocityPoint.y)
            if x > y {
                self.var_panDirection = HTEnumPanDirection.htEnumHorizontal
                // 给sumTime初值
                self.var_sumTime = var_player.var_currentTime
            } else {
                self.var_panDirection = HTEnumPanDirection.htEnumVertical
                if var_locationPoint.x > self.bounds.size.width / 2 {
                    self.var_isVolume = true
                } else {
                    self.var_isVolume = false
                }
            }
            break
        case .changed:
            switch self.var_panDirection {
            case .htEnumHorizontal:
                self.ht_horizontalMoved(var_velocityPoint.x)
                break
            case .htEnumVertical:
                self.ht_verticalMoved(var_velocityPoint.y)
                break
            }
            break
        case .ended:
            if self.var_showControl {
                self.perform(#selector(ht_auto), with: nil, afterDelay: 5.0)
            }
            var_progressAlert.ht_dismiss()
            switch self.var_panDirection {
            case .htEnumHorizontal:
                ht_seekToTime(self.var_sumTime) { [weak self] in
                    guard let self = self else {return}
                    var_sliding = false
                    var_delegate?.ht_playerControl?(var_playerControl: self, var_sliderChangeEnd: var_currentTime, var_type: 1)
                }
                break
            case .htEnumVertical:
                self.var_isVolume = false
                break
            }
            break
        default:
            break
        }
    }
    // 横滑计算
    fileprivate func ht_horizontalMoved(_ var_value: CGFloat) {
        var_sliding = true
        var_player.ht_pauseTimer()
        // 每次滑动需要叠加时间，通过一定的比例，使滑动一直处于统一水平
        let var_totalDuration = var_player.var_totalTime
        if var_totalDuration == 0 { return }
        self.var_sumTime = self.var_sumTime + TimeInterval(var_value) / 100.0 * (TimeInterval(var_totalDuration)/400)
        if (self.var_sumTime >= var_totalDuration) { self.var_sumTime = var_totalDuration }
        if (self.var_sumTime <= 0) { self.var_sumTime = 0 }
        if let var_progressView = ht_subviewWith(.htEnumControlTypeProgresss) as? HTClassPlayerProgressView {
            var_progressView.var_slider.value = Float(self.var_sumTime / var_totalDuration)
            var_progressView.var_currentTimeLabel.text = ht_convertSecondsToHMS(Int(self.var_sumTime))
        }
        var_progressAlert.ht_show(var_currentTime: self.var_sumTime, var_totalTime: var_totalDuration)
    }
    // 竖滑计算
    fileprivate func ht_verticalMoved(_ value: CGFloat) {
        if self.var_isVolume {
            self.var_volumeSlider?.value -= Float(value / 10000)
        } else if !self.var_isVolume {
            UIScreen.main.brightness -= value / 10000
        }
    }
    // 记录滑动方向
    fileprivate var var_panDirection = HTEnumPanDirection.htEnumHorizontal
    // 获取音量slider
    fileprivate func ht_configureVolume() {
        let var_volumeView = MPVolumeView()
        for var_subview in var_volumeView.subviews {
            if let var_slider = var_subview as? UISlider {
                self.var_volumeSlider = var_slider
            }
        }
    }
    open func ht_addVolume(_ var_step: Float = 0.1) {
        self.var_volumeSlider?.value += var_step
    }
    open func ht_reduceVolume(_ var_step: Float = 0.1) {
        self.var_volumeSlider?.value -= var_step
    }
    // 释放
    deinit {
        print("播放控制层释放了")
    }
}

extension HTClassPlayerControl: HTClassPlayerLayerViewDelegate {
    
    public func ht_player(var_player: HTClassPlayerLayerView, var_isPlaying: Bool) {
        
        if let var_view = ht_subviewWith(.htEnumControlTypePlayPause) as? HTClassControlView {
            var_view.var_model?.ht_setSelected(var_isPlaying)
        }
        if let var_view = ht_subviewWith(.htEnumControlTypeFullScreenPlayPause) as? HTClassControlView {
            var_view.var_model?.ht_setSelected(var_isPlaying)
        }
        var_delegate?.ht_playerControl?(var_playerControl: self, var_isPlaying: var_isPlaying)
    }
    
    public func ht_player(var_player: HTClassPlayerLayerView, var_playTimeDidChange var_currentTime: TimeInterval, var_totalTime: TimeInterval) {
        
        if var_totalTime > 0, let var_view = ht_subviewWith(.htEnumControlTypeProgresss) as? HTClassPlayerProgressView {
            var_view.var_currentTimeLabel.text = ht_convertSecondsToHMS(Int(var_currentTime))
            var_view.var_totalTimeLabel.text = ht_convertSecondsToHMS(Int(var_totalTime))
            var_view.var_slider.value = Float(var_currentTime) / Float(var_totalTime)
        }
        var_delegate?.ht_playerControl?(var_playerControl: self, var_playTimeDidChange: var_currentTime, var_totalTime: var_totalTime)
    }
    
    public func ht_player(var_player: HTClassPlayerLayerView, var_loadedTimeDidChange var_loadedDuration: TimeInterval, var_totalTime: TimeInterval) {
        // 缓冲进度
        if var_totalTime > 0, let var_view = ht_subviewWith(.htEnumControlTypeProgresss) as? HTClassPlayerProgressView {
            var_view.var_totalTimeLabel.text = ht_convertSecondsToHMS(Int(var_totalTime))
        }
        var_delegate?.ht_playerControl?(var_playerControl: self, var_loadedTimeDidChange: var_loadedDuration, var_totalTime: var_totalTime)
    }
    
    public func ht_player(var_player: HTClassPlayerLayerView, var_playerStateDidChange var_state: HTEnumPlayerState) {
        if var_state == .htEnumPlayerStatePlayToTheEnd {
            if var_isAutoLoop {
                var_player.ht_seekToTime(0) { [weak self] in
                    self?.ht_play()
                }
            }
        }
        if var_state == .htEnumPlayerStateBuffering {
            ht_showLoading()
        }
        if var_state == .htEnumPlayerStateBufferFinished {
            ht_hiddenLoading()
        }
        if var_state == .htEnumPlayerStateError {
            ht_hiddenLoading()
        }
        var_delegate?.ht_playerControl?(var_playerControl: self, var_playerStateDidChange: var_state)
    }
}
