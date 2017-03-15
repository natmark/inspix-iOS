//
//  GuideView.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/15.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import UIKit
class GuideView : UIView {
    override func draw(_ rect: CGRect) {
        
        let y0line:(x0:CGFloat,y0:CGFloat,x1:CGFloat,y1:CGFloat) = (rect.size.width / 3,0,rect.size.width / 3,rect.size.height)

        let y1line:(x0:CGFloat,y0:CGFloat,x1:CGFloat,y1:CGFloat) = (rect.size.width / 3 * 2,0,rect.size.width / 3 * 2,rect.size.height)
        let x0line:(x0:CGFloat,y0:CGFloat,x1:CGFloat,y1:CGFloat) = (0,rect.size.height / 3,rect.size.width,rect.size.height / 3)
        let x1line:(x0:CGFloat,y0:CGFloat,x1:CGFloat,y1:CGFloat) = (0,rect.size.height / 3 * 2,rect.size.width,rect.size.height / 3 * 2)
        
        
        for line_tupple in [y0line,y1line,x0line,x1line] {
            let line = UIBezierPath()
            // 起点
            line.move(to: CGPoint(x: line_tupple.x0, y: line_tupple.y0))
            // 帰着点
            line.addLine(to: CGPoint(x:  line_tupple.x1, y: line_tupple.y1))
            // ラインを結ぶ
            line.close()
            // 色の設定
            UIColor.selectedTintColor().setStroke()
            // ライン幅
            line.lineWidth = 2
            // 描画
            line.stroke()
        }
    }
}
