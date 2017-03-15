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
    var output:AVCaptureStillImageOutput!
    var session:AVCaptureSession!
    var camera:AVCaptureDevice!
        
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
        
        // AVCaptureVideoDataOutput:動画フレームデータを出力に設定
        output = AVCaptureStillImageOutput()
        
        // 出力をセッションに追加
        if(session.canAddOutput(output)) {
            session.addOutput(output)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.frame = self.frame
        self.layer.addSublayer(previewLayer!)
        
        session.startRunning()
    }
}
