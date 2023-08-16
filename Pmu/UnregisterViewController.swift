//
//  UnregisterViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/08/05.
//

import UIKit

class UnregisterViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var unregisterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        /*if let UnregisterVC = storyboard.instantiateViewController(withIdentifier: "MyPageVC") as? MyPageViewController {
            // 윈도우 씬을 찾아서 루트 뷰 컨트롤러 변경
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first {
                window.rootViewController = UnregisterVC
            }
        }*/
        
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1 // 두 번째 탭 선택
            if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                navigationController.popToRootViewController(animated: true) // 선택된 탭의 루트 뷰 컨트롤러로 이동
            }
        }
    }
    
    @IBAction func unregisterBtnTapped(_ sender: UIButton) {
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
