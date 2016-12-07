//
//  BattleViewController.swift
//  DQModoki1
//
//  Created by hiroto takashima on 2016/11/03.
//  Copyright © 2016年 hiroto takashima. All rights reserved.

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet weak var bkImageView: UIImageView!
    @IBOutlet weak var msImageView: UIImageView!
    @IBOutlet weak var waImageView: UIImageView!
    @IBOutlet weak var fightTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var hpGageView: UIProgressView!
    
    var csvCharaArray:[String] = []
    var charaArray:[String] = []
    var csvMonstArray:[String] = []
    var monstArray:[String] = []
   
    var count:Int = 0
    var actionCount:Int = 0
    var actionFlg: Bool = true
    var killCount = 0     //討伐モンスターカウント用
    var soundManager = SEManager()//BGM用
    var soundManager2 = SEManager() //効果音用

    var monster:Monstar?
    var yuusha:Brave?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //データ受け渡し処理　現在未使用　↓↓↓↓↓↓
//        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
//        appDelegate.message = "messagetest" //appDelegateの変数を操作
//        appDelegate.message2 = "messagetest2" //appDelegateの変数を操作
        //データ受け渡し処理　現在未使用　↑↑↑↑↑↑

        hpGageView.transform = CGAffineTransformMakeScale(1.0, 4.5)
        hpGageView.progress = 10.0;
        hpGageView.progressTintColor = UIColor.greenColor()
        hpGageView.trackTintColor = UIColor.redColor()
        soundManager.sePlay("battle.mp3")
        waImageView.hidden = true
        fightTextView.text = ""

        //CSVファイル読み込み
        let loadFile = LoadFile()
        csvCharaArray = loadFile.loadCSV("chara")//勇者キャラ配列
        csvMonstArray = loadFile.loadCSV("monstar")//モンスターキャラ配列
        charaArray = csvCharaArray[0].componentsSeparatedByString(",")
        //勇者キャラ生成
        yuusha = Brave(level: Int(charaArray[0])!, firstName: charaArray[1], spell: charaArray[3], cureSpell: charaArray[4])
        
        nameLabel.text = (yuusha?.firstName)! + "HP"
        
        //モンスターキャラ生成
        nextMonstar()
        self.view.sendSubviewToBack(bkImageView)
        actionTimer()
    }
    @IBAction func btnAction(sender: UIButton){
        // atack : 1, spellAtack : 2, heal : 3
        if sender.tag == 1 && actionFlg == true {
            fightTextView.text = yuusha!.atack(monster!).flushState
            actionFlg = false
            soundManager2.sePlay("sword-slash3.mp3")
            fightTextView.scrollEnabled = true
            fightTextView.scrollRangeToVisible(NSMakeRange(-1, 0))
            let duration = 0.2
            let transform: CGAffineTransform = CGAffineTransformMakeScale(0.85, 0.85)
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.msImageView.transform = transform
                })
            { (Bool) -> Void in
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    self.msImageView.transform = CGAffineTransformIdentity
                    })
            }
        }else if sender.tag == 2 && actionFlg == true {
            let result = yuusha!.spellAtack(monster!)
            fightTextView.text = result.flushState
            actionFlg = false
            soundManager2.sePlay("spell_fire.mp3")
        }else if sender.tag == 3 && actionFlg == true {
            let result = yuusha!.spellCure()
            hpGageView.setProgress(hpGageView.progress + result.curePercent, animated: true)
            fightTextView.text = result.flushState
            actionFlg = false
            soundManager2.sePlay("cure.mp3")
        }
        fightTextView.scrollEnabled = true
        fightTextView.scrollRangeToVisible(NSMakeRange(-1, 0))
    }
    func actionTimer(){
        NSTimer.scheduledTimerWithTimeInterval(
            1,
            target:self,
            selector:#selector(BattleViewController.timerAction(_:)),
            userInfo:nil,
            repeats:true)
            .fire()
    }
    func timerAction(sender:NSTimer){
        count += 1
        if monster!.activeFlg == false {//モンスターが戦闘不能
            if killCount >= csvMonstArray.count /*- 1*/ {
                waImageView.hidden = false
                soundManager.seStop()
                sender.invalidate()
                soundManager2.sePlay("end_fight.wav")
                //Stroyboard SegueのIdentifierを引数に設定して画面遷移
                performSegueWithIdentifier("endroll", sender: nil)
            }else{
                waImageView.hidden = false
                nextMonstar()
            }
        } else if yuusha!.activeFlg == false {//勇者が戦闘不能
            soundManager.seStop()
            sender.invalidate()
            //Stroyboard SegueのIdentifierを引数に設定して画面遷移
            performSegueWithIdentifier("endroll", sender: nil)
        }
        if count % 16 == 0 {// モンスター　魔法攻撃
            actionFlg = true //勇者アクション有効
            soundManager2.sePlay("monstar_spellAtack.wav")
            let result = monster!.spellAtack(yuusha!)
            hpGageView.setProgress(hpGageView.progress - result.dmgPercent, animated: true)
            fightTextView.text = result.flushState
        }else if count % 4 == 0 {// モンスター　通常攻撃
            actionFlg = true //勇者アクション有効
            soundManager2.sePlay("monstar_atack.wav")
            let result = monster!.atack(yuusha!)
            hpGageView.setProgress(hpGageView.progress - result.dmgPercent, animated: true)
            fightTextView.text = result.flushState
            let duration = 0.2
            let transform: CGAffineTransform = CGAffineTransformMakeScale(1.3, 1.3)
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.msImageView.transform = transform
                })
            { (Bool) -> Void in
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    self.msImageView.transform = CGAffineTransformIdentity
                })
            }
        }
        fightTextView.scrollEnabled = true
        fightTextView.scrollRangeToVisible(NSMakeRange(-1, 0))
    }
    //次のモンスターを表示するメソッド
    func nextMonstar(){
        monstArray.removeAll()
        monstArray = csvMonstArray[killCount].componentsSeparatedByString(",")
        monster = Monstar(name: monstArray[0], level: Int(monstArray[1])!, firstName: monstArray[2], spell: monstArray[4], enemyImage: monstArray[5], bkImage: monstArray[6])
        msImageView.image = UIImage(named: monster!.enemyImage)//モンスター画像セット
        bkImageView.image = UIImage(named: monster!.bkImage)//背景画像セット
        self.view.sendSubviewToBack(bkImageView)
        killCount += 1        //討伐数をカウントアップ
        waImageView.hidden = true        //天使の輪削除
    }
    //エンドロール画面へ値を渡す
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let sVC = segue.destinationViewController as! EndingViewController
        if yuusha!.activeFlg == true {
            sVC.result = yuusha!.name + "が勝利した"
        }else if yuusha!.activeFlg == false {
            sVC.result = yuusha!.name + "が敗北した"
        }
    }
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
