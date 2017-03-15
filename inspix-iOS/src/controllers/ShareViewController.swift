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
//        let composeFilter = CIFilter(name: "CIMinimumCompositing")
//        composeFilter?.setValue(CIImage(image: sketchImage), forKey: kCIInputImageKey)
//        composeFilter?.setValue(CIImage(image: photoImage!), forKey: kCIInputBackgroundImageKey)
//        
//        compositedImage =  UIImage(ciImage: (composeFilter?.outputImage)!)
//        
//        compositedImageView.image = compositedImage
        
        let photoRect:(width:Int,height:Int) = ((photoImage?.cgImage?.width)!,(photoImage?.cgImage?.height)!)

        UIGraphicsBeginImageContext(CGSize(width: photoRect.width, height: photoRect.height))
        photoImage?.draw(in: CGRect(x: 0, y: 0, width: photoRect.width, height: photoRect.height))
        sketchImage.draw(in: CGRect(x: 0, y: 0, width: photoRect.width, height: photoRect.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        compositedImage = image
        compositedImageView.image = image
//        UIImage *background = [UIImage imageNamed:@"background.png"];
//        UIImage *stamp = [UIImage imageNamed:@"stamp.png"];
//        
//        CGFloat backWidth = CGImageGetWidth(background.CGImage);
//        CGFloat backHeight = CGImageGetHeight(background.CGImage);
//
//        CGFloat stampWidth = CGImageGetWidth(stamp.CGImage);
//        CGFloat stampHeight = CGImageGetHeight(stamp.CGImage);
//        
//        
//        UIGraphicsBeginImageContext(CGSizeMake(backWidth, backHeight));
//        [background drawInRect:CGRectMake(0, 0, backWidth, backHeight)];
//        [stamp drawInRect:CGRectMake(0, 0, stampWidth, stampHeight)];
//        
//        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        UIImageView *iv = [[UIImageView alloc]initWithImage:image];
//        [iv setCenter:self.view.center];
//        [self.view addSubview:iv];
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
