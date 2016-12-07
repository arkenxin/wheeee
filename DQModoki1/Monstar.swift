//
//  Monstar.swift
//  DQModoki1
//
//  Created by hiroto takashima on 2016/11/08.
//  Copyright © 2016年 hiroto takashima. All rights reserved.
//

import Foundation

class Monstar: FooFighter {
    var firstName:String
    var enemyImage:String
    var bkImage:String
    
    // イニシャライザ
    init(name: String, level: Int = 1 ,firstName: String, spell: String, enemyImage: String, bkImage: String) {
        self.firstName = firstName
        self.enemyImage = enemyImage
        self.bkImage = bkImage
        super.init(name: name + "の" + firstName, level: level, spell: spell)
    }
    
}

