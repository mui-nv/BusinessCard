//
//  LoginViewController.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var textUser: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBAction func actionLogin(_ sender: Any) {
        login(user: textUser.text!, password: textPassword.text!)
    }
    
    let userRepository = UserRepository()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func login(user: String, password: String) {
        let userData = CreateUserParam(user: user, password: password)
        userRepository.selectUser(data: userData)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { value in
                self.moveToMain()
            }, onError: { _ in
                self.showErrorDialog(messgae: "an error has occured!")
            })
            .disposed(by: disposeBag)
    }
    
    func moveToMain() {
        let vc: UITabBarController = self.storyboard?.instantiateViewController(withIdentifier: "mainTab") as! UITabBarController
        
        vc.selectedIndex = 0
        
        self.present(vc, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
