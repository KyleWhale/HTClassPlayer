//
//  HTClassPlayerLayerView.swift
//  HTClassPlayer
//
//  Created by 李雪健 on 2024/6/4.
//

import Foundation

@objc protocol HTClassPlayerLayerViewDelegate: NSObjectProtocol {
    
    @objc optional func ht_player(var_player: HTClassPlayerLayerView, var_isPlaying: Bool)
    @objc optional func ht_player(var_player: HTClassPlayerLayerView, var_playerStateDidChange var_state: HTEnumPlayerState)
    @objc optional func ht_player(var_player: HTClassPlayerLayerView, var_playTimeDidChange var_currentTime: TimeInterval, var_totalTime: TimeInterval)
    @objc optional func ht_player(var_player: HTClassPlayerLayerView, var_loadedTimeDidChange var_loadedDuration: TimeInterval, var_totalTime: TimeInterval)
}

open class HTClassPlayerLayerView: UIView {
    
    var var_seekTime: TimeInterval = 0
    weak var var_delegate: HTClassPlayerLayerViewDelegate?
    
    var var_isPlaying: Bool = false {
        didSet {
            if oldValue != var_isPlaying {
                var_delegate?.ht_player?(var_player: self, var_isPlaying: var_isPlaying)
            }
        }
    }
    
    private var var_player: AVPlayer?
    private var var_playerLayer: AVPlayerLayer?
    private var var_playerItem: AVPlayerItem? {
        didSet {
            if var_playerItem == nil {
                ht_removeObserverIfNeeded()
            } else if var_playerItem != oldValue {
                ht_addObserverIfNeeded()
            }
        }
    }
    private var var_currentURL: URL?
    private var var_isObserving: Bool = false
    private var var_isBuffering: Bool = false
    private var var_readyToPlay: Bool = false
    private var var_playEnd: Bool = false
    private var var_timer: Timer?

