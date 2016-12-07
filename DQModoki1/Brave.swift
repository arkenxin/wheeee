//
//  Brave.swift
//  RpgFight
//
//  Created by hiroto takashima on 2016/11/03.
//  Copyright © 2016年 hiroto takashima. All rights reserved.
//

import Foundation

class Brave: FooFighter, PriestProtocol {
    var firstName:String
    var cureSpell:String
        
    // イニシャライザ
    init(name: String = "勇者", level: Int = 1, firstName: String, spell: String, cureSpell: String) {
        self.firstName = firstName
        self.cureSpell = cureSpell
        super.init(name: name + firstName, level: level, spell: spell)
    }
    
    func spellCure() -> (flushState:String, curePercent:Float) {
        if activeFlg && mp >= 2 {
            flushState += "\(name)は\(cureSpell)を唱えた\n"
            mp -= 2
        }else{
            flushState += "\(name)のMPは枯渇している\n"
            curePercent = 0.0
            return (flushState, curePercent)
        }
        if hp <  FooFighter.Base_Hp * level {
            let curePoint = Int( 8 + arc4random_uniform(UInt32(level)) )
            curePercent = Float(curePoint) / Float(FooFighter.Base_Hp * level)
            hp += curePoint
            if hp > FooFighter.Base_Hp * level {
                hp = FooFighter.Base_Hp * level
            }
        }
        if hp > FooFighter.Base_Hp * level {
            hp = FooFighter.Base_Hp * level
            flushState += "\(name)のHPは\(hp)に回復した\n"
        } else {
            flushState += "\(name)のHPは\(hp)に回復した\n"
        }
        return (flushState, curePercent)
    }
    
}
