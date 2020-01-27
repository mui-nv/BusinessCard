//
//  SearchViewController.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchTV: UITableView!
    @IBOutlet weak var filterValueTF: UITextField!
    @IBOutlet weak var filterSegment: UISegmentedControl!
    @IBAction func searchAction(_ sender: Any) {
        searchInfo()
    }
    
    var listInfo: [Information] = []
    var infoRepo = InformationRepository()
    
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
        infoRepo.searchInfo(data: searchParam, searchSuccess: { infoList in
            listInfo.removeAll()
            
            var info1: [Information]? = []
            if filterValueTF.text != nil && filterValueTF.text! != "" {
                switch filterSegment.selectedSegmentIndex {
                case 0:
                    info1 = infoList?.filter {
                        $0.name1 == filterValueTF.text!
                    }
                case 1:
                    info1 = infoList?.filter {
                        $0.company == filterValueTF.text!
                    }
                case 2:
                    info1 = infoList?.filter {
                        $0.department == filterValueTF.text!
                    }
                case 3:
                    info1 = infoList?.filter {
                        $0.postal == filterValueTF.text!
                    }
                case 4:
                    info1 = infoList?.filter {
                        $0.address1 == filterValueTF.text!
                    }
                default:
                    break
                }
            } else {
                info1 = infoList
            }
            
            for info in info1! {
                if info.image != nil && info.image != "" {
                    getImage(url: info.image!, onSuccess: { imgFile in
                        info.imageValue = imgFile
                    })
                }
                
                listInfo.append(info)
            }
            
            searchTV.reloadData()
        }, searchError: { searchError in
            showErrorDialog(messgae: searchError)
        })
    }
    
    func getImage(url: String, onSuccess: (String?) -> ()) {
        let getImage = ImageParam(image: url)
        infoRepo.getImage(data: getImage, searchSuccess: { image in
            onSuccess(image?.ImageFile)
        }, searchError: { errorss in
            showErrorDialog(messgae: errorss)
        })
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
