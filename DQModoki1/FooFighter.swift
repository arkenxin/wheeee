//
//  FooFighter.swift
//  RpgFight
//
//  Created by hiroto takashima on 2016/11/03.
//  Copyright © 2016年 hiroto takashima. All rights reserved.
//

import Foundation

//Declaring a global variable 
var flushState: String = ""

class FooFighter : MageProtocol{
    static var Base_Hp:Int = 29
    static var Base_Mp:Int = 9
    static var Base_Strength:Int = 7
    var name:String
    var level: Int
    var hp: Int
    var mp:Int
    var strength: Int
    var spell:String = ""
    var activeFlg: Bool = true
    var purgeCnt: Int = 0
    var dmgPercent:Float = 1.0
    var curePercent:Float = 1.0
    
//    var mpPercent:Float = 0.0
    
    // イニシャライザ
    init(name: String, level: Int = 1, spell: String) {
        self.name = name
        self.level = level
        self.hp = FooFighter.Base_Hp * level
        self.mp = FooFighter.Base_Mp * level
        self.strength = FooFighter.Base_Strength * level
        self.spell = spell
    }
    // 攻撃
    func atack(enemy: FooFighter) -> (flushState:String, dmgPercent:Float) {
        if activeFlg {
            flushState += "\(name)は\(enemy.name)を攻撃した\n"
        }else{
            flushState += "\(name)は死んでいるのでAttackは無理・・復活の呪文を唱えてもらいな！\n"
            return (flushState, dmgPercent)
        }
        if enemy.activeFlg {
            let dmgPoint:Int = strength - Int(arc4random_uniform(UInt32(strength / level))) // 計算適当
            dmgPercent = Float(dmgPoint) / Float(FooFighter.Base_Hp * enemy.level)
//            print("FooFighter.Base_Hp * level : \(FooFighter.Base_Hp * enemy.level)")
//            print("enemy.hp : \(enemy.hp)")
//            print("dmgPoint : \(dmgPoint)")
//            print("dmgPercent : \(dmgPercent)")
            if dmgPoint >= enemy.hp {
                enemy.hp = 0
            }else{
                enemy.hp -= dmgPoint
            }
        }else{
            flushState += "\(enemy.name)は、すでに死んでいる・・\n"
            return (flushState, dmgPercent)
        }
        if enemy.hp <= 0 {
            enemy.activeFlg = false
            purgeCnt += 1
            flushState += "\(name)は\(enemy.name)を倒した\n"
            levelUpDecision()
        }else{
            flushState += "\(enemy.name)のHPは\(enemy.hp)\n"
        }
        return (flushState, dmgPercent)

    }
    func spellAtack(enemy: FooFighter) -> (flushState:String, dmgPercent:Float) {
        if activeFlg && mp > 0 {
            flushState += "\(name)は\(enemy.name)に\(spell)で攻撃した\n"
            mp -= 3
        }else{
            flushState += "\(name)のMPは枯渇しているのでspellAttackは無理\n"
            return (flushState, dmgPercent)
        }
        if enemy.activeFlg {
            let dmgPoint:Int = ( strength - Int(arc4random_uniform(UInt32(strength / level))) ) - mp/10 // 計算めっちゃ適当
            dmgPercent = Float(dmgPoint) / Float(FooFighter.Base_Hp * enemy.level)
            if dmgPoint >= enemy.hp {
                enemy.hp = 0
            }else{
                enemy.hp -= dmgPoint
            }
        }else{
            flushState += "\(enemy.name)は、すでに死んでいる・・\n"
            return (flushState, dmgPercent)
        }
        if enemy.hp <= 0 {
            enemy.activeFlg = false
            purgeCnt += 1
            flushState += "\(name)は\(enemy.name)を倒した\n"
            levelUpDecision()
        }else{
            flushState += "\(enemy.name)のHPは\(enemy.hp)\n"
        }
        return (flushState, dmgPercent)
    }
    func levelUpDecision() { //取り敢えずこんな感じで・・
        if purgeCnt > 7 {
            levelUp()
        } else if purgeCnt > 3 {
            levelUp()
        } else if purgeCnt > 1 {
            levelUp()
        }
    }
    // レベルUP メソッド
    func levelUp() {
        flushState += "\(name)はレベルUPした\n" //levelUpの音追加してみよう！
        level += 1
        flushState += "\(name)はHPが\(FooFighter.Base_Hp * level - hp)上がった\n"
        flushState += "\(name)はMPが\(FooFighter.Base_Mp * level - mp)上がった\n"
        flushState += "\(name)は強さが\(FooFighter.Base_Strength * level - strength)上がった\n"
        hp = FooFighter.Base_Hp * level
        mp = FooFighter.Base_Mp * level
        strength = FooFighter.Base_Strength * level
    }
}