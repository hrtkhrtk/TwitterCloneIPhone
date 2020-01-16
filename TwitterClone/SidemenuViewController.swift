//
//  SidemenuViewController.swift
//  TwitterClone
//
//  Created by hirotaka.iwasaki on 2020/01/09.
//  Copyright © 2020 hrtkhrtk. All rights reserved.
//

import UIKit
import Firebase

protocol SidemenuViewControllerDelegate: class {
    func sidemenuViewControllerDidRequestShowing(_ sidemenuViewController: SidemenuViewController, contentAvailability: Bool, animated: Bool)
    func sidemenuViewControllerDidRequestHiding(_ sidemenuViewController: SidemenuViewController, animated: Bool)
    func sidemenuViewController(_ sidemenuViewController: SidemenuViewController, didSelectItemAt indexPath: IndexPath)
}

class SidemenuViewController: UIViewController {
    private let contentView = UIView(frame: .zero)
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var screenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    weak var delegate: SidemenuViewControllerDelegate?
    private var beganLocation: CGPoint = .zero
    private var beganState: Bool = false
    var isShown: Bool {
        return self.parent != nil
    }
    private var contentMaxWidth: CGFloat {
        return view.bounds.width * 0.8
    }
    private var contentRatio: CGFloat {
        get {
            return contentView.frame.maxX / contentMaxWidth
        }
        set {
            let ratio = min(max(newValue, 0), 1)
            contentView.frame.origin.x = contentMaxWidth * ratio - contentView.frame.width
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowRadius = 3.0
            contentView.layer.shadowOpacity = 0.8
            
            view.backgroundColor = UIColor(white: 0, alpha: 0.3 * ratio)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var contentRect = view.bounds
        contentRect.size.width = contentMaxWidth
        contentRect.origin.x = -contentRect.width
        contentView.frame = contentRect
        contentView.backgroundColor = .white
        contentView.autoresizingMask = .flexibleHeight
        view.addSubview(contentView)
        
        tableView.frame = contentView.bounds
        tableView.separatorInset = .zero
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Default")
        contentView.addSubview(tableView)
        tableView.reloadData()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(sender:)))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
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
    
    @objc private func backgroundTapped(sender: UITapGestureRecognizer) {
        hideContentView(animated: true) { (_) in
            //self.willMove(toParentViewController: nil)
            self.willMove(toParent: nil)
            //self.removeFromParentViewController()
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }

    func showContentView(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.contentRatio = 1.0
            }
        } else {
            contentRatio = 1.0
        }
    }
    
    func hideContentView(animated: Bool, completion: ((Bool) -> Swift.Void)?) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentRatio = 0
            }, completion: { (finished) in
                completion?(finished)
            })
        } else {
            contentRatio = 0
            completion?(true)
        }
    }
}

