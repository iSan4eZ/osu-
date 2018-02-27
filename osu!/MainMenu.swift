//
//  MainMenu.swift
//  osu!
//
//  Created by Stas Panasuk on 2/27/18.
//  Copyright © 2018 iSan4eZ. All rights reserved.
//

import UIKit

class MainMenu: UIViewController {

    @IBOutlet weak var mainButton: UIImageView!
    @IBOutlet weak var menuBackgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyMotionEffect(toView: menuBackgroundImage, magnitude: 10)
        applyMotionEffect(toView: mainButton, magnitude: -10)
    }

    func applyMotionEffect (toView view:UIView, magnitude: Float){
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
