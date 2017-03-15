//
//  UserRegistViewController.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import PKHUD
import APIKit

class UserRegistViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.userNameTextField.resignFirstResponder()
        return true
    }

    @IBAction func userRegist(_ sender: Any) {
        HUD.show(.progress)
        
        guard let userName = userNameTextField.text else{
            return
        }
        // 英数字のみであることをチェック
        let predicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z]*")
        if predicate.evaluate(with: userName) == false {
            HUD.flash(.label("半角英数字のみを指定してください"),delay:1.0)
            return
        }

        
        let password = Util().randomPassGenerator()
        UserConfigManager.sharedManager.saveUserPassword(password)
        
        let request = PostUserRegistRequest(userName: userName, password: password)
        //ユーザ登録
        Session.send(request) { result in
            switch result {
            case .success(let user):
                print("userId: \(user.id)")
                UserConfigManager.sharedManager.saveUserId(user.id)
                self.login(user.id, password)
                
            case .failure(.responseError(let inspixError as InspixError)):
                print(inspixError.message)
                HUD.flash(.label(inspixError.message),delay:1.0)
                
            case .failure(let error):
                print("Unknown error: \(error)")
                HUD.flash(.error, delay: 1.0)

            }
        }
    }
    func login(_ userId:Int,_ password:String){
        let request = PostUserLoginRequest(userId: userId, password: password)
        Session.send(request) { result in
            switch result {
            case .success(let login):
                if login.result == true {
                    HUD.flash(.success, delay: 1.0)
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                    self.present(nextView, animated: true, completion: nil)
                }else{
                    HUD.flash(.label("ログインに失敗しました"),delay:1.0)
                }
            case .failure(.responseError(let inspixError as InspixError)):
                print(inspixError.message)
                HUD.flash(.label(inspixError.message),delay:1.0)

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
