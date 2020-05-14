//
//  ViewController.swift
//  TestDownload
//
//  Created by Masam on 20.01.2020.
//  Copyright © 2020 Masam. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
      
    
    @IBOutlet weak var tableView: UITableView!
    var Appdata : [Appointment]?
    var AppDetailData : AppointmentDetail?
    var selectedIndex : Int! = -1
    var downloadSpeed: Double = 0.0
    
    
    lazy var startBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("start", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.black
        return btn
    }()
    
    
    var downloadInfos = [ALDownloadInfo]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(startBtn)
        startBtn.frame = CGRect(x: 50, y: 30, width: 100, height: 30)
        startBtn.addTarget(self, action: #selector(didStartBtn), for: .touchUpInside)
        
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib.init(nibName: "DownloadEntryViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "DownloadEntryViewCell")
        pullData()

    }
    
    
    @objc
    func didStartBtn() {
        print("didStartBtn")
        downloadInfos.forEach { (info) in
            print("download")
            info.download()
        }
        
    }
    
    // MARK: - Data Services. 
    func pullData(){
        
        if let url = Bundle.main.url(forResource: "Appointment", withExtension: "json") {
            do {
                
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                self.Appdata = jsonData.appointments
                
                for i in Appdata! {
                    self.detailData(AppId: i.id ?? 0)
                }
                self.tableView.reloadData()
            } catch {
                print("error:\(error)")
            }
        }
        
    }
    
    func detailData(AppId: Int){
        
        if let url = Bundle.main.url(forResource: "AppointmentDetail", withExtension: "json") {
            do {
                
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(AppointmentDetail.self, from: data)
                self.AppDetailData = jsonData
                
                for param in AppDetailData?.sectionList ?? [] {
                    for item in param.items! {
                        
                        if item.actionType == 2 {
//                            let filename = item.actionUrl ?? ""
                            let url = item.actionUrl ?? ""
                            let filename = item.textField ?? ""
                            
                            downloadInfos.append(ALDownloadInfo(url: url, name: filename))
                            

                        }
                    }
                }

            } catch {
                print("error:\(error)")
            }
        }
        
    }
    

    // MARK: - TableView Delegates
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == selectedIndex{
            selectedIndex = -1
            
        }else{
            selectedIndex = indexPath.row
        }
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedIndex
        {
            return UITableView.automaticDimension
        }else{
            return 71
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2 //Appdata?.count  ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadEntryViewCell", for: indexPath) as! DownloadEntryViewCell
        let dic = Appdata?[indexPath.row]
        var stackHeight:CGFloat = 0.0
        cell.fileNameLabel.text = dic?.date
        

        for i in Appdata ?? [] {
            let child_view = Bundle.main.loadNibNamed("FooterView", owner: self, options: nil)?.first as! FooterView
            for j in downloadInfos {
            child_view.projName.text = i.projectName
            child_view.model = j
            child_view.model.stateChangeBlock = { [weak self] state in
                guard let weakself = self else {
                    return
                }
                print("stateChangeBlock == \(state)")
                if state == .Completed {
                    
                    
                    child_view.tipView.backgroundColor = child_view.footerProgress.tintColor
                     print("stateChangeBlock == \(state)")
                    let completeInfos = weakself.downloadInfos.filter{$0.state == ALDownloadState.Completed}
                    print( Float(completeInfos.count/weakself.downloadInfos.count))
                    cell.individualProgress.progress = Float(completeInfos.count)/Float(weakself.downloadInfos.count)
                    cell.progressLabel.text = "\( Float(completeInfos.count)/Float(weakself.downloadInfos.count)*100)"
                    cell.downloadURLLabel.text = "Downloading(\(Float(completeInfos.count)/Float(weakself.downloadInfos.count)))"
                    
                }
               
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            child_view.mainView.addGestureRecognizer(tap)
                child_view.mainView.isUserInteractionEnabled = true
            cell.stackViewFooter.addArrangedSubview(child_view)
            stackHeight = stackHeight + 60.0
            }
        }
        cell.stackViewFooter.heightAnchor.constraint(equalToConstant: stackHeight).isActive = true
        return cell
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("Tap working")
    }
    
}

