//
//  PostDetailViewController.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/16.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import APIKit
class PostDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var sketch : Sketch?
    var inspiration : Inspiration?
    
    @IBOutlet weak var reactionView: UIView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var postedImageView: UIImageView!
    @IBOutlet weak var userNoteTextView: PlaceHolderTextView!
    @IBOutlet weak var postedTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var nokkariCollectionView: UICollectionView!
    @IBOutlet weak var resketchCountLabel: UILabel!
    
    @IBOutlet weak var kininaruBtn: UIButton!
    @IBOutlet weak var resketchBtn: UIButton!
    
    var isKininatteru : Bool = false
    var kininatteruCount : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        userNoteTextView.placeHolder = ""
        userNoteTextView.isEditable = false

        let sketchCellNib = UINib(nibName: "SketchCollectionViewCell", bundle: nil)
        self.nokkariCollectionView.register(sketchCellNib, forCellWithReuseIdentifier: "sketchCell")
        self.nokkariCollectionView.delegate = self
        self.nokkariCollectionView.dataSource = self
        self.nokkariCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if let sketch = sketch {
            self.reactionView.isHidden = true
            if let compositedImage = sketch.compositedImage{
                postedImageView.image = UIImage(data: compositedImage as Data)
            }
            userNoteTextView.attributedText = String.tagAttributedStr(from: sketch.note)
            self.navItem.title = sketch.title
            self.postedTimeLabel.text = sketch.time
            return
        }
        if let inspiration = inspiration {
            self.resketchCountLabel.text = "リアクション \(inspiration.nokkarare.count)件"
            self.reactionView.isHidden = false
            print(inspiration)
            
            postedImageView.pin_setImage(from: URL(string: inspiration.compositedImageUrl))
            userNoteTextView.attributedText = String.tagAttributedStr(from: inspiration.caption)
            self.navItem.title = inspiration.title
            if let capturedTime = inspiration.capturedTime{
                let date = NSDate(timeIntervalSince1970: TimeInterval(capturedTime))
                
                // NSDate型を日時文字列に変換するためのNSDateFormatterを生成
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                
                // NSDateFormatterを使ってNSDate型 "date" を日時文字列 "dateStr" に変換
                let dateStr: String = formatter.string(from: date as Date)
                self.postedTimeLabel.text = dateStr
            }
            kininaruBtn.setTitle("\(inspiration.kininaruCount) 気になる！", for: .normal)
            isKininatteru = inspiration.kininatteru
            kininatteruCount = inspiration.kininaruCount
            
            if inspiration.kininatteru {
                kininaruBtn.setImage(UIImage(named: "icon_kininaru_highlight"), for: .normal)
            }else{
                kininaruBtn.setImage(UIImage(named: "icon_kininaru"), for: .normal)
            }
            resketchBtn.setTitle("\(inspiration.nokkarare.count) リスケッチ", for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func showMap(_ sender: UIButton) {
        if let sketch = sketch {
            if let url = URL(string: "http://maps.apple.com/maps?daddr=\((sketch.latitude)),\((sketch.longitude))") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(url)
                }
            }
        }
        if let inspiration = inspiration {
            if let latitude = inspiration.latitude, let longitude = inspiration.longitude{
                if let url = URL(string: "http://maps.apple.com/maps?daddr=\((latitude)),\((longitude))") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
    @IBAction func backToHome(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func pressedKininaru(_ sender: Any) {
        guard let inspiration = inspiration else {
            return
        }
        if inspiration.kininatteru {
            //解除
            let request = DeleteKininaruRequest(inspirationId: inspiration.id)
            Session.send(request) { result in
                switch result {
                case .success(_):
                    self.isKininatteru = false
                    self.kininatteruCount -= 1
                    self.kininaruBtn.setTitle("\(self.kininatteruCount) 気になる！", for: .normal)
                    self.kininaruBtn.setImage(UIImage(named: "icon_kininaru"), for: .normal)
                    
                    break
                case .failure(.responseError(let inspixError as InspixError)):
                    print(inspixError.message)
                    
                case .failure(let error):
                    print("error: \(error)")
                }
            }
 

        }else{
            //気になる
            let request = PutKininaruRequest(inspirationId: inspiration.id)
            Session.send(request) { result in
                switch result {
                case .success(_):
                    self.isKininatteru = true
                    self.kininatteruCount += 1
                    self.kininaruBtn.setTitle("\(self.kininatteruCount) 気になる！", for: .normal)
                    self.kininaruBtn.setImage(UIImage(named: "icon_kininaru_highlight"), for: .normal)
                    
                    break
                case .failure(.responseError(let inspixError as InspixError)):
                    print(inspixError.message)
                    
                case .failure(let error):
                    print("error: \(error)")
                }
            }
        }
    }
    @IBAction func pressedResketch(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = mainStoryboard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        
        nextView.inspiration = inspiration
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    //MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let sketchCell:SketchCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "sketchCell", for: indexPath) as! SketchCollectionViewCell
        
        // 要素数を入れる、要素以上の数字を入れると表示でエラーとなる

        if let compositedImageUrl = inspiration?.nokkarare[indexPath.row].compositedImageUrl{
            sketchCell.thumbnailImageView.pin_setImage(from: URL(string:compositedImageUrl))
        }
        
        return sketchCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 2 - 0.5
        let returnSize = CGSize(width: width, height: width)
        
        return returnSize
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 要素数を入れる、要素以上の数字を入れると表示でエラーとなる
        if let inspiration = inspiration{
            return inspiration.nokkarare.count
        }
        return 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
