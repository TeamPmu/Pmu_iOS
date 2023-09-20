//
//  ExMusicList.swift
//  Pmu
//
//  Created by seohuibaek on 2023/09/07.
//

import Foundation
import UIKit

struct AroundMusic: Codable{
    var name: String
    var coverImg: String
    var genre: String
    var musicPre: String
    var musicPull: String
    var replyCnt: Int
    var archiveId: Int
    var artist: String
    var pickCnt: Int
}
