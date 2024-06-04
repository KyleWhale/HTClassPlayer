//
//  ViewController.swift
//  HTClassPlayer
//
//  Created by 李雪健 on 2024/6/4.
//

import UIKit

class ViewController: UIViewController {
    
    let url = """
    https://vdept3.bdstatic.com/mda-mfuf163rfmkn36i7/sc/cae_h264_nowatermark/1624963807340099361/mda-mfuf163rfmkn36i7.mp4?v_from_s=hkapp-haokan-hbf&auth_key=1717511385-0-0-cfcdefa79a434f8969ab1a94f33c093e&bcevod_channel=searchbox_feed&pd=1&cr=2&cd=0&pt=3&logid=1785545283&vid=10554454971571011271&klogid=1785545283&abtest=101830_2-17451_2
    """

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let player = HTClassPlayerLayerView()
        player.var_delegate = self
        view.addSubview(player)
        player.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(view.snp.width).multipliedBy(9.0 / 16.0)
        }
        if let var_videoURL = URL(string: url) {
            player.ht_playVideo(var_videoURL)
        }
    }
}

extension ViewController: HTClassPlayerLayerViewDelegate {
    
    func ht_player(var_player: HTClassPlayerLayerView, var_playTimeDidChange var_currentTime: TimeInterval, var_totalTime: TimeInterval) {
        print("playTimeDidChange -----> \(var_currentTime) -- \(var_totalTime)")
    }
    
//    func ht_player(var_player: HTClassPlayerLayerView, var_loadedTimeDidChange var_loadedDuration: TimeInterval, var_totalDuration: TimeInterval) {
//        print("loadTimechange -----> \(var_loadedDuration) -- \(var_totalDuration)")
//    }
    
    func ht_player(var_player: HTClassPlayerLayerView, var_playerStateDidChange var_state: HTEnumPlayerState) {
        print("state -----> \(var_state)")
    }
}
