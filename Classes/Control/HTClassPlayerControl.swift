//
//  HTClassPlayerControl.swift
//  HTClassPlayer
//
//  Created by 李雪健 on 2024/6/5.
//

import Foundation

protocol HTClassPlayerControlDelegate: NSObjectProtocol {
    
    func ht_playerControl(var_playerControl: HTClassPlayerControl, var_didClickWith var_model: HTClassPlayerControlModel)
}

open class HTClassPlayerControl: UIView {
    
    // 计算属性来判断是否全屏
    var var_isFullScreen: Bool {
        get {
            return UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height
        }
    }
    
    var var_isPlaying: Bool {
        get {
            return var_player.var_isPlaying
        }
    }

    var var_showControl: Bool = false
    
    weak var var_delegate: HTClassPlayerControlDelegate?
    // 播放器
    lazy var var_player: HTClassPlayerLayerView = {
        let var_view = HTClassPlayerLayerView()
        var_view.var_delegate = self
        return var_view
    }()
    // 顶部控制层
    lazy var var_topControl: HTClassPlayerTopControl = {
        let var_view = HTClassPlayerTopControl()
        var_view.alpha = 0
        var_view.var_click = { [weak self] var_model in
            guard let self = self else {return}
            if let var_model = var_model {
                self.var_delegate?.ht_playerControl(var_playerControl: self, var_didClickWith: var_model)
            }
        }
        return var_view
    }()
    // 中间控制层 竖屏隐藏
    lazy var var_centerControl: HTClassPlayerCenterControl = {
        let var_view = HTClassPlayerCenterControl()
        var_view.alpha = 0
        var_view.isHidden = true
        return var_view
    }()
    // 底部控制层
    lazy var var_bottomControl: HTClassPlayerBottomControl = {
        let var_view = HTClassPlayerBottomControl()
        var_view.alpha = 0
        var_view.var_click = { [weak self] var_model in
            guard let self = self else {return}
            if let var_model = var_model {
                self.var_delegate?.ht_playerControl(var_playerControl: self, var_didClickWith: var_model)
            }
        }
        return var_view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ht_setupViews()
        ht_singleTapAction()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        ht_setupViews()
    }
    
    func ht_setupViews() {
        
        backgroundColor = UIColor.black
        
        ht_addGestureRecognizers()
        
        self.addSubview(var_player)
        var_player.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(var_topControl)
        var_topControl.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        self.addSubview(var_centerControl)
        var_centerControl.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        self.addSubview(var_bottomControl)
        var_bottomControl.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if var_isFullScreen {
            var_centerControl.isHidden = false
            var_topControl.snp.remakeConstraints { make in
                make.top.equalTo(10)
                make.left.right.equalToSuperview().inset(10)
            }
            var_centerControl.snp.remakeConstraints { make in
                make.left.right.equalToSuperview().inset(10)
                make.centerY.equalToSuperview()
            }
            var_bottomControl.snp.remakeConstraints { make in
                make.bottom.equalToSuperview()
                make.left.right.equalToSuperview().inset(10)
            }
        } else {
            var_centerControl.isHidden = true
            var_topControl.snp.remakeConstraints { make in
                make.top.left.right.equalToSuperview()
            }
            var_centerControl.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            var_bottomControl.snp.remakeConstraints { make in
                make.bottom.left.right.equalToSuperview()
            }
        }
    }
    
    // 重置播放状态
    func ht_resetPlayer() {
        var_player.ht_resetPlayer()
    }
    
    // 开始播放｜替换URL
    func ht_playVideo(_ var_url: URL) {
        var_player.ht_playVideo(var_url)
    }
    
    // 播放
    func ht_play() {
        var_player.ht_play()
    }
    
    // 暂停
    func ht_pause() {
        var_player.ht_pause()
    }

    // 停止
    func ht_stop() {
        var_player.ht_stop()
    }
    
    func ht_fullScreen() {
        
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
    func ht_seekToTime(_ var_time: TimeInterval, var_completion: (()->Void)? = nil) {
        var_player.ht_seekToTime(var_time, var_completion: var_completion)
    }
    
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
    
    @objc private func ht_singleTapAction() {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(ht_auto), object: nil)
        ht_auto()
        if var_showControl {
            self.perform(#selector(ht_auto), with: nil, afterDelay: 5.0)
        }
    }

    @objc private func ht_doubleTapAction() {
        
        if var_player.var_isPlaying {
            ht_pause()
        } else {
            ht_play()
        }
    }

    @objc private func ht_handlePanGesture(_ var_gesture: UIPanGestureRecognizer) {

        let var_translation = var_gesture.translation(in: self)
        let var_location = var_gesture.location(in: self)
        print("-----> \(var_translation) \(var_location)")
    }

    private var var_isAnimating: Bool = false
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
            self.var_centerControl.alpha = abs(self.var_centerControl.alpha - 1)
            self.var_bottomControl.alpha = abs(self.var_bottomControl.alpha - 1)
        } completion: { [weak self] var_completion in
            guard let self = self else {return}
            self.var_isAnimating = false
        }
    }
    
    /*测试*/
    func ht_subviewWith(_ var_type: HTEnumControlType) -> UIView? {
        
        for var_view in self.var_topControl.var_subviews {
            if let var_view = var_view as? HTClassControlView, var_view.var_model?.var_type == var_type {
                return var_view
            }
            if let var_view = var_view as? HTClassPlayerProgressView, var_type == .htEnumControlTypeProgresss {
                return var_view
            }
        }
        for var_view in self.var_bottomControl.var_subviews {
            if let var_view = var_view as? HTClassControlView, var_view.var_model?.var_type == var_type {
                return var_view
            }
            if let var_view = var_view as? HTClassPlayerProgressView, var_type == .htEnumControlTypeProgresss {
                return var_view
            }
        }
        return nil
    }
}

extension HTClassPlayerControl: HTClassPlayerLayerViewDelegate {
    
    func ht_player(var_player: HTClassPlayerLayerView, var_isPlaying: Bool) {
        
        if let var_view = ht_subviewWith(.htEnumControlTypePlayPause) as? HTClassControlView {
            var_view.var_model?.ht_setSelected(var_isPlaying)
        }
    }
    
    func ht_player(var_player: HTClassPlayerLayerView, var_playTimeDidChange var_currentTime: TimeInterval, var_totalTime: TimeInterval) {
        print("playTimeDidChange -----> \(var_currentTime) -- \(var_totalTime)")
        if var_totalTime > 0, let var_view = ht_subviewWith(.htEnumControlTypeProgresss) as? HTClassPlayerProgressView {
            var_view.var_currentTimeLabel.text = var_view.ht_convertSecondsToHMS(Int(var_currentTime))
            var_view.var_totalTimeLabel.text = var_view.ht_convertSecondsToHMS(Int(var_totalTime))
        }
    }
    
    func ht_player(var_player: HTClassPlayerLayerView, var_loadedTimeDidChange var_loadedDuration: TimeInterval, var_totalTime: TimeInterval) {
        print("loadTimechange -----> \(var_loadedDuration) -- \(var_totalTime)")
        if var_totalTime > 0, let var_view = ht_subviewWith(.htEnumControlTypeProgresss) as? HTClassPlayerProgressView {
            var_view.var_totalTimeLabel.text = var_view.ht_convertSecondsToHMS(Int(var_totalTime))
        }
    }
    
    func ht_player(var_player: HTClassPlayerLayerView, var_playerStateDidChange var_state: HTEnumPlayerState) {
        print("state -----> \(var_state)")
    }
}
