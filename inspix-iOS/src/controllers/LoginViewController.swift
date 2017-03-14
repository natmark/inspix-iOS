//
//  LoginViewController.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/13.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        SVProgressHUD.show()
        let userAuth = UserConfigManager.sharedManager.getUserAuth()
        if let userId = userAuth.userId, let userPassword = userAuth.userPassword {
            //ログイン
            login(userId,userPassword)
        } else {
            SVProgressHUD.dismiss()
            let menuStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextView = menuStoryboard.instantiateViewController(withIdentifier: "UserRegistViewController") as! UserRegistViewController
            self.present(nextView, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    func login(_ userId:Int,_ password:String){
        SVProgressHUD.dismiss()
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
