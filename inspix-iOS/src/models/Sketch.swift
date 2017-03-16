//
//  Sketch.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/16.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Sketch: Object {
    dynamic var title = ""
    dynamic var note = ""
    dynamic var time = ""
    dynamic var photoImage : NSData?
    dynamic var sketchImage : NSData?
    dynamic var compositedImage : NSData?
}
