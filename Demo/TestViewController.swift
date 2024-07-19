//
//  TestViewController.swift
//  Demo
//
//  Created by 赵凯 on 2024/6/27.
//

import UIKit

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
        
        let button1 = UIButton(frame: CGRect(x: 50, y: 100, width: 200, height: 50))
        button1.backgroundColor = .red
        button1.setTitle("锁定当前屏幕", for: .normal)
        button1.addTarget(self, action: #selector(lockOrientation), for: .touchUpInside)
        self.view.addSubview(button1)
        
        let button2 = UIButton(frame: CGRect(x: 50, y: 200, width: 200, height: 50))
        button2.backgroundColor = .red
        button2.setTitle("解锁当前屏幕", for: .normal)
        button2.addTarget(self, action: #selector(unlockOrientation), for: .touchUpInside)
        self.view.addSubview(button2)
    }

    @objc func lockOrientation() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.orientationLock = interfaceOrientationMask(from: UIDevice.current.orientation)
        }
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    @objc func unlockOrientation() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.orientationLock = .all
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: {
            UIViewController.attemptRotationToDeviceOrientation()
        })
    }
    
    func interfaceOrientationMask(from deviceOrientation: UIDeviceOrientation) -> UIInterfaceOrientationMask {
        switch deviceOrientation {
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        // 添加其他需要的情况，例如 .faceUp 和 .faceDown，如果需要的话
        default:
            return []
        }
    }
}
