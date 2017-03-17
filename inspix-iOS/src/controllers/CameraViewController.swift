//
//  CameraViewController.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import AVFoundation
import PINRemoteImage

class CameraViewController: UIViewController {

    @IBOutlet weak var cameraView: CameraView!
    @IBOutlet weak var drawableView: DrawableView!
    @IBOutlet weak var guideView: GuideView!
    @IBOutlet weak var guideBtn: UIBarButtonItem!
    @IBOutlet weak var pinBtn: UIBarButtonItem!
    
    @IBOutlet weak var penBtn: UIBarButtonItem!
    @IBOutlet weak var eraserBtn: UIBarButtonItem!
    @IBOutlet weak var pinnedImageView: UIImageView!
    
    @IBOutlet var colorButtons:[UIButton]!
    
    var isShowingGuide = false
    var isPinningPhoto = false
    var isSelectingPen = true
    
    var inspiration: Inspiration?
    
    @IBOutlet weak var shutterBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        colorButtons.forEach({ $0.clipsToBounds = true; $0.layer.cornerRadius = 15;$0.layer.borderColor = UIColor.white.cgColor; $0.layer.borderWidth = 3.0 })
        colorButtons.first?.layer.borderColor = UIColor.clear.cgColor
        
        if let inspiration = inspiration{
            shutterBtn.isEnabled = false
            shutterBtn.image = nil
            guideBtn.image = nil
            pinBtn.image = UIImage(named:"btn_done")
            pinBtn.tintColor = UIColor.selectedTintColor()
            print(inspiration.backgroundImageUrl)
            pinnedImageView.pin_setImage(from: URL(string: inspiration.backgroundImageUrl))
            pinnedImageView.isHidden = false
            self.cameraView.stopCapturing()
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func returnHomeView(_ sender: Any) {
         _ = self.navigationController?.popViewController(animated: true)
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
            var photoImage = image
            if self.isPinningPhoto {
                    photoImage = self.pinnedImageView.image!
            }
            let sketchImage = self.drawableView.image
            
            //シェア画面へ
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextView = mainStoryboard.instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
            nextView.photoImage = photoImage
            nextView.sketchImage = sketchImage
            self.navigationController?.pushViewController(nextView, animated: true)
        })
    }
    @IBAction func pinnedPhoto(_ sender: UIBarButtonItem) {
        if let _ = inspiration{
            //MARK: 乗っかりモード時に、ピンボタンをフックしている
            let photoImage = self.pinnedImageView.image!
            let sketchImage = self.drawableView.image
            
            //シェア画面へ
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextView = mainStoryboard.instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
            nextView.photoImage = photoImage
            nextView.sketchImage = sketchImage
            nextView.inspiration = inspiration
            self.navigationController?.pushViewController(nextView, animated: true)

            return
        }
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
    @IBAction func changeColorToBlack(_ sender: UIButton) {
        self.drawableView.penColor = UIColor.black
        
        colorButtons.forEach({ $0.clipsToBounds = true; $0.layer.cornerRadius = 15;$0.layer.borderColor = UIColor.white.cgColor; $0.layer.borderWidth = 3.0 })
        sender.layer.borderColor = UIColor.clear.cgColor
    }
    @IBAction func changeColorToBlue(_ sender: UIButton) {
        self.drawableView.penColor = UIColor.selectedTintColor()
        colorButtons.forEach({ $0.clipsToBounds = true; $0.layer.cornerRadius = 15;$0.layer.borderColor = UIColor.white.cgColor; $0.layer.borderWidth = 3.0 })
        sender.layer.borderColor = UIColor.clear.cgColor
    }
    @IBAction func changeColorToPink(_ sender: UIButton) {
        self.drawableView.penColor = UIColor(red: 232/255.0, green: 122/255.0, blue: 164/255.0, alpha: 1.0)
        colorButtons.forEach({ $0.clipsToBounds = true; $0.layer.cornerRadius = 15;$0.layer.borderColor = UIColor.white.cgColor; $0.layer.borderWidth = 3.0 })
        sender.layer.borderColor = UIColor.clear.cgColor
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
