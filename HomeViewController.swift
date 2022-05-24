//
//  HomeViewController.swift
//  MycolorMemoApp
//
//  Created by 池田匠 on 2022/04/24.
//

import Foundation
import UIKit //　UIに関するクラスが格納されたモジュール
import RealmSwift

// HomeViewControllerにUIViewControllerを「クラス継承」する
// protocolに準拠するのと同じ形式やけどクラスにクラス
// HomeViewController上でUIViewControllerクラスのプロパティやメソッドを使用できる
class  HomeViewController: UIViewController {
  // UIコンポーネント（構成部品）をControllerに追加した時propertyの宣言時にIBOutletがつく　storyboard上から紐付けされたという意味
  @IBOutlet weak var tableview: UITableView!
  
  // 空の配列を代入
  var memoDataList: [MemoDataModel] = []  // クラスを要素に持つ配列のイメージがつかない　多分クラス内の要素が並ぶイメージでいいと思う
  let themeColorTypeKey = "themeColorTypeKey" // これは鍵
  // 親クラス(UIViewController)のメソッドを小クラス(HomeViewController)で定義し直す時にoverrideをかく
  override func viewDidLoad() {
    //　俺に任せろの意味
    tableview.dataSource = self
    // self = HomeViewController クラスを代入？　これで使えるようになる？
    tableview.delegate = self
    // UIView()とはさまざまなUIコンポーネントの親となるクラス　何の中身のないプレーンなクラス
    tableview.tableFooterView = UIView()  // 下の線を消したいから
   
    setNavigationButton()
    setLeftNavigationBarButton()
    // ホーム画面を表示した際にUserDefaultsからInt型のデータを取得し反映する　standardはクラス
    let themeColorTypeInt = UserDefaults.standard.integer(forKey: themeColorTypeKey) // themeColorTypeKeyっていう鍵でデータにアクセス
    // Int型の値をちゃんとした色に変更
    let themeColorType = MyColorType(rawValue: themeColorTypeInt) ?? .default
    setThemeColor(type: themeColorType)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // 画面が表示される度にデータの更新
    setMemoData()
    // データは更新されたけど表示内容が更新されてないから更新する
    tableview.reloadData()
  }
  // メモリストにメモデータを格納
  // Realmから取得したデータを反映させる
  func setMemoData() {
    // 読み込み？
    let realm = try! Realm()
    // インスタンス化したrealmからMemoDataModelクラスのデータを全件取得　filterもできる
    let result = realm.objects(MemoDataModel.self)
    // 取得結果を配列として代入する
    memoDataList = Array(result)
  }
  // selectorクラスに指定するメソッドにはobjcをつける
  @objc func tapAddButton() {
    // メモの新規ボタンを押した際にメモ詳細画面へ遷移させる
    let storyboad = UIStoryboard(name: "Main", bundle: nil) // Storyboard のファイル名を指定して UIStoryboard クラスをインスタンス化
    // 遷移先のViewを取得
    let memoDetailViewController = storyboad.instantiateViewController(identifier: "MemoDetailViewController") as!MemoDetailViewController
    // 画面遷移
    navigationController?.pushViewController(memoDetailViewController, animated: true)
    
  }
  func setNavigationButton() {
    // Selectorクラスのインスタンス化
    // ヘッダーに表示されたボタンをタッチした際の処理の指定するクラスがselectorクラス　#selector(実行されるメソッド)
    let buttonActionSelector: Selector = #selector(tapAddButton)// object-Cのメソッドが使いたいから
    // navigationControllerにボタンを配置
    let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: buttonActionSelector)
    // ナビゲーションバー（ヘッダー）右側にボタンを配置
    navigationItem.rightBarButtonItem = rightBarButton
  }
  
  func setLeftNavigationBarButton() {
    let buttonActionSelector: Selector = #selector(didTapColorSettingButton)
    // アイコン画像をUIImageクラスとしてインスタンス化
    let leftButtonImage = UIImage(named: "colorSettingIcon") // アイコン画像を取得
    // navigationItemを追加するためにUIBarButtonItemクラスとしてインスタンス化　この時ボタンの画像を指定するためにleftButtonImageを引数に渡す
    //　またボタンタップ時の挙動を示すためにbuttonActionSelectorも引数に渡す
    let leftButton = UIBarButtonItem(image: leftButtonImage, style: .plain, target: self, action: buttonActionSelector)
    //ヘッダーの左側にボタン(部品)を配置
    navigationItem.leftBarButtonItem = leftButton
  }
  // 今回はコードでボタンを追加するためselectorを使ってボタンをタップした時の処理を書く
    @objc func didTapColorSettingButton(){
      // アクションシート　アラートをタップした際の挙動を定義するクラスを追加
      // アラートに表示させるアクションの定義
      let defaultAction = UIAlertAction(title: "デフォルト", style: .default, handler: { _ -> Void in
        // メソッドの引数にenumを指定した場合(引数: .default)という風にenumのcaseを書くことで引数として渡すことができる
        self.setThemeColor(type: .default)// クロージャーという構文
      })
      // handlerはタップした時の処理内容
      let orangeAction = UIAlertAction(title: "オレンジ", style: .default, handler: { _ -> Void in
        self.setThemeColor(type: .orange)
      })
      let redAction = UIAlertAction(title: "レッド", style: .default, handler: { _ -> Void in
        self.setThemeColor(type: .red)
      })
      let blueAction = UIAlertAction(title: "ブルー", style: .default, handler: { _ -> Void in
        self.setThemeColor(type: .blue)
      })
      let pinkAction = UIAlertAction(title: "ピンク", style: .default, handler: { _ -> Void in
        self.setThemeColor(type: .pink)
      })
      let greenAction = UIAlertAction(title: "グリーン", style: .default, handler: { _ -> Void in
        self.setThemeColor(type: .green)
      })
      let purpleAction = UIAlertAction(title: "パープル", style: .default, handler: { _ -> Void in
        self.setThemeColor(type: .purple)
      })
      // タップするとアラートが閉じる
      let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
      // アラート自体のControllerをインスタンス化　actionSheet形式
      let alert = UIAlertController(title: "テーマカラーを選択してください", message: "",  preferredStyle: .actionSheet)
      // アラートに設定を反映させる
      alert.addAction(defaultAction)
      alert.addAction(orangeAction)
      alert.addAction(redAction)
      alert.addAction(blueAction)  // addactionも調べる
      alert.addAction(pinkAction)
      alert.addAction(greenAction)
      alert.addAction(purpleAction)
      alert.addAction(cancelAction)
      
      present(alert, animated: true)
    }
  // ヘッダーの色を変える
  func setThemeColor(type: MyColorType) { // enumを引数に持つっていうのはどういうイメージ
    // 色がかぶるからヘッダーボタンの色も変更
    let isDefault = type == .default // 多分bool型
    let tintColor: UIColor = isDefault ? .black : .white // 　if式
    navigationController?.navigationBar.tintColor = tintColor
    // UInavigationvarの配色を変更
    let appearance = UINavigationBarAppearance()
           appearance.backgroundColor = type.color // 任意の色を代入できる
    // Dictionary型→[Key: Value]
    // タイトルの文字の色を変更
           appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
           navigationController?.navigationBar.standardAppearance = appearance
           navigationController?.navigationBar.compactAppearance = appearance   // これもユーザーが選んだ色を入れますよってこと
           navigationController?.navigationBar.scrollEdgeAppearance = appearance
    //　テーマカラーが選択された際にメソッドを呼び出す
           saveThemeColor(type: type) // 右側のtypeはユーザーが選択した色
 }
  //　テーマカラーを保存するメソッド　UserDefaultsにデータを保存　簡単なデータを保存する
  func saveThemeColor(type: MyColorType){
    UserDefaults.standard.setValue(type.rawValue, forKey: themeColorTypeKey)
    //　themeColorTypeKeyはデータにアクセスするための鍵となる
    // データを呼び出すときにthemeColorTypeKeyを使う
  }
}
// 拡張機能として約束事を定義する
extension HomeViewController: UITableViewDataSource{
  // UITableViewに表示するリストの数，セルの数を指定
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // 配列が持つcountプロパティ　配列の要素の数分のセルを用意したい
    return memoDataList.count
  }
  //　リストの中身を定義　セルの構築
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //　インスタンス化
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
    // indexPath.row →　UItableViewに表示されるCellの(0から始まる)通り番号が順番に渡される　ここ全然わからん
    let memoDataModel: MemoDataModel = memoDataList[indexPath.row]
    // セルのテキストラベルにindexPath.row番目の配列の要素を入れる
    cell.textLabel?.text = memoDataModel.text
    cell.detailTextLabel?.text = "\(memoDataModel.recordDate)"
    //UITableViewCell型を返す
    return cell
  }
}

