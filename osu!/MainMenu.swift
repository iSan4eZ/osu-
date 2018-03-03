//
//  MainMenu.swift
//  osu!
//
//  Created by Stas Panasuk on 2/27/18.
//  Copyright © 2018 iSan4eZ. All rights reserved.
//

import UIKit
import Zip

class MainMenu: UIViewController {

    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var menuBackgroundImage: UIImageView!
    
    var initialConstraints = [NSLayoutConstraint]()
    var newConstraints = [NSLayoutConstraint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Zip.addCustomFileExtension("osz")
        
        initialConstraints.append(self.mainButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/2))
        initialConstraints.append(self.mainButton.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/2))
        initialConstraints.append(self.menuBackgroundImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        initialConstraints.append(self.menuBackgroundImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        initialConstraints.append(self.menuBackgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor))
        initialConstraints.append(self.menuBackgroundImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        
        NSLayoutConstraint.activate(initialConstraints)
        self.mainButton.layoutIfNeeded()
        self.menuBackgroundImage.layoutIfNeeded()
        
        NSLayoutConstraint.deactivate(self.initialConstraints)
        
        newConstraints.append(self.mainButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 2/3))
        newConstraints.append(self.mainButton.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 2/3))
        newConstraints.append(self.menuBackgroundImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 50))
        newConstraints.append(self.menuBackgroundImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 50))
        newConstraints.append(self.menuBackgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -50))
        newConstraints.append(self.menuBackgroundImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -50))
        
        NSLayoutConstraint.activate(self.newConstraints)
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseOut, animations: {
            self.mainButton.superview!.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 2) {
            self.mainButton.alpha = 1
            self.menuBackgroundImage.alpha = 1
        }
        
        
        applyMotionEffect(toView: menuBackgroundImage, magnitude: 10)
        applyMotionEffect(toView: mainButton, magnitude: -10)
        
        prepareLibrary()
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
         -Выдвигать меню с кнопками "Play" и "Settings". На пока что хватит.
         -Если кнопки уже выдвинуты, то задвигать их. То есть, где-то булевая переменная isOpen, или что-то в этом роде
         -По нажатию на "Play" вызывать LibraryMenu сцену.
         -По нажатию на "Settings" вызывать выдвигающееся откуда-нибудь меню с настройками.
         -В настройки добавить выключатель параллакс эффекта, задание настроек для карт по умолчанию, например, будет ли проигрываться видео, непрозрачность фонового изображения и прочая хрень, связанная с этим. Так же туда ещё выбор скинов и настройку громкости.
         -Все настройки хранить в файлике Settings, расположенном в локальном, доступном пользователю хранилище
         */
    }
    
    func prepareLibrary(){
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            for url in fileURLs{
                parseUnZip(url: url, current: 1, max: 2)
            }
        } catch {
            print("Error while enumerating files")
        }
    }
    
    func parseUnZip(url: URL, current: Int, max: Int){
        if current <= max{
            let manager = FileManager.default
            var isDir : ObjCBool?
            if manager.fileExists(atPath: url.path, isDirectory: &isDir!) {
                do
                {
                    for file in try manager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil){
                        parseUnZip(url: file, current: current+1, max: max)
                    }
                } catch {
                    print("parseUnZip error: \(error)")
                }
            } else {
                if url.pathExtension == "osz" || url.pathExtension == "osk"{
                    unZip(url: url, deleteAfter: true)
                }
            }
        }
    }
    
    func unZip(url: URL, deleteAfter: Bool){
        do
        {
            let manager = FileManager.default
            var documentsDirectory : URL!
            if url.pathExtension == "osz"{
                documentsDirectory = manager.urls(for:.documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Songs/\(url.deletingPathExtension().lastPathComponent)", isDirectory: true)
            } else if url.pathExtension == "osk" {
                documentsDirectory = manager.urls(for:.documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Skins/\(url.deletingPathExtension().lastPathComponent)", isDirectory: true)
            } else {
                print("Detected not osu package")
                return
            }
            try Zip.unzipFile(url, destination: documentsDirectory, overwrite: true, password: nil)
            if deleteAfter{
                try manager.removeItem(at: url)
            }
            url.stopAccessingSecurityScopedResource()
        } catch {
            print("Error while unzipping: \(error)\n")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
