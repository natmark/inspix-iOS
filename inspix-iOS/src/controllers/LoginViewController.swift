//
//  LoginViewController.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/13.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import PKHUD
import APIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        let userAuth = UserConfigManager.sharedManager.getUserAuth()
        if let userId = userAuth.userId, let userPassword = userAuth.userPassword {
            //ログイン
            login(userId,userPassword)
        } else {
            //ユーザ登録
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextView = mainStoryboard.instantiateViewController(withIdentifier: "UserRegistViewController") as! UserRegistViewController
            self.present(nextView, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    func login(_ userId:Int,_ password:String){
        HUD.show(.progress)
        let request = PostUserLoginRequest(userId: userId, password: password)
        Session.send(request) { result in
            switch result {
            case .success(let login):
                if login.result == true {
                    HUD.flash(.success, delay: 1.0)
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.navigationController?.pushViewController(nextView, animated: false)
                }else{
                    HUD.flash(.error, delay: 1.0)
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = mainStoryboard.instantiateViewController(withIdentifier: "UserRegistViewController") as! UserRegistViewController
                    self.present(nextView, animated: true, completion: nil)
                }
            case .failure(let error):
                print("error: \(error)")
                HUD.flash(.error, delay: 1.0)
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
