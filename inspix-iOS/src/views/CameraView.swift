//
//  CameraView.swift
//  ARCamera
//
//  Created by AtsuyaSato on 2017/03/07.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIView, AVCaptureVideoDataOutputSampleBufferDelegate, UIGestureRecognizerDelegate {
    var input:AVCaptureDeviceInput!
    var output:AVCaptureVideoDataOutput!
    var imageOutput: AVCaptureStillImageOutput!
    var session:AVCaptureSession!
    var camera:AVCaptureDevice!
    var capturingImage:UIImage?
        
    init() {
        super.init(frame: CGRect.zero)
        setupCamera()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCamera()
    }
    public func startCapturing(){
        session.startRunning()
    }
    public func stopCapturing(){
        session.stopRunning()
    }
    //使用するカメラの設定
    func setupCamera(){
        // AVCaptureSession: キャプチャに関する入力と出力の管理
        session = AVCaptureSession()
        
        // sessionPreset: キャプチャ・クオリティの設定
        session.beginConfiguration()
        
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        session.commitConfiguration()
        
        let devices = AVCaptureDevice.devices()
        
        // バックカメラをmyDeviceに格納.
        for device in devices! {
            if((device as AnyObject).position == .back){
                camera = device as! AVCaptureDevice
            }
        }
        
        // カメラからの入力データ
        do {
            input = try AVCaptureDeviceInput(device: camera) as AVCaptureDeviceInput
        } catch let error as NSError {
            print(error)
        }
        
        // 入力をセッションに追加
        if(session.canAddInput(input)) {
            session.addInput(input)
        }
        
        //写真撮影用のImageOutput
        imageOutput = AVCaptureStillImageOutput()
        // 出力をセッションに追加
        if(session.canAddOutput(imageOutput)) {
            session.addOutput(imageOutput)
        }
        
        //ピン留め用のVideoOutput
        // AVCaptureVideoDataOutput:動画フレームデータを出力に設定
        output = AVCaptureVideoDataOutput()
        
        // 出力をセッションに追加
        if(session.canAddOutput(output)) {
            session.addOutput(output)
        }
        
        // ピクセルフォーマットを 32bit BGR + A とする
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable : Int(kCVPixelFormatType_32BGRA)]
        
        // フレームをキャプチャするためのサブスレッド用のシリアルキューを用意
        output.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        
        output.alwaysDiscardsLateVideoFrames = true

        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.frame = self.bounds
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.layer.addSublayer(previewLayer!)

        session.startRunning()
        
        // deviceをロックして設定
        do {
            try camera.lockForConfiguration()
            // フレームレート
            camera.activeVideoMinFrameDuration = CMTimeMake(1, 30)
            camera.unlockForConfiguration()
        } catch _ {
        }
    }
    
    // 新しいキャプチャの追加で呼ばれる
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        capturingImage = self.captureImage(sampleBuffer: sampleBuffer)
        
        // カメラの画像を画面に表示
//        dispatch_get_main_queue().asynchronously() {
//            self.imageView.image = image
//        }
    }
    func takePhoto(completionHandler: @escaping (_ image: UIImage) -> ()){

        let output:AVCaptureStillImageOutput! = imageOutput
        if let connection:AVCaptureConnection? = output.connection(withMediaType: AVMediaTypeVideo) {
            connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            
            output.captureStillImageAsynchronously(from: connection,
                                                   completionHandler: {
                                                    (imageDataBuffer, error) -> Void in
                                                    
                                                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
                                                    //背景の写真
                                                    let image = UIImage(data: imageData!)!
                                                    let fixed_image = self.fixOrientationOfImage(image: image)
                                                    let orientation = fixed_image?.imageOrientation
                                                    
                                                    completionHandler(fixed_image!)
            })
        }
    }
    func fixOrientationOfImage(image: UIImage) -> UIImage? {
        if image.imageOrientation == .up {
            return image
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransform.identity
        
        switch image.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: image.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: image.size.height)
            transform = transform.rotated(by: -CGFloat(M_PI_2))
        default:
            break
        }
        
        switch image.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: image.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        guard let context = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue) else {
            return nil
        }
        
        context.concatenate(transform)
        
        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width))
        default:
            context.draw(image.cgImage!, in: CGRect(origin: .zero, size: image.size))
        }
        
        // And now we just create a new UIImage from the drawing context
        guard let CGImage = context.makeImage() else {
            return nil
        }
        
        return UIImage(cgImage: CGImage)
    }
    // sampleBufferからUIImageを作成
    func captureImage(sampleBuffer:CMSampleBuffer) -> UIImage{
        
        // Sampling Bufferから画像を取得
        let imageBuffer:CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        // pixel buffer のベースアドレスをロック
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        let baseAddress:UnsafeMutableRawPointer = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0)!
        
        let bytesPerRow:Int = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width:Int = CVPixelBufferGetWidth(imageBuffer)
        let height:Int = CVPixelBufferGetHeight(imageBuffer)
        
        // 色空間
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let newContext:CGContext = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace,  bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue|CGBitmapInfo.byteOrder32Little.rawValue)!
        
        let imageRef:CGImage = newContext.makeImage()!
        let resultImage = UIImage(cgImage: imageRef, scale: 1.0, orientation: UIImageOrientation.right)
        
        return resultImage
    }

}
