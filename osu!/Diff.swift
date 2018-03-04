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
        var AudioFilename : String //location of the audio file relative to the current folder.
        var AudioLeadIn : Int //amount of time added before the audio file begins playing. Useful for audio files that begin immediately.
        var PreviewTime : Int //defines when the audio file should begin playing when selected in the song selection menu.
        var Countdown : Bool //specifies whether or not a countdown occurs before the first hit object appears.
        var SampleSet : String //specifies which set of hit sounds will be used throughout the beatmap.
        var StackLeniency : Decimal //how often closely placed hit objects will be stacked together.
        var Mode : mode //game mode of the beatmap.
        enum mode {
            case osu            //0
            case taiko          //1
            case catchTheBeat   //2
            case osuMania       //3
        }
        var LetterboxInBreaks : Bool //specifies whether the letterbox appears during breaks.
        var WidescreenStoryboard : Bool //specifies whether or not the storyboard should be widescreen.
    }
    
    struct Editor {
        var Bookmarks : [Int] //list of comma-separated times of editor bookmarks.
        var DistanceSpacing : Decimal //multiplier for the "Distance Snap" feature.
        var BeatDivisor : Int //specifies the beat division for placing objects.
        var GridSize : Int //specifies the size of the grid for the "Grid Snap" feature.
        var TimelineZoom : Int //specifies the zoom in the editor timeline.
    }
    
    struct Metadata {
        var Title : String //title of the song limited to ASCII characters.
        var TitleUnicode : String //title of the song with unicode support. If not present, Title is used.
        var Artist : String //name of the song's artist limited to ASCII characters.
        var ArtistUnicode : String //name of the song's artist with unicode support. If not present, Artist is used.
        var Creator : String //username of the mapper.
        var Version : String //name of the beatmap's difficulty.
        var Source : String //describes the origin of the song.
        var Tags : [String] //collection of words describing the song. Tags are searchable in both the online listings and in the song selection menu.
        var BeatmapID : Int //ID of the single beatmap.
        var BeatmapSetID : Int //ID of the beatmap set.
    }
    
    struct Difficulty {
        var HPDrainRate : Decimal //specifies the HP Drain difficulty.
        var CircleSize : Decimal //specifies the size of hit object circles.
        var OverallDifficulty : Decimal //specifies the amount of time allowed to click a hit object on time.
        var ApproachRate : Decimal //specifies the amount of time taken for the approach circle and hit object to appear.
        var SliderMultiplier : Decimal = 1.4 //specifies a multiplier for the slider velocity. Default value is 1.4.
        var SliderTickRate : Decimal = 1 //specifies how often slider ticks appear. Default value is 1
    }
    
    struct Events {
        /*
         -Сделать
         */
    }
    
    struct TimingPoints {
        var Offset : Int //number of milliseconds, from the start of the song. It defines when the timing point starts. A timing point ends when the next one starts. The first timing point starts at 0, disregarding its offset.
        var mpb : Decimal //defines the duration of one beat. It affect the slider speed in osu!standard. When positive, it is faithful to its name. When negative, it is a percentage of previous non-negative milliseconds per beat. For instance, 3 consecutive timing points with `500`, `-50`, `-100` will have a resulting beat duration of half a second, a quarter of a second, and half a second, respectively.
        var Meter : Int //defines the number of beats in a measure
        //var SampleSet : ??? =============================
        //var SampleIndex : ??? ===========================
        //var Volume : ??? ================================
        var Inherited : Bool //tells if the timing point can be inherited from. *Inherited* is redundant with the milliseconds per beat field. A positive milliseconds per beat implies inherited is 1, and a negative one implies it is 0.
        var KiaiMode : Bool //defines whether or not [Kiai Time](/wiki/Beatmap_Editor/Kiai_Time) effects are active.
        /*
         Example of a Timing Point:
         `66,315.789473684211,4,2,0,45,1,0`
         
         Example of an inherited Timing Point:
         `10171,-100,4,2,0,60,0,1`
         */
    }
    
    struct Colours {
        var Combo = [UIColor]()
        //SpecialColours TODO
    }
    
    struct HitObjects {
        //Syntax: `x,y,time,type,hitSound...,extras`
        var x : Int //0 to 512      0 - left
        var y : Int //0 to 384      0 - top
        //For some hit objects, like spinners, the position is completely irrelevant.
        var time : Int //number of milliseconds from the beginning of the song, and specifies when the hit begins.
        enum type {
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
        var hitSound : Int //bitmap of hit sounds to play when the hit object is successfully hit.
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
