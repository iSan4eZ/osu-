//
//  Diff.swift
//  osu!
//
//  Created by Stas Panasuk on 3/4/18.
//  Copyright © 2018 iSan4eZ. All rights reserved.
//

import UIKit

class Diff {
    var version : Int!
    var url : URL!
    var osb : OSB!
    var audioUrl : URL!
    var imageUrl : URL!
    
    struct OSB{
        //анимация фона
    }
    
    var general = General()
    var editor = Editor()
    var metadata = Metadata()
    var difficulty = Difficulty()
    var events = Events()
    var timingPoints = [TimingPoint]()
    var colours = [Colour]()
    var hitObjects = [HitObject]()
    
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
    
    enum eventsPart {
        case BackgroundAndVideo
        case BreakPeriods
        case StoryboardBackground
        case StoryboardFail
        case StoryboardPass
        case StoryboardForeground
        case StoryboardSoundSamples
    }
    
    struct General {
        var AudioFilename : String? //location of the audio file relative to the current folder.
        var AudioLeadIn : Int? //amount of time added before the audio file begins playing. Useful for audio files that begin immediately.
        var PreviewTime : Int? //defines when the audio file should begin playing when selected in the song selection menu.
        var Countdown : Bool? //specifies whether or not a countdown occurs before the first hit object appears.
        var SampleSet : String? //specifies which set of hit sounds will be used throughout the beatmap.
        var StackLeniency : Decimal? //how often closely placed hit objects will be stacked together.
        var Mode : mode = .osu //game mode of the beatmap.
        enum mode {
            case osu            //0
            case taiko          //1
            case catchTheBeat   //2
            case osuMania       //3
        }
        var LetterboxInBreaks : Bool? //specifies whether the letterbox appears during breaks.
        var WidescreenStoryboard : Bool? //specifies whether or not the storyboard should be widescreen.
    }
    
    struct Editor {
        var Bookmarks = [Int]() //list of comma-separated times of editor bookmarks.
        var DistanceSpacing : Decimal? //multiplier for the "Distance Snap" feature.
        var BeatDivisor : Int? //specifies the beat division for placing objects.
        var GridSize : Int? //specifies the size of the grid for the "Grid Snap" feature.
        var TimelineZoom : Decimal? //specifies the zoom in the editor timeline.
    }
    
    struct Metadata {
        var Title : String? //title of the song limited to ASCII characters.
        var TitleUnicode : String? //title of the song with unicode support. If not present, Title is used.
        var Artist : String? //name of the song's artist limited to ASCII characters.
        var ArtistUnicode : String? //name of the song's artist with unicode support. If not present, Artist is used.
        var Creator : String? //username of the mapper.
        var Version : String? //name of the beatmap's difficulty.
        var Source : String? //describes the origin of the song.
        var Tags = [String]() //collection of words describing the song. Tags are searchable in both the online listings and in the song selection menu.
        var BeatmapID : Int? //ID of the single beatmap.
        var BeatmapSetID : Int? //ID of the beatmap set.
    }
    
    struct Difficulty {
        var HPDrainRate : Decimal? //specifies the HP Drain difficulty.
        var CircleSize : Decimal? //specifies the size of hit object circles.
        var OverallDifficulty : Decimal? //specifies the amount of time allowed to click a hit object on time.
        var ApproachRate : Decimal? //specifies the amount of time taken for the approach circle and hit object to appear.
        var SliderMultiplier : Decimal? = 1.4 //specifies a multiplier for the slider velocity. Default value is 1.4.
        var SliderTickRate : Decimal? = 1 //specifies how often slider ticks appear. Default value is 1
    }
    
    struct Events {
        var background = BackgroundImage()
        
        struct BackgroundImage{
            var imageName : String?
        }
        /*
         -Сделать
         */
    }
    
    struct TimingPoint {
        var Offset : Int? //number of milliseconds, from the start of the song. It defines when the timing point starts. A timing point ends when the next one starts. The first timing point starts at 0, disregarding its offset.
        var mpb : Decimal? //defines the duration of one beat. It affect the slider speed in osu!standard. When positive, it is faithful to its name. When negative, it is a percentage of previous non-negative milliseconds per beat. For instance, 3 consecutive timing points with `500`, `-50`, `-100` will have a resulting beat duration of half a second, a quarter of a second, and half a second, respectively.
        var Meter : Int? //defines the number of beats in a measure
        //var SampleSet : ??? =============================
        //var SampleIndex : ??? ===========================
        //var Volume : ??? ================================
        var Inherited : Bool? //tells if the timing point can be inherited from. *Inherited* is redundant with the milliseconds per beat field. A positive milliseconds per beat implies inherited is 1, and a negative one implies it is 0.
        var KiaiMode : Bool? //defines whether or not [Kiai Time](/wiki/Beatmap_Editor/Kiai_Time) effects are active.
        /*
         Example of a Timing Point:
         `66,315.789473684211,4,2,0,45,1,0`
         
         Example of an inherited Timing Point:
         `10171,-100,4,2,0,60,0,1`
         */
    }
    
