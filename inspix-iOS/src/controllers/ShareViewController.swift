//
//  ShareViewController.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/15.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import RealmSwift
import APIKit
import PKHUD
import CoreLocation

class ShareViewController: UIViewController, CLLocationManagerDelegate {
    var photoImage : UIImage?
    var sketchImage : UIImage?
    var compositedImage : UIImage?
    var longitude : Float = 0.0
    var latitude : Float = 0.0
    var locationManager = CLLocationManager()
    
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
        
        //位置情報取得開始
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
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
        HUD.show(.progress)
       //位置情報取得終了
        if CLLocationManager.locationServicesEnabled() {
            locationManager.stopUpdatingLocation()
        }

        //Realm用データの用意
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
        
        sketch.latitude = Double(latitude)
        sketch.longitude = Double(longitude)
        
        let now = NSDate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let timeString = formatter.string(from: now as Date)
        sketch.time = timeString
        
        let realm = try! Realm()
        
        //Realmへのアップロード
        do{
            try realm.write {
                realm.add(sketch)
            }
        }catch{
            HUD.flash(.error, delay: 1.0)
            for viewController in (self.navigationController?.viewControllers)! {
                if viewController.isKind(of: HomeViewController.self) {
                    _ = self.navigationController?.popToViewController(viewController, animated: false)
                }
            }
        }
        
        // NSDate型 "date" をUNIX時間 "dateUnix" に変換
        let dateUnix: TimeInterval? = NSDate().timeIntervalSince1970

        //サーバへのアップロード
        uploadImage(completionHandler:{ url in
            
             let request = PostInspirationRequest(baseImageUrl: url["base_image_url"]!, backgroundImageUrl: url["background_image_url"]!, compositedImageUrl: url["composited_image_url"]!, capturedTime: Int(dateUnix!), longitude: self.longitude, latitude: self.latitude, caption: sketch.note, title: sketch.title)
            
            print(request)
            
            Session.send(request) { result in
                switch result {
                case .success(let res):
                    print(res)
                    HUD.flash(.success, delay: 1.0)
                    for viewController in (self.navigationController?.viewControllers)! {
                        if viewController.isKind(of: HomeViewController.self) {
                            _ = self.navigationController?.popToViewController(viewController, animated: false)
                        }
                    }
                case .failure(let error):
                    print("error: \(error)")
                    HUD.flash(.error, delay: 1.0)
                    for viewController in (self.navigationController?.viewControllers)! {
                        if viewController.isKind(of: HomeViewController.self) {
                            _ = self.navigationController?.popToViewController(viewController, animated: false)
                        }
                    }
                }
            }
        })
    }
    @IBAction func backToCameraView(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    // MARK: - 位置情報
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        
        latitude =  Float(newLocation.coordinate.latitude)
        longitude = Float(newLocation.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    // MARK: - 画像アップローダー
    func uploadImage(completionHandler: @escaping ([String:String]) -> Void){
        let photoPngData = NSData(data: UIImagePNGRepresentation(photoImage!)!)
        let photoPng64Str = photoPngData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength76Characters)
        
        var sketchPng64Str = ""
        if sketchImage != nil{
            let sketchPngData = NSData(data: UIImagePNGRepresentation(sketchImage!)!)
            sketchPng64Str = sketchPngData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength76Characters)
        }
        
        var compositedPng64Str = ""
        if compositedImage != nil{
            let compositedPngData = NSData(data: UIImagePNGRepresentation(compositedImage!)!)
            compositedPng64Str = compositedPngData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength76Characters)
        }
        
        var photoUrl:String = ""
        var sketchUrl:String = ""
        var compositedUrl:String = ""
        
        let request = PutImageUploadRequest(bin: photoPng64Str, ext: "png")
        Session.send(request) { result in
            switch result {
            case .success(let response):
                photoUrl = response.fileUrl
                
                let request = PutImageUploadRequest(bin: sketchPng64Str, ext: "png")
                Session.send(request) { result in
                    switch result {
                    case .success(let response):
                        sketchUrl = response.fileUrl
                        
                        let request = PutImageUploadRequest(bin: compositedPng64Str, ext: "png")
                        Session.send(request) { result in
                            switch result {
                            case .success(let response):
                                compositedUrl = response.fileUrl
                                completionHandler(["base_image_url":sketchUrl,"background_image_url":photoUrl,"composited_image_url":compositedUrl])
                                
                            case .failure(let error):
                                print("error: \(error)")
                            completionHandler(["base_image_url":sketchUrl,"background_image_url":photoUrl,"composited_image_url":compositedUrl])
                            }
                        }
                    case .failure(let error):
                        print("error: \(error)")
                    completionHandler(["base_image_url":sketchUrl,"background_image_url":photoUrl,"composited_image_url":compositedUrl])
                    }
                }
            case .failure(let error):
                print("error: \(error)")
            completionHandler(["base_image_url":sketchUrl,"background_image_url":photoUrl,"composited_image_url":compositedUrl])
            }
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
