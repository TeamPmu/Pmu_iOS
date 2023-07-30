//
//  MusicRecommendViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/30.
//

import UIKit

class MusicRecommendViewController: UIViewController {

    
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var musicAlbumImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dismissBtn.layer.cornerRadius = 24
        dismissBtn.clipsToBounds = true
        
        heartBtn.layer.cornerRadius = 24
        heartBtn.clipsToBounds = true
        
        musicAlbumImg.layer.cornerRadius = 12
        musicAlbumImg.clipsToBounds = true
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
