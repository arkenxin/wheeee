//
//  Mage.swift
//  RpgFight
//
//  Created by hiroto takashima on 2016/11/03.
//  Copyright © 2016年 hiroto takashima. All rights reserved.
//

import Foundation

protocol MageProtocol {
    var mp:Int { get set }
    var spell:String { get set }
    func spellAtack(enemy: FooFighter) -> (flushState:String, dmgPercent:Float)
}

protocol PriestProtocol : MageProtocol {
    var cureSpell:String { get set }
    func spellCure() -> (flushState:String, curePercent:Float)
}