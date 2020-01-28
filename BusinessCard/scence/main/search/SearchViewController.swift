//
//  SearchViewController.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchTV: UITableView!
    @IBOutlet weak var filterValueTF: UITextField!
    @IBOutlet weak var filterSegment: UISegmentedControl!
    @IBAction func searchAction(_ sender: Any) {
        searchInfo()
    }
    
    var listInfo: [Information] = []
    var infoRepo = InformationRepository()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTV.delegate = self
        searchTV.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchInfo()
    }
    
    func searchInfo() {
        let searchParam = SearchParam(userID: 2)
        infoRepo.searchInfo(data: searchParam)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { infoList in
                self.listInfo.removeAll()
                
                var info1: [Information]? = []
                if self.filterValueTF.text != nil && self.filterValueTF.text! != "" {
                    switch self.filterSegment.selectedSegmentIndex {
                    case 0:
                        info1 = infoList.filter {
                            $0.name1 == self.filterValueTF.text!
                        }
                    case 1:
                        info1 = infoList.filter {
                            $0.company == self.filterValueTF.text!
                        }
                    case 2:
                        info1 = infoList.filter {
                            $0.department == self.filterValueTF.text!
                        }
                    case 3:
                        info1 = infoList.filter {
                            $0.postal == self.filterValueTF.text!
                        }
                    case 4:
                        info1 = infoList.filter {
                            $0.address1 == self.filterValueTF.text!
                        }
                    default:
                        break
                    }
                } else {
                    info1 = infoList
                }
                
                for info in info1! {
//                    if info.image != nil && info.image != "" {
//                        self.getImage(url: info.image!, Success: { imgFile in
//                            info.imageValue = imgFile
//                        })
//                    }
                    
                    self.listInfo.append(info)
                }
                
                self.getImage()
                self.searchTV.reloadData()
            }, onError: { _ in
                self.showErrorDialog(messgae: "An Error has Occured!")
            })
            .disposed(by: disposeBag)
    }
    
    func getImage() {
        for info in listInfo {
            guard info.image != nil && info.image != "" else {
                return
            }
            
            let getImage = ImageParam(image: info.image!)
            infoRepo.getImage(data: getImage)
                .map {(data) -> String in
                    data.ImageFile
            }.subscribe(onNext: { value in
                info.imageValue = value
                self.searchTV.reloadData()
            })
                .disposed(by: disposeBag)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listInfo.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
            as! SearchTableViewCell
        cell.setView(info: listInfo[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (self.tabBarController?.viewControllers![2] as! EditViewController).didSelectedInfo = listInfo[indexPath.row]
        self.tabBarController?.selectedIndex = 2
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
