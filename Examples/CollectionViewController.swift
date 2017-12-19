//
//  CollectionViewController.swift
//  Examples
//
//  Created by Lei Wang on 2017/12/19.
//  Copyright © 2017年 Lei Wang. All rights reserved.
//

import UIKit
import Section
class CollectionViewController: UIViewController {

    private let collcetionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collcetionView)
        collcetionView.delegate = self
        collcetionView.dataSource = self
        collcetionView.backgroundColor = .white
        collcetionView.sn.register(viewType: CollectionCell.self)
        let flowlayout = collcetionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowlayout?.minimumInteritemSpacing = 10
        flowlayout?.minimumLineSpacing = 10
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collcetionView.frame = view.bounds
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CollectionViewController: Sectionable, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var viewModels: [ViewModel] {
        let unicodes = Array(65...90).flatMap(Unicode.Scalar.init)
        let titles = unicodes.map(Character.init).map(String.init)
        return titles.map(Model.init(title:))
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sn.numberOfSections(in: collectionView)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sn.collectionView(collectionView, numberOfItemsInSection: section)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return sn.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sn.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }
}

private struct Model: ViewModel {
    let title: String
    
    var viewSize: ViewSize {
        let cloumn: Int = 5
        return ViewSize.schemeSize({ (containerSize) -> CGSize in
            let width = floor((containerSize.width - (CGFloat(cloumn) - 1) * 10) / CGFloat(cloumn))
            return CGSize(width: width, height: width)
        })
    }
    var viewType: ViewType.Type {
        return CollectionCell.self
    }
}
private class CollectionCell: UICollectionViewCell, ViewType {
    private let textLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    private func initSetup() {
        textLabel.textAlignment = .center
        contentView.addSubview(textLabel)

    }
    
    func didSet(viewModel: ViewModel) {
        let r = CGFloat(arc4random() % 255) / 255
        let g = CGFloat(arc4random() % 255) / 255
        let b = CGFloat(arc4random() % 255) / 255
        contentView.backgroundColor = UIColor.init(red: r, green: g, blue: b, alpha: 1)
        textLabel.text = (viewModel as? Model)?.title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = contentView.bounds
    }
}

