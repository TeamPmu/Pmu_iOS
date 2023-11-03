//
//  LikedMusicData.swift
//  Pmu
//
//  Created by seohuibaek on 2023/10/30.
//

import Foundation
import UIKit

class MusicData {
    var images: [UIImage] = []
    var titles: [String] = []
    var artists: [String] = []
    var musicURLs: [String] = []
    
    static let shared = MusicData()
    
    private init() {}
}