extension SidemenuViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)
        //cell.textLabel?.text = "Item \(indexPath.row)"
        if indexPath.row == 0 {
            cell.textLabel?.text = "posts"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "search_posts"
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "search_users"
        } else if indexPath.row == 3 {
            cell.textLabel?.text = "followings_list"
        } else if indexPath.row == 4 {
            cell.textLabel?.text = "followers_list"
        } else if indexPath.row == 5 {
            cell.textLabel?.text = "favorites_list"
        } else if indexPath.row == 6 {
            cell.textLabel?.text = "my_posts"
        } else if indexPath.row == 7 {
            cell.textLabel?.text = "policy"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sidemenuViewController(self, didSelectItemAt: indexPath)
        
        //print("testtest")
        //print(self.presentingViewController) // test // nil
        //print(UIApplication.shared.keyWindow?.rootViewController) // test // Optional(<UINavigationController: 0x7ff97700a400>)
        //print(UIApplication.shared.keyWindow?.rootViewController?.presentingViewController) // test // nil
        //print(self.presentingNavigationController) // test
        //print(self.presentingNavigationController.viewControllers[0]) // test
        //print(UIApplication.shared.keyWindow?.rootViewController?.viewControllers[0]) // test
        //let preNC = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController // test // 参考：https://qiita.com/wadaaaan/items/acc8967c836d616e3b0b
        //print(preNC.viewControllers[0]) // test // <TwitterClone.ViewController: 0x7fb4e640b4a0>
        //print(preNC.viewControllers[1]) // test
        //print(preNC.viewControllers[2]) // test
        //print(preNC.viewControllers.count) // test // 1
        //print(preNC.viewControllers[0].presentingViewController) // test // nil
        //print(preNC.viewControllers[0].children) // test // [<TwitterClone.MainViewController: 0x7fe0c2604b30>, <TwitterClone.SidemenuViewController: 0x7fe0c2613ca0>]
        //print(preNC.viewControllers[0].children[0]) // test // <TwitterClone.MainViewController: 0x7fc09440d2b0>
        
        //print(indexPath.row) // test
        
        if indexPath.row == 0 { // "posts"
            //let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            //print("loginViewController") // test
            //print(loginViewController) // test // nil
            //self.present(loginViewController!, animated: true, completion: nil)
            
            let preNC = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController // test // 参考：https://qiita.com/wadaaaan/items/acc8967c836d616e3b0b
            let mainViewController = preNC.viewControllers[0].children[0] as! MainViewController
            mainViewController.itemId = Const.item_id__nav_posts
            // 全てのモーダルを閉じる // 参考：Lesson8.8.3
            //UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil) // 動かない
            
            //self.dismiss(animated: false, completion: nil) // 動かない
            
            //let viewController = preNC.viewControllers[0] as! ViewController // エラー // Application tried to present modally an active controller
            //self.present(viewController, animated: true, completion: nil)
            
            // 参考：https://stackoverflow.com/questions/48336697/swift-tried-to-present-modally-an-active-controller-current-view-controller-ev/48336914
            //let storyboard = UIStoryboard(storyboard: .Main) // 参考：https://qiita.com/mitz/items/91a47eee524a6789ab74
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // 参考：http://crossbridge-lab.hatenablog.com/entry/2015/12/14/073000
            let navigation = storyboard.instantiateInitialViewController() as! UINavigationController
            //print(navigation.viewControllers) // test // [<TwitterClone.ViewController: 0x7f9dc874a290>]
            //print(navigation.viewControllers[0]) // test // <TwitterClone.ViewController: 0x7f9dc874a290>
            self.present(navigation, animated: true, completion: nil)
            
            print("test item_id__nav_posts")
        } else if indexPath.row == 1 { // "search_posts"
            //let preNC = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController // test // 参考：https://qiita.com/wadaaaan/items/acc8967c836d616e3b0b
            //let mainViewController = preNC.viewControllers[0].children[0] as! MainViewController
            //mainViewController.itemId = Const.item_id__nav_search_posts

            // 参考：https://stackoverflow.com/questions/48336697/swift-tried-to-present-modally-an-active-controller-current-view-controller-ev/48336914
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // 参考：http://crossbridge-lab.hatenablog.com/entry/2015/12/14/073000
            let navigation = storyboard.instantiateInitialViewController() as! UINavigationController
            //let mainViewController = navigation.viewControllers[0].children[0] as! MainViewController // エラー
            //mainViewController.itemId = Const.item_id__nav_search_posts
            //print(navigation.viewControllers[0]) // test // <TwitterClone.ViewController: 0x7ffb18654430>
            //print(navigation.viewControllers[0].children) // test // []
            //print(navigation.topViewController) // test // Optional(<TwitterClone.ViewController: 0x7fcd10720530>)
            let viewController = navigation.topViewController as! ViewController
            viewController.itemId = Const.item_id__nav_search_posts
            self.present(navigation, animated: true, completion: nil)

            print("test item_id__nav_search_posts")
            
            
        } else if indexPath.row == 2 { // "search_users"
            
        } else if indexPath.row == 3 { // "followings_list"
            
        } else if indexPath.row == 4 { // "followers_list"
            
        } else if indexPath.row == 5 { // "favorites_list"
            
        } else if indexPath.row == 6 { // "my_posts"
            
        } else if indexPath.row == 7 { // "policy"
//            let preNC = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController // test // 参考：https://qiita.com/wadaaaan/items/acc8967c836d616e3b0b
//            let mainViewController = preNC.viewControllers[0].children[0] as! MainViewController
//            mainViewController.itemId = Const.item_id__nav_policy
//
//            print("test item_id__nav_policy")
        }
    }
}

extension SidemenuViewController: UIGestureRecognizerDelegate {
    internal func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: tableView)
        if tableView.indexPathForRow(at: location) != nil {
            return false
        }
        return true
    }
}
