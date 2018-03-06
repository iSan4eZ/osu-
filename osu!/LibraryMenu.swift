//
//  LibraryMenu.swift
//  osu!
//
//  Created by Stas Panasuk on 2/27/18.
//  Copyright © 2018 iSan4eZ. All rights reserved.
//

import UIKit
import AVFoundation

class LibraryMenu: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct Song {
        var url : URL!
        var name : String!
        var diffs = [Diff]()
    }
    
    //Настройки отдельных сложностей. По идее, должны храниться в сложности
    struct Settings {
        var background : Bool!
        var video : Bool!
        var backgroundOpacity : CGFloat
    }
    
    var Library = [Song]()
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var tvSongs: UITableView!
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.backgroundImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 50),
            self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 50),
            self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -50),
            self.backgroundImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -50)
            ])
        backgroundImageView.superview!.layoutIfNeeded()
        
        applyMotionEffect(toView: backgroundImageView, magnitude: 10)
        tvSongs.delegate = self
        tvSongs.dataSource = self
        loadLibrary()
        if Library.count > 0{
            let randomIndex = Int(arc4random_uniform(UInt32(tvSongs.numberOfRows(inSection: 0))))
            tvSongs.selectRow(at: IndexPath(row: randomIndex, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.middle)
            tableView(tvSongs, didSelectRowAt: IndexPath(row: randomIndex, section: 0))
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
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playClicked(_ sender: Any) {
        //Play clicked
        player?.stop()
        let GameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameVC")
        present(GameVC, animated: true) {
            print("Completed")
            //completition code
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        var count = 0
        for song in Library{
            count += song.diffs.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tvSongs.dequeueReusableCell(withIdentifier: "songCell") as! CustomSongCell
        
        var index = 0
        for i in 0...Library.count-1{
            for j in 0...Library[i].diffs.count-1{
                if index == indexPath.row{
                    cell.nameLbl.text = Library[i].diffs[j].metadata.Title
                    cell.diffLbl.text = Library[i].diffs[j].metadata.Version
                    cell.difficulty = Library[i].diffs[j]
                }
                index += 1
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
         -Вызывается при смене выбранной ячейки из tvSongs. Надо, чтобы там отображались только Song'и и, после выбора определённого, выдвигались его сложности. Ниже есть MapSelected, правда, не знаю, зачем
         */
        let selectedCell = tableView.cellForRow(at: indexPath) as! CustomSongCell
        backgroundImageView.image = UIImage(contentsOfFile: selectedCell.difficulty.imageUrl!.path)
        if player?.url != selectedCell.difficulty.audioUrl{
            do {
                player = try AVAudioPlayer(contentsOf: selectedCell.difficulty.audioUrl)
                player!.numberOfLoops = -1
                player!.prepareToPlay()
                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
                player!.play()
            } catch {
                print("Erorr playing audio: \(error)")
            }
        }
    }
    
    func loadLibrary(){
        let fileManager = FileManager.default
        let libraryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Songs", isDirectory: true)
        let dirsURLs = libraryURL.subDirectories
        for url in dirsURLs{
            var song = Song(url: url, name: url.lastPathComponent, diffs: [Diff]())
            for file in url.filesOfType(fileType: "osu"){
                song.diffs.append(Diff(fileUrl: file))
            }
            Library.append(song)
        }
    }
    
    func mapSelected(index: Int){
        /*
         -Вызывается при смене выбранной карты.
         -Должен открывать все сложности карты и выбирать максимальную сложность из тех, которые пройдены
         -После выбора сложности вызввать метод смены сложности
         */
    }
    
    func difficultySelected(index: Int){
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
