//
//  UserRegistViewController.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import SVProgressHUD
import APIKit

class UserRegistViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    @IBAction func userRegist(_ sender: Any) {
        SVProgressHUD.show()
        
        guard let userName = userNameTextField.text else{
            return
        }
        let password = Util().randomPassGenerator()
        UserConfigManager.sharedManager.saveUserPassword(password)
        
        let request = PostUserRegistRequest(userName: userName, password: password)

        Session.send(request) { result in
            switch result {
            case .success(let user):
                print("userId: \(user.id)")
                UserConfigManager.sharedManager.saveUserId(user.id)
                SVProgressHUD.showSuccess(withStatus: "登録完了")
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                print("error: \(error)")
                SVProgressHUD.showError(withStatus: error.localizedDescription)
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
