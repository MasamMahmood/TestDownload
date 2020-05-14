//
//  FooterView.swift
//  TestDownload
//
//  Created by Masam on 20/01/20.
//  Copyright © 2020 Masam Mahmood. All rights reserved.
//

import Foundation
import UIKit

class FooterView: UIView {
    
    var model: ALDownloadInfo! {
        didSet {
            parseDownloadInfo(info: model)
        }
    }
    
    @IBOutlet weak var projName: UILabel!
    @IBOutlet weak var footerProgress: UIProgressView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var downloadLbl: UILabel!
    @IBOutlet weak var tipView: UIView!
    
    func parseDownloadInfo(info: ALDownloadInfo) {
        weak var weakself = self
        info.downloadProgress({ (progress) in
            
            print(progress)
            let completed: Float = Float(progress.completedUnitCount)
            let total: Float = Float(progress.totalUnitCount)
            weakself?.footerProgress.progress = (completed/total)
            self.downloadLbl.text = String(progress.fractionCompleted * 100)
        })
        //         info.stateChangeBlock = { state in
        //             weakself?.parseDownloadState(state: state)
        //         }
        //         parseDownloadState(state: info.state)
    }
    
    //     func parseDownloadState(state: ALDownloadState?)  {
    //         if state == ALDownloadState.Download {
    //             downloadBtn.setImage(UIImage(named: "pause"), for: .normal)
    //         }else if state == ALDownloadState.Resume || state == ALDownloadState.None  {
    //             downloadBtn.setImage(UIImage(named: "download"), for: .normal)
    //         }else if state == ALDownloadState.Wait  {
    //             downloadBtn.setImage(UIImage(named: "clock"), for: .normal)
    //         }else if state == ALDownloadState.Completed  {
    //             downloadBtn.setImage(UIImage(named: "check"), for: .normal)
    //         }
    //     }
}
