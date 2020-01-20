//
//  DownloadTaskInfo.swift
//  TestDownload
//
//  Created by Masam Mahmood on 20.01.2020.
//  Copyright © 2020 Masam Mahmood. All rights reserved.
//

import Foundation

class DownloadTaskInfo: NSObject {
    var name: String?
    var url: String?
    var isDownload: Bool = false
    var progress: Float = 0.0
    
    var downloadTask: URLSessionDownloadTask?
    var downloadTaskId: Int?
    var downloadedData: NSData?
    
}
