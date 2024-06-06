//
//  VideoPlayerController.swift
//  Runner
//
//  Created by 李雪健 on 2024/6/6.
//

import Foundation
import UIKit
import HTClassPlayer

class VideoPlayerController: UIViewController, UIGestureRecognizerDelegate {
    
    let url = """
    https://autoeq.top/tlvsn/3148e0d49c2b71cd0f932ca47dbdf979/3148e0d49c2b71cd0f932ca47dbdf979.m3u8?expire=1717661030&auth=20119aa62270f36055349a63762b533b52222e049980bc2e3341c7ab4336c505&xaid=43C637DE-5FAB-4A17-9BE6-E90D306B1D68&p1=132432,347,103.152.113.155
    """
    
    let player = HTClassPlayerControl()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        view.backgroundColor = .white
        player.var_delegate = self
        player.var_isAutoLoop = true
        view.addSubview(player)
        let var_isFullScreen = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height
        if var_isFullScreen {
            ht_resetControl(true)
            self.player.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            ht_resetControl(false)
            self.player.snp.makeConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                make.left.right.equalToSuperview()
                make.height.equalTo(self.view.snp.width).multipliedBy(9.0 / 16.0)
            }
        }
        if let var_videoURL = URL(string: url) {
            player.ht_playVideo(var_videoURL)
        }
    }
    
    func ht_resetControl(_ var_isFullscreen: Bool) {
        
        if var_isFullscreen {
            // 这里的model最好保存下来使用 用来切换选中状态 例如字幕、播放状态、收藏状态等ht_setSelected()
            player.var_topControl.ht_reloadData([
                HTClassPlayerControlModel().ht_type(.htEnumControlTypeBack).ht_image(ht_image(39)),
                HTClassPlayerControlModel().ht_type(.htEnumControlTypeTitle).ht_title("Godzilla x Kong: The New Empire"),
                HTClassPlayerControlModel().ht_type(.htEnumControlTypeSpacer),
                HTClassPlayerControlModel().ht_type(.htEnumControlTypeCast).ht_image(ht_image(177)),
                HTClassPlayerControlModel().ht_type(.htEnumControlTypeShare).ht_image(ht_image(124)),
                HTClassPlayerControlModel().ht_type(.htEnumControlTypeCC).ht_image(ht_image(155)),
                HTClassPlayerControlModel().ht_type(.htEnumControlTypeCollection).ht_image(ht_image(176)),
            ])
            player.var_bottomControl.ht_reloadData([
                [
                    HTClassPlayerControlModel().ht_type(.htEnumControlTypeProgresss)
                ],
                [
                    HTClassPlayerControlModel().ht_type(.htEnumControlTypePlayPause).ht_image(ht_image(180)).ht_selectImage(ht_image(181)).ht_setSelected(player.var_isPlaying),
                    HTClassPlayerControlModel().ht_type(.htEnumControlTypeNextEpisode).ht_image(ht_image(179)),
                    HTClassPlayerControlModel().ht_type(.htEnumControlTypeSpacer),
                    HTClassPlayerControlModel().ht_type(.htEnumControlTypeEpisodes).ht_title("Episode"),
                ]
            ])
            player.var_leftControl.ht_reloadData([
                HTClassPlayerControlModel().ht_type(.htEnumControlTypeLock).ht_image(ht_image(182)).ht_selectImage(ht_image(183)),
                HTClassPlayerControlModel().ht_type(.htEnumControlTypeRemoveAd).ht_image(ht_image(184)),
            ])
            player.var_centerControl.ht_reloadData([
                HTClassPlayerControlModel().ht_type(.htEnumControlTypeBackward).ht_image(ht_image(100)).ht_imageWidth(40),
                HTClassPlayerControlModel().ht_type(.htEnumControlTypeFullScreenPlayPause).ht_image(ht_image(185)).ht_selectImage(ht_image(186)).ht_imageWidth(44).ht_setSelected(player.var_isPlaying),
                HTClassPlayerControlModel().ht_type(.htEnumControlTypeForward).ht_image(ht_image(103)).ht_imageWidth(40)
            ])

        } else {
            player.var_topControl.ht_reloadData([
                HTClassPlayerControlModel().ht_type(.htEnumControlTypeBack).ht_image(ht_image(39)),
                HTClassPlayerControlModel().ht_type(.htEnumControlTypeSpacer),
                HTClassPlayerControlModel().ht_type(.htEnumControlTypeCast).ht_image(ht_image(177)),
                HTClassPlayerControlModel().ht_type(.htEnumControlTypeShare).ht_image(ht_image(124)),
                HTClassPlayerControlModel().ht_type(.htEnumControlTypeCC).ht_image(ht_image(155)),
                HTClassPlayerControlModel().ht_type(.htEnumControlTypeCollection).ht_image(ht_image(176)),
            ])
            player.var_bottomControl.ht_reloadData([
                [
                    HTClassPlayerControlModel().ht_type(.htEnumControlTypePlayPause).ht_image(ht_image(180)).ht_selectImage(ht_image(181)).ht_setSelected(player.var_isPlaying),
                    HTClassPlayerControlModel().ht_type(.htEnumControlTypeProgresss),
                    HTClassPlayerControlModel().ht_type(.htEnumControlTypeFullscreen).ht_image(ht_image(83)),
                ]
            ])
            player.var_leftControl.ht_reloadData([
                HTClassPlayerControlModel().ht_type(.htEnumControlTypeRemoveAd).ht_image(ht_image(184)),
            ])
            player.var_centerControl.ht_reloadData([])
        }
    }
    
    func ht_image(_ var_count: Int) -> String {
        return "https://autoeq.top/img/ios2/\(var_count)@3x.png"
    }
    
    deinit {
        print("播放页释放")
        player.ht_prepareToDeinit()
    }
}

