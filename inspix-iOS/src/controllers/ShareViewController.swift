//
//  ShareViewController.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/15.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import RealmSwift

class ShareViewController: UIViewController {
    var photoImage : UIImage?
    var sketchImage : UIImage?
    var compositedImage : UIImage?
    
    @IBOutlet weak var sketchTitleTextField: UITextField!
    @IBOutlet weak var compositedImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noteTextView: PlaceHolderTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let sketchImage = sketchImage else{
            compositedImage = photoImage
            compositedImageView.image = photoImage
            return
        }
        //画像の合成
       let photoRect:(width:Int,height:Int) = ((photoImage?.cgImage?.width)!,(photoImage?.cgImage?.height)!)

        UIGraphicsBeginImageContext(CGSize(width: photoRect.width, height: photoRect.height))
        photoImage?.draw(in: CGRect(x: 0, y: 0, width: photoRect.width, height: photoRect.height))
        sketchImage.draw(in: CGRect(x: 0, y: 0, width: photoRect.width, height: photoRect.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        compositedImage = image
        compositedImageView.image = image
    }

    @IBAction func saveSketch(_ sender: UIBarButtonItem) {
        let sketch = Sketch()
        
        if let title = sketchTitleTextField.text {
            sketch.title = title
        }else{
            sketch.title = ""
        }
        sketch.note = noteTextView.text
        
        if let sketchImage = sketchImage {
            sketch.sketchImage = UIImagePNGRepresentation(sketchImage) as NSData?
        }
        if let photoImage = photoImage {
            sketch.photoImage = UIImagePNGRepresentation(photoImage) as NSData?
        }
        if let compositedImage = compositedImage {
            sketch.compositedImage = UIImagePNGRepresentation(compositedImage) as NSData?
        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(sketch)
        }
        
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController.isKind(of: HomeViewController.self) {
                _ = self.navigationController?.popToViewController(viewController, animated: false)
            }
        }
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
