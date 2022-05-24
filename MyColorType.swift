//
//  MyColorType.swift
//  MycolorMemoApp
//
//  Created by 池田匠 on 2022/05/08.
//

import Foundation
import UIKit

enum MyColorType: Int{ //Int型をenumに継承　caseの上から012..と連番が振られる
  // テーマカラーの追加
  // ↓予約語と呼ばれるdefaultキーワードと重複してしまうから｀｀で囲む
  case `default` // #ffffff
  case orange // #f8c165 webgradientsから取得したカラーコード
  case red // #d24141
  case blue // #4187fa
  case pink // #f064b9
  case green // #50aa41
  case purple // #965ad2
  
  var color: UIColor { // UIコンポーネントに配色を指定するクラス
    switch self {
    case .default: return .white
      // カラーコードをrgbaに変換
    case .orange: return UIColor.rgba(red: 248, green: 193, blue: 101, alpha: 1)
    case .red: return UIColor.rgba(red: 210, green: 65, blue: 65, alpha: 1)
    case .blue: return UIColor.rgba(red: 65, green: 135, blue: 250, alpha: 1)
    case .pink: return UIColor.rgba(red: 240, green: 100, blue: 185, alpha: 1)
    case .green: return UIColor.rgba(red: 80, green: 170, blue: 65, alpha: 1)
    case .purple: return UIColor.rgba(red: 150, green: 90, blue: 210, alpha: 1)
    }
  }
}

extension UIColor {
  // alphaは透明度　0は完全透明
  // rgbaと16進数のカラーコードを相互補完するためにはネットで変換する
  static func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
    // 最大値を255としてその比率
     return UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
  }
}
