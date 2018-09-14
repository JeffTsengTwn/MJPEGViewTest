//
//  ViewController.swift
//  MJPEGViewTest
//
//  Created by 曾勝億 on 2018/9/13.
//  Copyright © 2018年 曾勝億. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var camera: IPCameraView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        camera.startWithURL(url: URL(string: "")!)
    }


}

