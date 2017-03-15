//
//  ShareViewController.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/15.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    var photoImage : UIImage?
    var sketchImage : UIImage?
    var compositedImage : UIImage?
    
    @IBOutlet weak var sketchTitleTextField: UITextField!
    @IBOutlet weak var compositedImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let sketchImage = sketchImage else{
            compositedImageView.image = photoImage
            return
        }
        //画像の合成
        let composeFilter = CIFilter(name: "CIMinimumCompositing")
        composeFilter?.setValue(CIImage(image: sketchImage), forKey: kCIInputImageKey)
        composeFilter?.setValue(CIImage(image: photoImage!), forKey: kCIInputBackgroundImageKey)
        
        compositedImage =  UIImage(ciImage: (composeFilter?.outputImage)!)
        
        compositedImageView.image = compositedImage
    }

    @IBAction func backToCameraView(_ sender: Any) {
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
