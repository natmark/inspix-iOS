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

    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var postedImageView: UIImageView!
    @IBOutlet weak var userNoteTextView: PlaceHolderTextView!
    @IBOutlet weak var postedTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(sketch)
        userNoteTextView.placeHolder = ""
        userNoteTextView.isEditable = false
        
        if let compositedImage = sketch?.compositedImage{
            postedImageView.image = UIImage(data: compositedImage as Data)
        }
        userNoteTextView.attributedText = String.tagAttributedStr(from: (sketch?.note)!)
        self.navItem.title = sketch?.title
        self.postedTimeLabel.text = sketch?.time
        // Do any additional setup after loading the view.
    }
    @IBAction func showMap(_ sender: UIButton) {
        if let url = URL(string: "http://maps.apple.com/maps?daddr=\((sketch?.latitude)!),\((sketch?.longitude)!)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }
    @IBAction func backToHome(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
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
