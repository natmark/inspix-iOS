//
//  HomeViewController.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var sketches:[Sketch] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleImageView = UIImageView(image: UIImage(named: "header"))
        self.navigationItem.titleView = titleImageView

        let sketchCellNib = UINib(nibName: "SketchCollectionViewCell", bundle: nil)
        self.collectionView.register(sketchCellNib, forCellWithReuseIdentifier: "sketchCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        sketches = []
        let realm = try! Realm()
        for sketch in realm.objects(Sketch.self) {
            sketches.insert(sketch, at: 0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let sketchCell:SketchCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "sketchCell", for: indexPath) as! SketchCollectionViewCell
        
        if let compositedImageData = sketches[indexPath.row].compositedImage {
            sketchCell.thumbnailImageView.image = UIImage(data: compositedImageData as Data)
        }
        return sketchCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = mainStoryboard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        nextView.sketch = sketches[indexPath.row]
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.size.width / 2 - 0.5
        let returnSize = CGSize(width: width, height: width)
        
        return returnSize
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 要素数を入れる、要素以上の数字を入れると表示でエラーとなる
        return sketches.count
    }

}
