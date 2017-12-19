//
//  Section.swift
//  Section
//
//  Created by Lei Wang on 2017/12/19.
//  Copyright © 2017年 Lei Wang. All rights reserved.
//

import Foundation


public protocol Sectionable {
    var viewModels: [ViewModel] { get }
}

public protocol NoneReuseSectionale: Sectionable {}

public protocol ViewModel {
    var viewSize: ViewSize { get }
    var viewType: ViewType.Type { get }
}

public enum ViewSize {
    case pureSize(CGSize)
    case schemeSize((CGSize) -> CGSize)
    case none
}

public protocol ViewType: class {
    func didSet(viewModel: ViewModel)
}

public struct SectionableProxy<Base> {
    public let base: Base
    init(base: Base) {
        self.base = base
    }
}

// MARK: - Extensions
extension ViewType {
    public static var identifier: String {
        return String.init(describing: self)
    }
}

extension Sectionable {
    public var sn: SectionableProxy<Self> {
        return SectionableProxy.init(base: self)
    }
}

extension SectionableProxy where Base: Sectionable & UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(in: section)
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier:
            cellViewModel.viewType.identifier, for: indexPath)
        (cell as? ViewType)?.didSet(viewModel: cellViewModel)
        return cell
    }
}

extension SectionableProxy where Base: Sectionable & UITableViewDelegate {
    public func tableView(_ tableView: UITableView,
                          heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel(at: indexPath).viewSize {
        case .none:
            fatalError("not support non tyoe size")
        case .pureSize(let size):
            return size.height
        case .schemeSize(let scheme):
            return scheme(tableView.bounds.size).height
        }
    }
}

extension SectionableProxy where Base: NoneReuseSectionale & UITableViewDataSource {
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier:
            cellViewModel.viewType.identifier + "\(indexPath.section) % \(indexPath.row)",
            for: indexPath)
        (cell as? ViewType)?.didSet(viewModel: cellViewModel)
        return cell
    }
}



extension SectionableProxy where Base: Sectionable & UICollectionViewDataSource {
    public func numberOfSections(in: UICollectionView) -> Int {
        return numberOfSections
    }
    public func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return numberOfRows(in: section)
    }
    public func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = viewModel(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            cellViewModel.viewType.identifier, for: indexPath)
        (cell as? ViewType)?.didSet(viewModel: cellViewModel)
        return cell
    }
}
extension SectionableProxy where Base: NoneReuseSectionale & UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = viewModel(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            cellViewModel.viewType.identifier + "\(indexPath.section) % \(indexPath.item)"
            , for: indexPath)
        (cell as? ViewType)?.didSet(viewModel: cellViewModel)
        return cell
    }
}

extension SectionableProxy where Base: Sectionable & UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel(at: indexPath).viewSize {
        case .none:
            fatalError("not support non tyoe size")
        case .pureSize(let size):
            return size
        case .schemeSize(let scheme):
            return scheme(collectionView.bounds.size)
        }
    }
}

extension SectionableProxy where Base: Sectionable {
    public func viewModel(at indexPath: IndexPath) -> ViewModel {
        if let sectionList = base.viewModels as? [Sectionable] {
            return sectionList[indexPath.section].viewModels[indexPath.row]
        }
        return base.viewModels[indexPath.row]
    }
    
    var numberOfSections: Int {
        return (base.viewModels is [Sectionable]) ? base.viewModels.count : 1
    }
    func numberOfRows(in section: Int) -> Int {
        if let sectionList = base.viewModels as? [Sectionable] {
            return sectionList[section].viewModels.count
        }
        return base.viewModels.count
    }
}


extension UITableView {
    public var sn: SectionableProxy<UITableView> {
        return SectionableProxy.init(base: self)
    }
}
extension SectionableProxy where Base: UITableView {
    public func register(viewType: ViewType.Type) {
        base.register(viewType, forCellReuseIdentifier: viewType.identifier)
    }
}
extension UICollectionView {
    public var sn: SectionableProxy<UICollectionView> {
        return SectionableProxy.init(base: self)
    }
}
extension SectionableProxy where Base: UICollectionView {
    public func register(viewType: ViewType.Type) {
        base.register(viewType, forCellWithReuseIdentifier: viewType.identifier)
    }
}


extension ViewModel where Self: Sectionable {
    public var viewSize: ViewSize {
        return .none
    }
    public var viewType: ViewType.Type {
        return NoneViewType.self
    }
}

// MARK: - Private
private class NoneViewType: ViewType {
    func didSet(viewModel: ViewModel) {
        
    }
}