    struct Colour {
        var r : Int?
        var g : Int?
        var b : Int?
        //SpecialColours TODO
    }
    
    struct HitObject {
        //Syntax: `x,y,time,type,hitSound...,extras`
        var x : Int? //0 to 512      0 - left
        var y : Int? //0 to 384      0 - top
        //For some hit objects, like spinners, the position is completely irrelevant.
        var time : Int? //number of milliseconds from the beginning of the song, and specifies when the hit begins.
        var type : ObjectType = .circle
        enum ObjectType {
            case circle //Bit 0 (1): circle.
            case slider //Bit 1 (2): slider.
            case newCombo //Bit 2 (4): new combo.
            case spinner //Bit 3 (8): spinner.
            //case ??? Bits 4-6 (16, 32, 64) form a 3-bit number (0-7) that chooses how many combo colours to skip.
            //case ??? Bit 7 (128) is for an osu!mania hold note.
            /*
             Circles, sliders, spinners, and hold notes can be OR'd with new combos and the combo skip value, but not with each other.
             
             The new combo flag always advances to the next combo. The skip value is applied on top of that, so that a skip of 1 means a 2-combo advance. The combo skip value is ignored when the new combo bit is not set.
             
             Examples:
             - `1`: circle.
             - `5 = 1 + 4`: circle starting a new combo.
             - `22 = 2 + 4 + 16`: slider starting a new combo, skipping 2 colours.
             */
        }
        var hitSound : Int? //bitmap of hit sounds to play when the hit object is successfully hit.
        /*
         - Bit 0 (1): normal.
         - Bit 1 (2): whistle.
         - Bit 2 (4): finish.
         - Bit 3 (8): clap.
         
         Сделать:
         -Extras, HitCircles, Sliders, Path, Repeat, Length and duration, Sounds, Spinners, osu!mania Hold Notes
         */
    }
    
    private var stage : Part!
    private var eventsStage : eventsPart!
    
