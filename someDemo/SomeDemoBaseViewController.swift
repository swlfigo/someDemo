//
//  SomeDemoBaseViewController.swift
//  someDemo
//
//  Created by sylar on 2025/6/24.
//

import Foundation
import UIKit

struct DemoVCInitialParams {
    let name: String
    let vcCls : String
    var params: [String: Any] = [:]
}

class SomeDemoBaseViewController: UIViewController {
    var paramDic: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
    }
}
