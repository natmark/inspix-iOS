//
//  CameraViewController.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    @IBOutlet weak var cameraView: CameraView!
    @IBOutlet weak var drawableView: DrawableView!
    @IBOutlet weak var guideView: GuideView!
    @IBOutlet weak var guideBtn: UIBarButtonItem!
    @IBOutlet weak var pinBtn: UIBarButtonItem!
    
    @IBOutlet weak var penBtn: UIBarButtonItem!
    @IBOutlet weak var eraserBtn: UIBarButtonItem!
    @IBOutlet weak var pinnedImageView: UIImageView!
    
    var isShowingGuide = false
    var isPinningPhoto = false
    var isSelectingPen = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func returnHomeView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func bgColorChange(_ sender: UISlider) {
        self.drawableView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: CGFloat(sender.value))
    }
    @IBAction func showingGuideView(_ sender: Any) {
        self.guideView.isHidden = !self.guideView.isHidden

        isShowingGuide = !isShowingGuide

        guideBtn.tintColor = isShowingGuide ? UIColor.selectedTintColor() : UIColor.black
    }
    @IBAction func switchPenMode(_ sender: UIBarButtonItem) {
        isSelectingPen = !isSelectingPen
        if isSelectingPen {
            penBtn.tintColor = UIColor.selectedTintColor()
            eraserBtn.tintColor = UIColor.black
            drawableView.blendMode = CGBlendMode.normal
        }else{
            eraserBtn.tintColor = UIColor.selectedTintColor()
            penBtn.tintColor = UIColor.black
                        drawableView.blendMode = CGBlendMode.clear
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        cameraView.takePhoto(completionHandler: { image in
            var photo_image = image
            if self.isPinningPhoto {
                    photo_image = self.pinnedImageView.image!
            }
            var sketch_image = self.drawableView.image
        })
    }
    @IBAction func pinnedPhoto(_ sender: UIBarButtonItem) {
        if isPinningPhoto == true{
            pinBtn.tintColor = UIColor.black
            pinnedImageView.isHidden = true
            isPinningPhoto = false
            return
        }else{
            guard let image = cameraView.capturingImage else{
                return
            }
            pinnedImageView.image = image
            pinnedImageView.isHidden = false
            pinBtn.tintColor = UIColor.selectedTintColor()
            isPinningPhoto = true
        }
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
