//
//  CameraViewController.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet weak var cameraView: CameraView!
    @IBOutlet weak var drawableView: DrawableView!
    @IBOutlet weak var guideView: GuideView!
    @IBOutlet weak var guideBtn: UIBarButtonItem!
    
    @IBOutlet weak var penBtn: UIBarButtonItem!
    @IBOutlet weak var eraserBtn: UIBarButtonItem!
    
    var isShowingGuide = false
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
