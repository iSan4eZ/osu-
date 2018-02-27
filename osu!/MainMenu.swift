//
//  MainMenu.swift
//  osu!
//
//  Created by Stas Panasuk on 2/27/18.
//  Copyright © 2018 iSan4eZ. All rights reserved.
//

import UIKit

class MainMenu: UIViewController {

    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var menuBackgroundImage: UIImageView!
    
    /*
     Тут будет структура "Track" и массив из треков.
     Track должен в себе хранить URL'ы на все сложности, музыку, картинки и всё, что отновится к карте.
     Каждая сложность - отдельная структура, наверное. Ещё не придумал, как будет
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 2) {
            self.mainButton.alpha = 1
            self.menuBackgroundImage.alpha = 1
        }
        
        /*
         Убрать Constrains от кнопки и сделать анимацию её приближения во время появления
         */
        
        applyMotionEffect(toView: menuBackgroundImage, magnitude: 10)
        applyMotionEffect(toView: mainButton, magnitude: -10)
        
        fetchLibrary()
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
    
    @IBAction func mainButtonClicked(_ sender: Any) {
        /*
         Выдвигать меню с кнопками "Играть" и "Настройки". На пока что хватит
         */
    }
    
    func fetchLibrary(){
        /*
         Каждый url в корневом каталоге приложения проверять на .zip. Если .zip, то вызывать unZip().
         После анзипа всех .zip файлов проходить по всем папкам и добавлять в массив Library все карты и сложности
        */
    }
    
    func unZip(url: URL, deleteAfter: Bool){
        /*
         по отправленному URL разархивировать содержимое. После этого либо удалять архив, либо нет - решает Bool
         */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
