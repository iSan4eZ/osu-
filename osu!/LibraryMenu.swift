//
//  LibraryMenu.swift
//  osu!
//
//  Created by Stas Panasuk on 2/27/18.
//  Copyright © 2018 iSan4eZ. All rights reserved.
//

import UIKit

class LibraryMenu: UIViewController {
    
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
    /*
     -Тут будет структура "Song" и массив "Library" из треков.
     -Track должен в себе хранить URL'ы на все сложности (.osu файлы в папке с картой)
     -Каждая сложность - отдельная структура, содержащая URL'ы на музыку, фоновую картинку, файл .osu, скин по умолчанию и прочее, что может относиться к сложности
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLibrary()
    }
    
    func loadLibrary(){
        /*
         -Проходить по всем папкам в Songs локального хранилища и добавлять в массив Library все карты и сложности.
         -Выводить в список все эти карты и включать какую-то рандомную, вызывая mapSelected()
         */
    }
    
    func mapSelected(index: Int){
        /*
         -Вызывается при смене выбранной карты.
         -Должен открывать все сложности карты и выбирать максимальную сложность из тех, которые пройдены
         -После выбора сложности вызввать difficultySelected(index: Int)
         */
    }
    
    func difficultySelected(index: Int){
        /*
         -Вызывается при смене выбранной сложности.
         -Должен менять фон на фон карты, включать музыку этой карты и выводить инфу о ней.
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class Diff {
    var version : Int!
    var url : URL!
    var name : String!
    var audio : URL!
    var osb : OSB!
    
    struct OSB{
        //анимация фона
    }
    
    var general : General!
    var editor : Editor!
    var metadata : Metadata!
    var difficulty : Difficulty!
    var events : Events!
    var timingPoints : TimingPoints!
    var colours : Colours!
    var hitObjects : HitObjects!
    
    enum Part {
        case none
        case general
        case editor
        case metadata
        case difficulty
        case events
        case timingPoints
        case colours
        case hitObjects
    }
    
    struct General {
        var AudioFilename : String!
        var AudioLeadIn : Int!
        var PreviewTime : Int!
        var Countdown : Bool!
        var SampleSet : String!
        var StackLeniency : Decimal!
        var Mode : Int!
        var LetterboxInBreaks : Bool!
        var WidescreenStoryboard : Bool!
    }
    
    struct Editor {
        var Bookmarks : [Int]!
        var DistanceSpacing : Decimal!
        var BeatDivisor : Int!
        var GridSize : Int!
        var TimelineZoom : Int!
    }
    
    struct Metadata {
        var Title : String!
        var TitleUnicode : String!
        var Artist : String!
        var ArtistUnicode : String!
        var Creator : String!
        var Version : String!
        var Source : String!
        var Tags : [String]!
        var BeatmapID : Int!
        var BeatmapSetID : Int!
    }
    
    struct Difficulty {
        var HPDrainRate : Decimal!
        var CircleSize : Decimal!
        var OverallDifficulty : Decimal!
        var ApproachRate : Decimal!
        var SliderMultiplier : Decimal!
        var SliderTickRate : Decimal!
    }
    
    struct Events {
        
    }
    
    struct TimingPoints {
        
    }
    
    struct Colours {
        
    }
    
    struct HitObjects {
        
    }
    
    private var stage : Part!
    
    init(fileUrl: URL) {
        do
        {
            var text = [String]()
            try String(contentsOf: fileUrl).enumerateLines {
                (line, _) in text.append(line)
            }
            stage = .none
            for line in text{
                if stage == .none{
                    if line.starts(with: "osu file format v") {
                        version = Int(line.replacingOccurrences(of: "osu file format v", with: ""))
                        continue
                    } else if line.contains("[General]") {
                        stage = .general
                        continue
                    } else if line.contains("[Editor]") {
                        stage = .editor
                        continue
                    } else if line.contains("[Metadata]") {
                        stage = .metadata
                        continue
                    } else if line.contains("[Difficulty]") {
                        stage = .difficulty
                        continue
                    } else if line.contains("[Events]") {
                        stage = .events
                        continue
                    } else if line.contains("[TimingPoints]") {
                        stage = .timingPoints
                        continue
                    } else if line.contains("[Colours]") {
                        stage = .colours
                        continue
                    } else if line.contains("[HitObjects]") {
                        stage = .hitObjects
                        continue
                    }
                } else {
                    if line.isEmpty{
                        stage = .none
                        continue
                    } else {
                        //if stage ==
                    }
                }
            }
        } catch {
            print("Error while reading difficulty: \(error)")
        }
    }
}
