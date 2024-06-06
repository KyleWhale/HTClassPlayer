//
//  ViewController.swift
//  Runner
//
//  Created by 李雪健 on 2024/6/4.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func playAction(_ sender: Any) {
        self.navigationController?.pushViewController(VideoPlayerController(), animated: true)
    }
}
