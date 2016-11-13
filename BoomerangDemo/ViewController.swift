//
//  ViewController.swift
//  BoomerangDemo
//
//  Created by Stefano Mondino on 03/11/16.
//
//

import UIKit
import Boomerang
import ReactiveSwift


struct HeaderIdentifier : ListIdentifier {
    var name: String
    var type: String?
}

struct ViewModelFactory {
    static func testViewModel() -> TestViewModel {
        var a:[ModelStructure] = []
        for i in 0...100 {
            a = a + [ModelStructure([
                Item(string:"TEST*10 \(i*10)"),
                Item(string:"TEST+1 \(i+1)")
                ],
                                    sectionModel:Item(string:"Title \(i)"))]
        }
        let full = ModelStructure(children:a)
        return TestViewModel(dataProducer: SignalProducer(value:full))
    }
}

extension ViewModelFactory {
    static func anotherTestViewModel() -> ViewModelType {
        var a:[ModelStructure] = []
        for i in 0...100 {
            a = a + [ModelStructure([
                Item(string:"TEST+1 \(i+1)")
                ],
                                    sectionModel:Item(string:"Title \(i)"))]
        }
        let full = ModelStructure(children:a)
        return TestViewModel(dataProducer: SignalProducer(value:full))
    }
}


final class TestViewModel:ListViewModelTypeHeaderable {
    
    var dataHolder: ListDataHolderType = ListDataHolder.empty
    
    func itemViewModel(_ model: ModelType) -> ItemViewModelType? {
        return TestItemViewModel(model: model as! Item)
    }
    func listIdentifiers() -> [ListIdentifier] {
        return ["TestCollectionViewCell"]
    }
    func headerIdentifiers() -> [ListIdentifier] {
        return [HeaderIdentifier(name:"TestCollectionViewCell", type:UICollectionElementKindSectionHeader)]
    }
    func select(selection: SelectionType) -> ViewModelType {
        return  ViewModelFactory.anotherTestViewModel()
    }
}


struct Item : ModelType {
    public var title: String? {get {return self.string}}
    
    var string:String
}



class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, RouterDestination, ViewModelBindable  {
    @IBOutlet weak var collectionView:UICollectionView?
    @IBOutlet weak var tableView: UITableView!
    var viewModel:TestViewModel?
    var disposable: CompositeDisposable?
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.viewModel == nil) {
            self.bindViewModel(ViewModelFactory.anotherTestViewModel())
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel?.reload()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Router.from(self, viewModel: self.viewModel!.select(selection: indexPath)).execute()
        
    }
    
    func bindViewModel(_ viewModel: ViewModelType?) {
        
        guard let vm = viewModel as? TestViewModel else {
            return
        }
        self.viewModel = vm
        self.collectionView?.delegate = self
        self.collectionView?.bindViewModel(self.viewModel)
        self.viewModel?.reload()
        
    }
}

struct Router : RouterType {

}

extension RouterType {
    static func from<Source>(_ source:Source, viewModel:ViewModelType) -> RouterAction where Source : ViewController {
        
        let vc = self.viewController(storyboardId: "Main", storyboardIdentifier: "testViewController") as! ViewController
        vc.bindViewModelAfterLoad(viewModel)
        return UIViewControllerRouterAction.push(source:source, destination:vc)    
    }

    static func viewController(storyboardId:String, storyboardIdentifier:String) -> RouterSource {
        return UIStoryboard(name: storyboardId, bundle: nil).instantiateViewController(withIdentifier: storyboardIdentifier)
    }

    
    static func backTo<Source>(_ source:Source, destination:RouterDestination?) -> RouterAction where Source : ViewController  {
        return UIViewControllerRouterAction.pop(source:source)
    }
}