extension HomeViewController: UITableViewDelegate{
  //セルがタップされたときに呼ばれる
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //タップされた時にIndexPathにタップされた行の番号が入る
    // インスタンス化　コード上で使えるようにする
    // identityのとこにMemoDetailViewControllerって入れることでコード上で使えるようになる
    let storyboad = UIStoryboard(name: "Main", bundle: nil)
    // memoDetailViewControllerをインスタンス化
    let memoDetailViewController = storyboad.instantiateViewController(identifier: "MemoDetailViewController") as!MemoDetailViewController
    // 画面遷移するときにMemoDetailViewControllerにデータを渡す
    // メモデータモデルを取り出す
    let memoData = memoDataList[indexPath.row]
    // これでデータを渡している
    memoDetailViewController.configure(memo: memoData) // こーゆーのわからん
    // cellの選択の解除
    tableView.deselectRow(at: indexPath, animated: true)
    // 画面遷移メソッド
    navigationController?.pushViewController(memoDetailViewController, animated: true)
  }
  // 横にスワイプした際に実行されるメソッド
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    // スワイプされたメモのindexPathを使ってメモデータリストから削除対象のメモデータを取得
    let targetMemo = memoDataList[indexPath.row]
    // Realmのデータ削除処理
    let realm = try! Realm()
    try! realm.write {
      realm.delete(targetMemo)
    }
    //　 定義したmemoDataListプロパティにはデータが残っている
    memoDataList.remove(at: indexPath.row)
    // UItableViewの表示内容もこのままだと削除されたデータが残ったまま　cellの削除処理
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
}



