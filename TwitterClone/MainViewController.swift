//
//  MainViewController.swift
//  TwitterClone
//
//  Created by hirotaka.iwasaki on 2020/01/09.
//  Copyright © 2020 hrtkhrtk. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    
    //var itemId:Int!
    var itemId:Int = -1
    
    @IBAction func handleFabButton(_ sender: Any) {
        // 画面を表示する
        let sendingPostViewController = self.storyboard?.instantiateViewController(withIdentifier: "SendingPost")
        self.present(sendingPostViewController!, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            // ログインしていないときの処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
    }
    
    // segue で画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let mainWithFabViewController:MainWithFabViewController = segue.destination as! MainWithFabViewController
        if segue.identifier == "segueToMainWithFabViewController" {
            if self.itemId < 0 {
                // ここは動作する予定はないが
                self.itemId = Const.item_id__nav_posts // 最初はnav_posts
                print("DEBUG_PRINT: ここは動作する予定はない01")
            }
            
            mainWithFabViewController.itemId = self.itemId
        }
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