    private var var_state: HTEnumPlayerState = .htEnumPlayerStateNoURL {
        didSet {
            if var_state != oldValue {
                self.var_delegate?.ht_player?(var_player: self, var_playerStateDidChange: var_state)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        ht_setupViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        ht_setupViews()
    }
    
    private func ht_setupViews() {
        var_player = AVPlayer()
        var_playerLayer = AVPlayerLayer(player: var_player)
        var_playerLayer?.videoGravity = .resizeAspect
        if let var_playerLayer = var_playerLayer {
            layer.addSublayer(var_playerLayer)
        }
        ht_playerAddObserver(ht_AsciiString("rate"))
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        var_playerLayer?.frame = bounds
    }
    
    // 重置播放状态
    func ht_resetPlayer() {
        
        var_playEnd = false
        var_isPlaying = false
        var_readyToPlay = false
        var_isBuffering = false
        var_seekTime = 0
        var_timer?.invalidate()
        ht_pause()
        ht_removeObserverIfNeeded()
        var_currentURL = nil
        var_playerItem = nil
        var_player?.replaceCurrentItem(with: nil)
    }
    
    // 开始播放｜替换URL
    func ht_playVideo(_ var_url: URL) {
        
        if var_currentURL == var_url {
            ht_play()
            return
        }
        ht_resetPlayer()
        var_currentURL = var_url
        var_playerItem = AVPlayerItem(url: var_url)
        var_player?.replaceCurrentItem(with: var_playerItem)
        var_player?.play()
        var_isPlaying = true
        ht_setupTimer()
    }
    
    // 播放
    func ht_play() {
        var_player?.play()
        var_isPlaying = true
        var_timer?.fireDate = Date()
    }
    
    // 暂停
    func ht_pause() {
        var_player?.pause()
        var_isPlaying = false
        var_timer?.fireDate = Date.distantFuture
    }

    // 停止
    func ht_stop() {
        var_player?.pause()
        ht_resetPlayer()
    }
    
    // seekto
    func ht_seekToTime(_ var_time: TimeInterval, var_completion: (()->Void)? = nil) {
        
        if var_time.isNaN {
            return
        }
        if self.var_player?.currentItem?.status == AVPlayerItem.Status.readyToPlay {
            let draggedTime = CMTime(value: Int64(var_time), timescale: 1)
            self.var_player!.seek(to: draggedTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero, completionHandler: { (finished) in
                var_completion?()
            })
        } else {
            self.var_seekTime = var_time
        }
    }
    
    private func ht_removeObserverIfNeeded() {
        
        if var_isObserving {
            ht_playerItemRemoveObserver(ht_AsciiString("status"))
            ht_playerItemRemoveObserver(ht_AsciiString("loadedTimeRanges"))
            ht_playerItemRemoveObserver(ht_AsciiString("playbackBufferEmpty"))
            ht_playerItemRemoveObserver(ht_AsciiString("playbackLikelyToKeepUp"))
            var_isObserving = false
        }
    }
    
    private func ht_addObserverIfNeeded() {
        // 添加观察者以捕捉播放状态的变化
        var_isObserving = true
        ht_playerItemAddObserver(ht_AsciiString("status"))
        ht_playerItemAddObserver(ht_AsciiString("loadedTimeRanges"))
        ht_playerItemAddObserver(ht_AsciiString("playbackBufferEmpty"))
        ht_playerItemAddObserver(ht_AsciiString("playbackLikelyToKeepUp"))
        NotificationCenter.default.addObserver(self, selector: #selector(ht_moviePlayDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    private func ht_setupTimer() {
        var_timer?.invalidate()
        var_timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ht_playerTimerAction), userInfo: nil, repeats: true)
        var_timer?.fireDate = Date()
    }
    
    @objc func ht_playerTimerAction() {
        
        guard let var_playerItem = var_playerItem else { return }
        
        if var_playerItem.duration.timescale != 0 {
            let var_currentTime = CMTimeGetSeconds(self.var_player!.currentTime())
            let var_totalTime = TimeInterval(var_playerItem.duration.value) / TimeInterval(var_playerItem.duration.timescale)
            var_delegate?.ht_player?(var_player: self, var_playTimeDidChange: var_currentTime, var_totalTime: var_totalTime)
        }
        ht_updateStatus(true)
    }
    
    private func ht_updateStatus(_ var_includeLoading: Bool = false) {
        
        if let var_player = var_player {
            if let var_playerItem = var_playerItem, var_includeLoading {
                if var_playerItem.isPlaybackLikelyToKeepUp || var_playerItem.isPlaybackBufferFull {
                    self.var_state = .htEnumPlayerStateBufferFinished
                } else if var_playerItem.status == .failed {
                    self.var_state = .htEnumPlayerStateError
                } else {
                    self.var_state = .htEnumPlayerStateBuffering
                }
            }
            if var_player.rate == 0.0 {
                if var_player.error != nil {
                    self.var_state = .htEnumPlayerStateError
                    return
                }
                if let var_currentItem = var_player.currentItem {
                    if var_player.currentTime() >= var_currentItem.duration {
                        ht_moviePlayDidEnd()
                        return
                    }
                    if var_currentItem.isPlaybackLikelyToKeepUp || var_currentItem.isPlaybackBufferFull {
                        
                    }
                }
            }
        }
    }
    
    @objc private func ht_moviePlayDidEnd() {
        if var_state != .htEnumPlayerStatePlayToTheEnd {
            if let var_playerItem = var_playerItem {
                var_delegate?.ht_player?(var_player: self, var_playTimeDidChange: CMTimeGetSeconds(var_playerItem.duration), var_totalTime: CMTimeGetSeconds(var_playerItem.duration))
            }
            
            self.var_state = .htEnumPlayerStatePlayToTheEnd
            self.var_isPlaying = false
            self.var_playEnd = true
            self.var_timer?.invalidate()
        }
    }
    
    // 观察者回调
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let keyPath = keyPath else {return}
        
        if let var_item = object as? AVPlayerItem, var_item == var_playerItem {
            if keyPath == ht_AsciiString("status") {
                if var_item.status == .readyToPlay {
                    if var_seekTime != 0 {
                        ht_seekToTime(var_seekTime) { [weak self] in
                            guard let self = self else {return}
                            self.var_seekTime = 0
                            self.var_readyToPlay = true
                            self.var_state = .htEnumPlayerStateReadyToPlay
                        }
                    } else {
                        self.var_readyToPlay = true
                        self.var_state = .htEnumPlayerStateReadyToPlay
                    }
                } else if var_item.status == .failed || var_player?.status == AVPlayer.Status.failed {
                    self.var_state = .htEnumPlayerStateError
                }
            } else if keyPath == ht_AsciiString("loadedTimeRanges") {
                if let var_timeInterVarl = self.ht_availableDuration() {
                    let var_totalTime = CMTimeGetSeconds(var_item.duration)
                    var_delegate?.ht_player?(var_player: self, var_loadedTimeDidChange: var_timeInterVarl, var_totalTime: var_totalTime)
                }
            } else if keyPath == ht_AsciiString("playbackBufferEmpty") {
                if var_item.isPlaybackBufferEmpty {
                    self.var_state = .htEnumPlayerStateBuffering
                    self.ht_bufferingSomeSecond()
                }
            } else if keyPath == ht_AsciiString("playbackLikelyToKeepUp") {
                if var_item.isPlaybackBufferEmpty {
                    if var_state != .htEnumPlayerStateBufferFinished && var_readyToPlay {
                        self.var_state = .htEnumPlayerStateBufferFinished
                    }
                }
            }
        } else if keyPath == ht_AsciiString("rate") {
            print("倍速变化")
        }
    }
    
