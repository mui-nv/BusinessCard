//
//  EditViewController.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class EditViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var textName1: UITextField!
    @IBOutlet weak var textName2: UITextField!
    @IBOutlet weak var textCompany: UITextField!
    @IBOutlet weak var textDepartment: UITextField!
    
    @IBOutlet weak var textPostal: UITextField!
    @IBOutlet weak var textAddress1: UITextField!
    @IBOutlet weak var textAddress2: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func deleteAction(_ sender: Any) {
        deleteInfo()
    }
    
    @IBAction func actionUpdate(_ sender: Any) {
        updateInfo()
    }
    
    var didSelectedInfo: Information?
    let infoRepo: InformationRepository = InformationRepository()
    var latitudeValue: Double?
    var longitudeValue: Double?
    var disposeBag = DisposeBag()
    
    var address1Value: String?
    var address2Value: String?
    var listAnnotation:[MKAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        textAddress1.rx.controlEvent([UIControl.Event.editingDidBegin])
            .asDriver()
            .drive(onNext: { value in
                self.address1Value = self.textAddress1.text
            })
            .disposed(by: disposeBag)
        textAddress2.rx.controlEvent([UIControl.Event.editingDidBegin])
            .asDriver()
            .drive(onNext: { value in
                self.address2Value = self.textAddress2.text
            })
            .disposed(by: disposeBag)
        
        textAddress1.rx.controlEvent([UIControl.Event.editingDidEnd])
            .asDriver()
            .drive(onNext: { value in
                self.checkMapPreview()
            })
            .disposed(by: disposeBag)
        
        textAddress2.rx.controlEvent([UIControl.Event.editingDidEnd])
            .asDriver()
            .drive(onNext: {
                self.checkMapPreview()
            })
            .disposed(by: disposeBag)
        
        mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setInfo(info: didSelectedInfo)
    }
    
    func deleteInfo() {
        guard didSelectedInfo != nil else {
            showErrorDialog(messgae: "you did not select Information")
            return
        }
        
        let deleteParam = DeleteParam(id: (didSelectedInfo?.id)!, userID: 0)
        infoRepo.deleteInfo(data: deleteParam)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { value in
                self.showSuccessDialog(messgae: "Delete User Succeed!")
            }, onError: { _ in
                self.showErrorDialog(messgae: "an error has occured!")
            })
            .disposed(by: disposeBag)
    }
    
    func checkMapPreview() {
        guard let address1 = textAddress1.text, let address2 = textAddress2.text, address1 != "", address2 != "" else {
            return
        }
        
        if address1 != address1Value || address2 != address2Value {
            address1Value = address1
            address2Value = address2
            previewMap(addressForLocation: address1 + address2)
        }
    }
    
    func updateInfo() {
        guard didSelectedInfo != nil else {
            showErrorDialog(messgae: "you did not select Information")
            return
        }
        
        guard let name1 = textName1.text, let name2 = textName2.text, let company = textCompany.text, let department = textDepartment.text, let address1 = textAddress1.text, let address2 = textAddress2.text, let postal = textPostal.text else {
            showErrorDialog(messgae: "please insert all data!")
            return
        }
        
        guard name1 != "", name2 != "", company != "", department != "", address1 != "", address2 != "", postal != "", latitudeValue != nil, longitudeValue != nil else {
            showErrorDialog(messgae: "please insert all data!")
            return
        }
        
        let latValue = listAnnotation.first?.coordinate.latitude
        let longValue = listAnnotation.first?.coordinate.longitude
        
        print(listAnnotation.count)
        
        let infoParam = CreateInfoParam(id: didSelectedInfo?.id, userID: 0, name1: textName1.text!, name2: textName2.text!, company: textCompany.text!, department: textDepartment.text!, postal: textPostal.text!, address1: textAddress1.text!, address2: textAddress2.text!, latitude: latValue!, longitude: longValue!, image: "ns34")
        infoRepo.updateInfo(data: infoParam).observeOn(MainScheduler.instance)
            .subscribe(onNext: { value in
                self.resetSelectedInfo()
                self.showSuccessDialog(messgae: "Update User Succeed!")
            }, onError: { _ in
                self.showErrorDialog(messgae: "An error has occured!")
            })
            .disposed(by: disposeBag)
    }
    
    func resetSelectedInfo() {
        didSelectedInfo?.name1 = textName1.text!
        didSelectedInfo?.name2 = textName2.text!
        didSelectedInfo?.company = textCompany.text!
        didSelectedInfo?.department = textDepartment.text!
        didSelectedInfo?.postal = textPostal.text!
        didSelectedInfo?.address1 = textAddress1.text!
        didSelectedInfo?.address2 = textAddress2.text!
    }
    
    func setInfo(info: Information?) {
        guard (info != nil) else {
            return
        }
        
        textName1.text = info!.name1
        textName2.text = info!.name2
        textCompany.text = info!.company
        textDepartment.text = info!.department
        textAddress1.text = info!.address1
        textAddress2.text = info!.address2
        textPostal.text = info!.postal
        
        didSelectedInfo = info
        
        latitudeValue = info!.latitude
        longitudeValue = info!.longitude
        
        address1Value = info!.address1
        address2Value = info!.address2
        previewMap()
    }
    
    func previewMap(addressForLocation: String) {
        print(addressForLocation)
        // 中心座標（横浜中華街）
        var center = CLLocationCoordinate2D(latitude: 31.4424225, longitude: 139.6465645)
        
        // 入力された住所を元に取材地の座標を登録
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressForLocation) { (placeMarks, error) in
            guard placeMarks != nil else {
                return
            }
            
            for placeMark in placeMarks! {
                // 緯度
                self.latitudeValue = placeMark.location?.coordinate.latitude
                //                print("lat:" + lat!.description)
                // 経度
                self.longitudeValue = placeMark.location?.coordinate.longitude
                //                print("long:" + long!.description)
                
                center = CLLocationCoordinate2D(latitude: self.latitudeValue!, longitude: self.longitudeValue!)
                
                // 表示範囲（約222m×222mの範囲）
                let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
                // 地図の表示領域を決める
                let region = MKCoordinateRegion(center: center, span: span)
                self.mapView.setRegion(region, animated:true)
                
                self.addPin(center: center)
            }
        }
        
        // 表示範囲（約222m×222mの範囲）
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        // 地図の表示領域を決める
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated:true)
        // アノテーションを作る
        addPin(center: center)
    }
    
    func addPin(center: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate  = center
        annotation.title = "ここです！"
        annotation.subtitle = "私、待ってます"
        // アノテーションを表示する
        removePin()
        listAnnotation.append(annotation)
        mapView.addAnnotation(annotation)
    }
    
    func previewMap() {
        // 中心座標（横浜中華街）
        let center = CLLocationCoordinate2D(latitude: self.latitudeValue!, longitude: self.longitudeValue!)
        
        // 表示範囲（約222m×222mの範囲）
        var span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        // 地図の表示領域を決める
        var region = MKCoordinateRegion(center: center, span: span)
        self.mapView.setRegion(region, animated:true)
        
        // 表示範囲（約222m×222mの範囲）
        span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        // 地図の表示領域を決める
        region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated:true)
        // アノテーションを作る
        addPin(center: center)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinView = MKPinAnnotationView()
        pinView.animatesDrop = true
        pinView.isDraggable = true
        pinView.pinTintColor = UIColor.systemPink
        pinView.canShowCallout = true
        
        return pinView
    }
    
    func removePin() {
        mapView.removeAnnotations(listAnnotation)
        listAnnotation.removeAll()
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
