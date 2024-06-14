//
//  ViewController.swift
//  Runner
//
//  Created by 李雪健 on 2024/6/4.
//

import UIKit
import HTClassPlayer

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // 字幕
        HTClassSubtitleManager.ht_parseSubtitleFile(URL(fileURLWithPath: Bundle.main.path(forResource: "1646479031.95.movie_v1.14898.English", ofType: "srt") ?? "")) { var_dictionary in
            print("---> \(var_dictionary)")
        }
    }
    @IBAction func playAction(_ sender: Any) {
        self.navigationController?.pushViewController(VideoPlayerController(), animated: true)
    }
}
