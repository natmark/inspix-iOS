//
//  DrawableView.swift
//  DrawableView
//
//  Created by AtsuyaSato on 2017/03/13.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import CoreGraphics
class DrawableView: UIImageView {
    var blendMode:CGBlendMode = CGBlendMode.color
    var previousTouchLocation: CGPoint?
    var coalescedTouches : [UITouch]?
    init() {
        super.init(frame: CGRect.zero)
        initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    func initialize(){
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        previousTouchLocation = touches.first?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        coalescedTouches = event?.coalescedTouches(for: touches.first!)
        draw(self.frame)
    }
    override func draw(_ rect: CGRect) {
        guard let coalescedTouches = coalescedTouches else {
            return
        }
        UIGraphicsBeginImageContext(rect.size)
        self.image?.draw(at: CGPoint(x: 0, y: 0))

        let cgContext = UIGraphicsGetCurrentContext()
        cgContext?.setLineCap(CGLineCap.round)
        cgContext?.setStrokeColor(UIColor.black.cgColor)
        cgContext?.setBlendMode(blendMode)
        for coalescedTouch in coalescedTouches
        {
            let lineWidth = coalescedTouch.force != 0 ?
                (coalescedTouch.force / coalescedTouch.maximumPossibleForce) * 10 :
            10
            cgContext?.setLineWidth(lineWidth)
            cgContext?.move(to: CGPoint(x: previousTouchLocation!.x, y: previousTouchLocation!.y))
            cgContext?.addLine(to: CGPoint(x: coalescedTouch.location(in: self).x, y: coalescedTouch.location(in: self).y))
            previousTouchLocation = coalescedTouch.location(in: self)
            cgContext?.strokePath()
        }
        let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
        self.image = drawnImage
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        previousTouchLocation = nil
    }
}
