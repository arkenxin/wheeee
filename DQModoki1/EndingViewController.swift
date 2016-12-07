//
//  EndingViewController.swift
//  DQModoki1
//
//  Created by hiroto takashima on 2016/11/04.
//  Copyright © 2016年 hiroto takashima. All rights reserved.
//

import UIKit

class EndingViewController: UIViewController {

    var result = ""//BattleViewControllerから戦闘結果を受け取るメンバ変数
    var csvEndrollArray:[String] = []
    var endrollArray:[String] = []
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var endRollTextView: UITextView!
    
    var soundManager = SEManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //データ受け渡し処理　現在未使用　↓↓↓↓↓↓
//        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
//        let message = appDelegate.message!
//        print(message)
//        let message2 = appDelegate.message2!
//        print(message2)
        //データ受け渡し処理　現在未使用　↑↑↑↑↑↑
        
        flushState = "" //戦闘経過表示用テキストをクリア
        resultLabel.text = result //戦闘結果セット
        
        //エンドロール用　CSVファイル読み込み
        let loadFile = LoadFile()
        csvEndrollArray = loadFile.loadCSV("endroll")
        endrollArray = csvEndrollArray[0].componentsSeparatedByString(",")
        
        endRollTextView.text =
            endrollArray[0] + "\n\n\n" + endrollArray[1] + "\n" +
            endrollArray[2] + "\n\n" + endrollArray[3] + "\n\n" +
            endrollArray[4] + "\n\n" + endrollArray[5] + "\n\n" +
            endrollArray[6] + "\n\n" + endrollArray[7] + "\n\n" +
            endrollArray[8] + "\n\n" + endrollArray[9] + "\n\n" +
            endrollArray[10] + "\n\n" + endrollArray[11] + "\n\n" +
            endrollArray[12] + "\n\n" + endrollArray[13] + "\n\n" +
            endrollArray[14] + "\n\n"

        soundManager.sePlay("ending.mp3")
        
    }
    
    @IBAction func goToOpening(sender: AnyObject) {
        soundManager.seStop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
