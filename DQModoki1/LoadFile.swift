//
//  LoadFile.swift
//  DQModoki1
//
//  Created by hiroto takashima on 2016/11/04.
//  Copyright © 2016年 hiroto takashima. All rights reserved.
//

import Foundation

class LoadFile: NSObject {
    
    //CSVファイル読み込みメソッド。引数でファイル名を取得。戻り値はString型の配列。
    func loadCSV(fileName :String) -> [String]{
        //CSVファイルのデータを格納するStrig型配列
        var csvArray:[String] = []
        //引数filnameからCSVファイルのパスを設定
        let csvBundle = NSBundle.mainBundle().pathForResource(fileName, ofType: "csv")!
        do {
            //csvBundleからファイルを読み込み、エンコーディングしてcsvDataに格納
            let csvData = try String(contentsOfFile: csvBundle,encoding: NSUTF8StringEncoding)
            //改行コードが"\r"の場合は"\n"に置換する
            let lineChange = csvData.stringByReplacingOccurrencesOfString("\r", withString: "\n")
            //"\n"の改行コードで要素を切り分け、配列csvArrayに格納する
            csvArray = lineChange.componentsSeparatedByString("\n")
        }catch{
            print("エラー")
        }
        return csvArray     //戻り値の配列csvArray
    }
}
