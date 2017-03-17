//
//  PostDetailViewController.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/16.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    var sketch : Sketch?
    var inspiration : Inspiration?
    
    @IBOutlet weak var reactionView: UIView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var postedImageView: UIImageView!
    @IBOutlet weak var userNoteTextView: PlaceHolderTextView!
    @IBOutlet weak var postedTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var kininaruBtn: UIButton!
    @IBOutlet weak var resketchBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNoteTextView.placeHolder = ""
        userNoteTextView.isEditable = false
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
            self.reactionView.isHidden = false
            print(inspiration)
            
            postedImageView.pin_setImage(from: URL(string: inspiration.compositedImageUrl))
            userNoteTextView.attributedText = String.tagAttributedStr(from: inspiration.caption)
            self.navItem.title = inspiration.title
            let date = NSDate(timeIntervalSince1970: TimeInterval(inspiration.capturedTime))
            
            // NSDate型を日時文字列に変換するためのNSDateFormatterを生成
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            // NSDateFormatterを使ってNSDate型 "date" を日時文字列 "dateStr" に変換
            let dateStr: String = formatter.string(from: date as Date)
            self.postedTimeLabel.text = dateStr
            
            kininaruBtn.setTitle("\(inspiration.kininaruCount) 気になる！", for: .normal)
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
            if let url = URL(string: "http://maps.apple.com/maps?daddr=\((inspiration.latitude)),\((inspiration.longitude))") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    @IBAction func backToHome(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func pressedKininaru(_ sender: Any) {
    }
    @IBAction func pressedResketch(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = mainStoryboard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        self.navigationController?.pushViewController(nextView, animated: true)
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
