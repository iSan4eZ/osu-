//
//  MainMenu.swift
//  osu!
//
//  Created by Stas Panasuk on 2/27/18.
//  Copyright © 2018 iSan4eZ. All rights reserved.
//

import UIKit
import Zip
import AVFoundation

class MainMenu: UIViewController {

    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var menuBackgroundImage: UIImageView!
    
    let playButton = UIButton()
    let settingsButton = UIButton()
    
    var initialConstraints = [NSLayoutConstraint]()
    var newConstraints = [NSLayoutConstraint]()
    var mainButtonConstraints = [NSLayoutConstraint]()
    var isMainButtonPressed = false
    
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
        
        applyMotionEffect(toView: menuBackgroundImage, magnitude: 10)
        applyMotionEffect(toView: mainButton, magnitude: -10)
        applyMotionEffect(toView: playButton, magnitude: -10)
        applyMotionEffect(toView: settingsButton, magnitude: -10)
        
        prepareLibrary()
        
        menuBackgroundImage.layer.zPosition = -1
        mainButton.layer.zPosition = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        if !isMainButtonPressed {
            playButton.frame = CGRect(x: mainButton.center.x - mainButton.frame.width/3.5, y: mainButton.center.y - mainButton.frame.width/5, width: mainButton.frame.width/1.5, height: mainButton.frame.width/5)
            playButton.layer.zPosition = 0
            view.addSubview(playButton)
            settingsButton.frame = CGRect(x: mainButton.center.x - mainButton.frame.width/3.5 , y: mainButton.center.y + mainButton.frame.width/10, width: mainButton.frame.width/1.5, height: mainButton.frame.width/5)
            settingsButton.layer.zPosition = 0
            view.addSubview(settingsButton)
            playButton.backgroundColor = UIColor.purple
            settingsButton.backgroundColor = UIColor.purple
            
            self.playButton.isUserInteractionEnabled = true
            self.settingsButton.isUserInteractionEnabled = true
            //===================================
            //let target = MyTarget()
            playButton.addTarget(target, action: #selector(buttonPressed), for: .touchDown)
            //=======================================
            isMainButtonPressed = true
       UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            self.mainButton.transform = CGAffineTransform(translationX: -self.mainButton.frame.width/4, y: 0)
            
            self.playButton.transform = CGAffineTransform(translationX: self.mainButton.frame.width/3.5, y: 0)
            self.settingsButton.transform = CGAffineTransform(translationX: self.mainButton.frame.width/3.5, y: 0)
            })

        }else if isMainButtonPressed{
            isMainButtonPressed = false
           self.playButton.isUserInteractionEnabled = false
            self.settingsButton.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 8, options: .curveEaseInOut, animations: {
                self.mainButton.transform = CGAffineTransform(translationX: 0, y: 0)

                self.playButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.settingsButton.transform = CGAffineTransform(translationX: 0, y: 0)
                
            })
        }
    }
    
        @objc func buttonPressed(sender: UIButton!){
        //=======================Действие кнопки play=======================
            print("pressed")
            
            prepareLibrary()
            let LibraryMenuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LibraryMenuVC")
            present(LibraryMenuVC, animated: true) {
                print("Completed")
                
                //completition code
            }
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
            if url.isDirectory && !url.path.contains(".Trash") {
                do
                {
                    for file in try manager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil){
                        if current + 1 <= max{
                            parseUnZip(url: file, current: current+1, max: max)
                        }
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

extension URL {
    var isDirectory: Bool {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
    var subDirectories: [URL] {
        guard isDirectory else { return [] }
        return (try? FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]).filter{ $0.isDirectory }) ?? []
    }
    func filesOfType(fileType: String) -> [URL]{
        return (try? FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]).filter{ $0.pathExtension == fileType }) ?? []
    }
}
