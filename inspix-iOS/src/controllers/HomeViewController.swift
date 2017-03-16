//
//  HomeViewController.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import RealmSwift
import APIKit

enum CollectionViewID : Int{
    case MySketch = 0
    case Pickup = 1
    case Favorite = 2
}
class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var firstViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondViewContstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var firstViewSwitcherConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondViewSwitcherConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdViewSwitcherConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mySketchCollectionView: UICollectionView!
    @IBOutlet weak var pickupCollectionView: UICollectionView!
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    @IBOutlet var switcherButtons: [UIButton]!

    var showingView:CollectionViewID = .MySketch
    var sketches:[Sketch] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleImageView = UIImageView(image: UIImage(named: "header"))
        self.navigationItem.titleView = titleImageView
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        let sketchCellNib = UINib(nibName: "SketchCollectionViewCell", bundle: nil)
        self.mySketchCollectionView.register(sketchCellNib, forCellWithReuseIdentifier: "sketchCell")
        self.mySketchCollectionView.delegate = self
        self.mySketchCollectionView.dataSource = self
        self.mySketchCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // Do any additional setup after loading the view.
        
        let request = GetFollowTimeLineRequest(pager: 1)
        Session.send(request) { result in
            switch result {
            case .success(let timeline):
                print(timeline)
                
            case .failure(.responseError(let inspixError as InspixError)):
                print(inspixError.message)
        
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        sketches = []
        let realm = try! Realm()
        for sketch in realm.objects(Sketch.self) {
            sketches.insert(sketch, at: 0)
        }
        self.mySketchCollectionView.reloadData()
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
        let width = collectionView.frame.size.width / 2 - 0.5
        let returnSize = CGSize(width: width, height: width)
        
        return returnSize
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 要素数を入れる、要素以上の数字を入れると表示でエラーとなる
        return sketches.count
    }

    @IBAction func selectMySwitch(_ sender: UIButton) {
        switchShowingView(index: .MySketch)
    }
    @IBAction func selectPickup(_ sender: UIButton) {
        switchShowingView(index: .Pickup)
    }
    @IBAction func selectFavorite(_ sender: UIButton) {
        switchShowingView(index: .Favorite)
    }
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        //ページ戻し
        if showingView != CollectionViewID.MySketch {
            switchShowingView(index: CollectionViewID(rawValue: showingView.rawValue - 1)!)
        }
    }
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        //ページめくり
        if showingView != CollectionViewID.Favorite {
            switchShowingView(index: CollectionViewID(rawValue: showingView.rawValue + 1)!)
        }
    }
    
    func switchShowingView(index:CollectionViewID){
        showingView = index

        switch index {
        case .MySketch:
            NSLayoutConstraint.deactivate([secondViewContstraint,thirdViewConstraint])
            NSLayoutConstraint.deactivate([secondViewSwitcherConstraint,thirdViewSwitcherConstraint])
            NSLayoutConstraint.activate([firstViewConstraint])
            NSLayoutConstraint.activate([firstViewSwitcherConstraint])
            
        case .Pickup:
            NSLayoutConstraint.deactivate([firstViewConstraint,thirdViewConstraint])
            NSLayoutConstraint.deactivate([firstViewSwitcherConstraint,thirdViewSwitcherConstraint])
            NSLayoutConstraint.activate([secondViewContstraint])
            NSLayoutConstraint.activate([secondViewSwitcherConstraint])
 
        case .Favorite:
            NSLayoutConstraint.deactivate([secondViewContstraint,firstViewConstraint])
            NSLayoutConstraint.deactivate([secondViewSwitcherConstraint,firstViewSwitcherConstraint])
            NSLayoutConstraint.activate([thirdViewConstraint])
            NSLayoutConstraint.activate([thirdViewSwitcherConstraint])
        
        default:
            break
        }
        
        // 更新をかける
        UIView.animate(
            withDuration: 0.3,
            delay:0.1,
            options:UIViewAnimationOptions.curveEaseOut,
            animations: {() -> Void in
                self.view.layoutIfNeeded()

                self.switcherButtons.forEach({ $0.titleLabel?.font = UIFont.systemFont(ofSize: 15) })
                self.switcherButtons.forEach({ $0.setTitleColor(UIColor.lightGray, for: .normal) })
                self.switcherButtons.filter({ $0.tag == self.showingView.rawValue}).forEach({ $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15) })
                self.switcherButtons.filter({ $0.tag == self.showingView.rawValue}).forEach({ $0.setTitleColor(UIColor.black, for: .normal) })

        },
            completion: nil
        )

    }
}