extension VideoPlayerController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        if size.width > size.height {
            ht_resetControl(true)
            self.player.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            ht_resetControl(false)
            self.player.snp.remakeConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                make.left.right.equalToSuperview()
                make.height.equalTo(self.view.snp.width).multipliedBy(9.0 / 16.0)
            }
        }
    }
}

extension VideoPlayerController: HTClassPlayerControlDelegate {
    
    func ht_playerControl(var_playerControl: HTClassPlayerControl, var_playerStateDidChange var_state: HTEnumPlayerState) {
     
        if var_state == .htEnumPlayerStateBuffering && player.var_currentTime != 0 && !player.var_isSeeking {
            // 卡顿计数 排除首次加载和seek
            print("-----> 卡顿一次")
        }
    }
    
    func ht_playerControl(var_playerControl: HTClassPlayerControl, var_playTimeDidChange var_currentTime: TimeInterval, var_totalTime: TimeInterval) {
        print("playTimeDidChange -----> \(var_currentTime) -- \(var_totalTime)")
    }
    
    func ht_playerControl(var_playerControl: HTClassPlayerControl, var_isPlaying: Bool) {
        print("isPlaying -----> \(var_isPlaying)")
    }
    
    func ht_playerControl(var_playerControl: HTClassPlayerControl, var_didClickWith var_model: HTClassPlayerControlModel) {
        
        print("-----> \(var_model.var_type)")
        if var_model.var_type == .htEnumControlTypePlayPause || var_model.var_type == .htEnumControlTypeFullScreenPlayPause {
            // 播放暂停
            if player.var_isPlaying {
                player.ht_pause()
            } else {
                player.ht_play()
            }
        }
        if var_model.var_type == .htEnumControlTypeCollection {
            // 模拟修改图片
            var_model.ht_image(ht_image(149))
        }
        if var_model.var_type == .htEnumControlTypeBack {
            // 返回
            if player.var_isFullScreen {
                player.ht_fullScreen()
            } else {
                // back
                self.navigationController?.popViewController(animated: true)
            }
        }
        if var_model.var_type == .htEnumControlTypeFullscreen {
            // 全屏
            player.ht_fullScreen()
        }
        if var_model.var_type == .htEnumControlTypeLock {
            // 锁
            if var_model.var_isSelected {
                // 解锁
                ht_resetControl(true)
            } else {
                // 锁 限制横竖屏
                player.var_leftControl.ht_reloadData([
                    HTClassPlayerControlModel().ht_type(.htEnumControlTypeLock).ht_image(ht_image(182)).ht_selectImage(ht_image(183)).ht_setSelected(true),
                ])
                player.var_topControl.ht_reloadData([])
                player.var_centerControl.ht_reloadData([])
                player.var_bottomControl.ht_reloadData([[]])
            }
        }
        if var_model.var_type == .htEnumControlTypeNextEpisode {
            // 下一集
            if let var_videoURL = URL(string: "https://highlight-video.cdn.bcebos.com/video/6s/160b95c0-1faa-11ef-8027-6c92bf5b40f4.mp4") {
                player.ht_playVideo(var_videoURL)
            }
        }
        if var_model.var_type == .htEnumControlTypeBackward {
            // 后退10s
            player.ht_seekToTime(player.var_player.var_currentTime - 10)
        }
        if var_model.var_type == .htEnumControlTypeForward {
            // 前进10s
            player.ht_seekToTime(player.var_player.var_currentTime + 10)
        }
    }
}

// 测试扩展
extension HTEnumControlType {
    
    static let htEnumControlTypeSubtitle = HTEnumControlType(18)
}
