//
//  SearchViewController.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    var infoRepo = InformationRepository()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchInfo()
//        deleteInfo()
    }
    
    func searchInfo() {
        let searchParam = SearchParam(userID: 2)
        infoRepo.searchInfo(data: searchParam, searchSuccess: { infoList in
            print(infoList)
        }, searchError: { searchError in
            print(searchError)
        })
    }
    
    func deleteInfo() {
        let deleteParam = DeleteParam(id: 12, userID: 2)
        infoRepo.deleteInfo(data: deleteParam, deleteSuccess: { succesData in
            print(succesData)
        }, deleteError: { resultError in
            print(resultError)
        })
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
