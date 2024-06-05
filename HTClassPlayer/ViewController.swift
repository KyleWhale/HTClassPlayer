//
//  ViewController.swift
//  HTClassPlayer
//
//  Created by 李雪健 on 2024/6/4.
//

import UIKit

class ViewController: UIViewController {
    
    let url = """
    https://vdept3.bdstatic.com/mda-mfuf163rfmkn36i7/sc/cae_h264_nowatermark/1624963807340099361/mda-mfuf163rfmkn36i7.mp4?v_from_s=hkapp-haokan-hbf&auth_key=1717592070-0-0-de3314102b468b51a7333ae2e218e106&bcevod_channel=searchbox_feed&pd=1&cr=2&cd=0&pt=3&logid=3270086284&vid=10554454971571011271&klogid=3270086284&abtest=101830_2-17451_2
    """
    
    let player = HTClassPlayerControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        player.var_delegate = self
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
            // 这里的model最好保存下来使用 用来切换选中状态 例如字幕、播放状态、收藏状态等
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
        }
    }
    
    func ht_image(_ var_count: Int) -> String {
        return "https://autoeq.top/img/ios2/\(var_count)@3x.png"
    }
}

extension ViewController {
    
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

extension ViewController: HTClassPlayerControlDelegate {
    
    func ht_playerControl(var_playerControl: HTClassPlayerControl, var_didClickWith var_model: HTClassPlayerControlModel) {
        
        if var_model.var_type == .htEnumControlTypePlayPause {
            
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
            if player.var_isFullScreen {
                player.ht_fullScreen()
            } else {
                // back
            }
        }
        if var_model.var_type == .htEnumControlTypeFullscreen {
            player.ht_fullScreen()
        }
        print("--------> \(var_model.var_type)")
    }
}
