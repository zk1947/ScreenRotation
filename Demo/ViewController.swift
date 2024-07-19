//
//  ViewController.swift
//  Demo
//
//  Created by 赵凯 on 2024/6/27.
//

import UIKit

class ViewController: UIViewController {

    var button: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let button1 = UIButton(frame: CGRect(x: 50, y: 150, width: 200, height: 50))
        button1.backgroundColor = .red
        button1.setTitle("手动转屏", for: .normal)
        button1.addTarget(self, action: #selector(switchOrientation), for: .touchUpInside)
        self.view.addSubview(button1)
        
        let button2 = UIButton(frame: CGRect(x: 10, y: 250, width: UIScreen.main.bounds.width-20, height: 50))
        button2.backgroundColor = .red
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button2.setTitle("跳页:如果当前页是横屏而跳转页面不支持横屏先旋转屏幕后再跳页", for: .normal)
        button2.addTarget(self, action: #selector(switchOrientation2), for: .touchUpInside)
        button = button2
        self.view.addSubview(button2)
        
    }

    @objc func switchOrientation() {
        if let windowScene = view.window?.windowScene {
            if windowScene.interfaceOrientation.isPortrait {
                windowScene.setInterfaceOrientation(.landscapeRight)
                // 恢复为支持所有方向
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.orientationLock = .all
                }
            } else {
                windowScene.setInterfaceOrientation(.portrait)
                // 恢复为支持所有方向
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.orientationLock = .all
                }
            }
        }
    }
    
    @objc func switchOrientation2() {
        if let windowScene = view.window?.windowScene {
            if UIDevice.current.orientation.isCurrentScreenPortrait() == false {
                windowScene.setInterfaceOrientation(.portrait)
                //UIDevice.current.orientation.interfaceOrientation
            }
            // 恢复为支持所有方向
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.orientationLock = .all
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: {
            let vc = TestViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    /// 横竖屏旋转监听
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass {
            // 横竖屏UI适配
            if UIDevice.current.orientation.isCurrentScreenPortrait() {
                button?.frame = CGRect(x: 10, y: 250, width: UIScreen.main.bounds.width-20, height: 50)
            } else {
                button?.frame = CGRect(x: 80, y: 250, width: UIScreen.main.bounds.width-160, height: 50)
            }
        }
    }
}

extension UIDeviceOrientation {
    /// 获取当前屏幕方向
    var interfaceOrientation: UIInterfaceOrientation {
        switch self {
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeRight // 注意：设备的左旋是界面的右旋
        case .landscapeRight:
            return .landscapeLeft // 注意：设备的右旋是界面的左旋
        case .faceUp, .faceDown, .unknown:
            return .unknown
        @unknown default:
            return .unknown
        }
    }
    
    /// 判断当前屏幕是否是竖屏
    func isCurrentScreenPortrait() -> Bool {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first ?? UIWindow()
        let orientation = window.windowScene?.interfaceOrientation
        switch orientation {
        case .portrait, .portraitUpsideDown:
            return true
        case .landscapeLeft, .landscapeRight:
            return false
        default:
            return true
        }
    }
}