    deinit {
        ht_playerRemoveObserver(ht_AsciiString("rate"))
        ht_removeObserverIfNeeded()
    }
}

extension HTClassPlayerLayerView {
    
    private func ht_playerAddObserver(_ var_string: String) {
        guard let var_player = var_player else {return}
        var_player.addObserver(self, forKeyPath: var_string, options: .new, context: nil)
    }
    
    private func ht_playerRemoveObserver(_ var_string: String) {
        guard let var_player = var_player else {return}
        var_player.removeObserver(self, forKeyPath: var_string)
    }
    
    private func ht_playerItemAddObserver(_ var_string: String) {
        guard let var_playerItem = var_playerItem else {return}
        var_playerItem.addObserver(self, forKeyPath: var_string, options: .new, context: nil)
    }
    
    private func ht_playerItemRemoveObserver(_ var_string: String) {
        guard let var_playerItem = var_playerItem else {return}
        var_playerItem.removeObserver(self, forKeyPath: var_string)
    }
    
    // 获取可播放时长
    private func ht_availableDuration() -> TimeInterval? {
        
        if let var_loadedTimeRanges = var_player?.currentItem?.loadedTimeRanges, let var_first = var_loadedTimeRanges.first {
            let var_timeRange = var_first.timeRangeValue
            let var_startSeconds = CMTimeGetSeconds(var_timeRange.start)
            let var_durationSecound = CMTimeGetSeconds(var_timeRange.duration)
            let var_result = var_startSeconds + var_durationSecound
            return var_result
        }
        return nil
    }
    
    // 缓冲计算
    fileprivate func ht_bufferingSomeSecond() {
        self.var_state = .htEnumPlayerStateBuffering
        // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
        if var_isBuffering {
            return
        }
        var_isBuffering = true
        // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
        var_player?.pause()
        let var_popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * 1.0 )) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: var_popTime) {[weak self] in
            guard let self = self else { return }
            // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
            self.var_isBuffering = false
            if let var_playerItem = self.var_playerItem {
                if !var_playerItem.isPlaybackLikelyToKeepUp {
                    self.ht_bufferingSomeSecond()
                } else {
                    // 如果此时用户已经暂停了，则不再需要开启播放了
                    self.var_state = .htEnumPlayerStateBufferFinished
                }
            }
        }
    }
}
