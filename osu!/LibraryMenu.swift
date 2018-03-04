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
