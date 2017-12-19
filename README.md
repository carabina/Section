# Section
It's help you very easy to build an extensible list.

### Usage
```swift
extension AwesomeViewController: Sectionable, UITableViewDelegate, UITableViewDataSource {
    var viewModels: [ViewModel] {
        return [awesomeModels]
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
        if let awesomeModel = sn.viewModel(at: indexPath) as? AwesomeModel {
        	// Do someting here
		}
    }
}


private struct AwesomeModel: ViewModel {
    let title: String
    
    var viewSize: ViewSize {
        return ViewSize.schemeSize({ (containerSize) -> CGSize in
            return CGSize(width: containerSize.width, height: 44)
        })
    }
    var viewType: ViewType.Type {
        return AwesomeCell.self
    }
}

private class AwesomeCell: UITableViewCell, ViewType {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)   
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func didSet(viewModel: ViewModel) {
        textLabel?.text = (viewModel as? AwesomeModel)?.title
    }
}

```