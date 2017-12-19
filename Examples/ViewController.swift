//
//  ViewController.swift
//  Examples
//
//  Created by Lei Wang on 2017/12/19.
//  Copyright © 2017年 Lei Wang. All rights reserved.
//

import UIKit
import Section

class ViewController: UIViewController {

    private let tableView = UITableView.init(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Indexs"
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sn.register(viewType: TableViewCell.self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension ViewController: Sectionable, UITableViewDelegate, UITableViewDataSource {
    var viewModels: [ViewModel] {
        return [SectionModel.init()]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sn.numberOfSections(in: tableView)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sn.tableView(tableView, numberOfRowsInSection: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sn.tableView(tableView, cellForRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sn.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = sn.viewModel(at: indexPath) as? Model {
            let vc = model.viewControllerType.init()
            vc.title = model.title
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}



private struct  SectionModel: ViewModel, Sectionable {
    var viewModels: [ViewModel] {
        return [Model.init(title: "Collection View Controller",
                           viewControllerType: CollectionViewController.self)]
    }
}

private struct Model: ViewModel {
    let title: String
    let viewControllerType: UIViewController.Type
    
    var viewSize: ViewSize {
        return ViewSize.schemeSize({ (containerSize) -> CGSize in
            return CGSize(width: containerSize.width, height: 44)
        })
    }
    var viewType: ViewType.Type {
        return TableViewCell.self
    }
}

private class TableViewCell: UITableViewCell, ViewType {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func didSet(viewModel: ViewModel) {
        textLabel?.text = (viewModel as? Model)?.title
    }
}