    init(fileUrl: URL) {
        do
        {
            url = fileUrl
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
                        if stage == .general{
                            let value = line.components(separatedBy: " ")[1]
                            if line.contains("AudioFilename:") {
                                general.AudioFilename = value
                                audioUrl = url.deletingLastPathComponent().appendingPathComponent(value)
                            } else if line.contains("AudioLeadIn:") {
                                general.AudioLeadIn = value.toInt
                            } else if line.contains("PreviewTime:") {
                                general.PreviewTime = value.toInt
                            } else if line.contains("Countdown:") {
                                general.Countdown = value.toBool
                            } else if line.contains("SampleSet:") {
                                general.SampleSet = value
                            } else if line.contains("StackLeniency:") {
                                general.StackLeniency = value.toDecimal
                            } else if line.contains("Mode:") {
                                let mode = value.toInt
                                switch mode{
                                case 0:
                                    general.Mode = .osu
                                case 1:
                                    general.Mode = .taiko
                                case 2:
                                    general.Mode = .catchTheBeat
                                case 3:
                                    general.Mode = .osuMania
                                default:
                                    continue
                                }
                            } else if line.contains("LetterboxInBreaks:") {
                                general.LetterboxInBreaks = value.toBool
                            } else if line.contains("WidescreenStoryboard:") {
                                general.WidescreenStoryboard = value.toBool
                            }
                        } else if stage == .editor {
                            let value = line.components(separatedBy: " ")[1]
                            if line.contains("Bookmarks") {
                                editor.Bookmarks = value.toIntList(separator: ",")
                            } else if line.contains("DistanceSpacing"){
                                editor.DistanceSpacing = value.toDecimal
                            } else if line.contains("BeatDivisor"){
                                editor.BeatDivisor = value.toInt
                            } else if line.contains("GridSize"){
                                editor.GridSize = value.toInt
                            } else if line.contains("TimelineZoom"){
                                editor.TimelineZoom = value.toDecimal
                            }
                        } else if stage == .metadata {
                            let value = line.components(separatedBy: ":")[1]
                            if line.contains("Title:") {
                                metadata.Title = value
                            } else if line.contains("TitleUnicode"){
                                metadata.TitleUnicode = value
                            } else if line.contains("Artist:"){
                                metadata.Artist = value
                            } else if line.contains("ArtistUnicode"){
                                metadata.ArtistUnicode = value
                            } else if line.contains("Creator"){
                                metadata.Creator = value
                            } else if line.contains("Version"){
                                metadata.Version = value
                            } else if line.contains("Source"){
                                metadata.Source = value
                            } else if line.contains("Tags"){
                                metadata.Tags = value.toStringList(separator: " ")
                            } else if line.contains("BeatmapID"){
                                metadata.BeatmapID = value.toInt
                            } else if line.contains("BeatmapSetID"){
                                metadata.BeatmapSetID = value.toInt
                            }
                        } else if stage == .difficulty {
                            let value = line.components(separatedBy: ":")[1]
                            if line.contains("HPDrainRate") {
                                difficulty.HPDrainRate = value.toDecimal
                            } else if line.contains("CircleSize"){
                                difficulty.CircleSize = value.toDecimal
                            } else if line.contains("OverallDifficulty"){
                                difficulty.OverallDifficulty = value.toDecimal
                            } else if line.contains("ApproachRate"){
                                difficulty.ApproachRate = value.toDecimal
                            } else if line.contains("SliderMultiplier"){
                                difficulty.SliderMultiplier = value.toDecimal
                            } else if line.contains("SliderTickRate"){
                                difficulty.SliderTickRate = value.toDecimal
                            }
                        } else if stage == .events {
                            /*
                             -Сделать
                             */
                            if line == "//Background and Video events" {
                                eventsStage = .BackgroundAndVideo
                            } else if line == "//Break Periods"{
                                eventsStage = .BreakPeriods
                            } else if line == "//Storyboard Layer 0 (Background)"{
                                eventsStage = .StoryboardBackground
                            } else if line == "//Storyboard Layer 1 (Fail)"{
                                eventsStage = .StoryboardFail
                            } else if line == "//Storyboard Layer 2 (Pass)"{
                                eventsStage = .StoryboardPass
                            } else if line == "//Storyboard Layer 3 (Foreground)"{
                                eventsStage = .StoryboardForeground
                            } else if line == "//Storyboard Sound Samples"{
                                eventsStage = .StoryboardSoundSamples
                            }
                            
                            if !line.starts(with: "//")
                            {
                                let value = line.components(separatedBy: ",")
                                if eventsStage == .BackgroundAndVideo {
                                    if value[0] == "Video"{
                                        //video
                                    } else {
                                        //background image
                                        events.background.imageName = value[2].replacingOccurrences(of: "\"", with: "")
                                        imageUrl = url.deletingLastPathComponent().appendingPathComponent(value[2].replacingOccurrences(of: "\"", with: ""))
                                    }
                                }
                            }
                        } else if stage == .timingPoints {
                            let value = line.components(separatedBy: ",")
                            var tPoint = TimingPoint()
                            for i in 0...value.count-1{
                                switch i{
                                case 0:
                                    tPoint.Offset = value[i].toInt
                                case 1:
                                    tPoint.mpb = value[i].toDecimal
                                case 2:
                                    tPoint.Meter = value[i].toInt
                                //case 3:
                                    //Sample Set
                                //case 4:
                                    //Sample Index
                                //case 5:
                                    //Volume
                                case 6:
                                    tPoint.Inherited = value[i].toBool
                                case 7:
                                    tPoint.KiaiMode = value[i].toBool
                                default:
                                    continue
                                }
                            }
                            timingPoints.append(tPoint)
                        } else if stage == .colours {
                            let value = line.components(separatedBy: " : ")[1].components(separatedBy: ",")
                            let color = Colour(
                                r: value[0].toInt,
                                g: value[1].toInt,
                                b: value[2].toInt)
                            colours.append(color)
                        } else if stage == .hitObjects {
                            let value = line.components(separatedBy: ",")
                            var hObject = HitObject()
                            for i in 0...value.count-1{
                                switch i{
                                case 0:
                                    hObject.x = value[i].toInt
                                case 1:
                                    hObject.y = value[i].toInt
                                case 2:
                                    hObject.time = value[i].toInt
                                case 3:
                                    switch value[i].toInt{
                                    case 0:
                                        hObject.type = .circle
                                    case 1:
                                        hObject.type = .slider
                                    case 2:
                                        hObject.type = .newCombo
                                    case 3:
                                        hObject.type = .spinner
                                    default:
                                        continue
                                    }
                                case 4:
                                    hObject.hitSound = value[i].toInt
                                default:
                                    continue
                                }
                            }
                            hitObjects.append(hObject)
                        }
                    }
                }
            }
        } catch {
            print("Error while reading difficulty: \(error)")
        }
    }
}

extension String {
    var toInt : Int?{
        return(Int(self))
    }
    
    var toDecimal : Decimal?{
        let converter = NumberFormatter()
        converter.decimalSeparator = "."
        return(converter.number(from: self)!.decimalValue)
    }
    
    var toBool : Bool{
        return(self == "1" ? true : false)
    }
    
    func toIntList(separator: String) -> [Int]{
        var arr = [Int]()
        for item in self.components(separatedBy: separator){
            arr.append(Int(item)!)
        }
        return(arr)
    }
    
    func toStringList(separator: String) -> [String]{
        return(self.components(separatedBy: separator))
    }
}
