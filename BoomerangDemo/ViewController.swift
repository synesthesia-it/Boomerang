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

    var reloadAction: Action<ResultRangeType?, ModelStructure, NSError> = Action {_ in return SignalProducer(value:ModelStructure.empty)}
    var models:MutableProperty<ModelStructure> = MutableProperty(ModelStructure.empty)
    var viewModels:MutableProperty = MutableProperty([IndexPath:ItemViewModelType]())
    var isLoading:MutableProperty<Bool> = MutableProperty(false)
    var resultsCount:MutableProperty<Int> = MutableProperty(0)
    var newDataAvailable:MutableProperty<ResultRangeType?> = MutableProperty(nil)
    init() {}
    
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



class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, RouterSource  {
    @IBOutlet weak var collectionView:UICollectionView?
    @IBOutlet weak var tableView: UITableView!
    var viewModel:TestViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.viewModel == nil) {
            self.viewModel = ViewModelFactory.testViewModel()
        }
        self.collectionView?.delegate = self
        self.collectionView?.bindViewModel(self.viewModel)
        
        self.viewModel?.reload()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel?.reload()
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Router.from(self, viewModel: self.viewModel!.select(selection: indexPath))
        
    }
}



extension Router {
    static func from<Source>(_ source:Source, viewModel:ViewModelType) where Source : ViewController  {
        guard let vc = source.storyboard?.instantiateViewController(withIdentifier: "testViewController") as? ViewController else {return}
        let vm = ViewModelFactory.anotherTestViewModel()
        vc.viewModel = vm as? TestViewModel
        source.navigationController?.pushViewController(vc, animated: true)
    }
    static func from<Source>(_ source:Source, viewModel:ViewModelType) where Source : UINavigationController  {
        guard let vc = source.storyboard?.instantiateViewController(withIdentifier: "testViewController") as? ViewController else {return}
        let vm = ViewModelFactory.anotherTestViewModel()
        vc.viewModel = vm as? TestViewModel
        source.present(vc, animated: true, completion: nil)
    }
    static func backTo<Source>(_ source:Source, destination:RouterDestination? = nil) where Source : ViewController  {
        _ = source.navigationController?.popViewController(animated: true)
    }
}

struct Router : RouterType {
    static func from<Source>(_ source:Source, viewModel:ViewModelType) {
        
    }
    static func backTo<Source>(_ source:Source, destination:RouterDestination? = nil) {
        
    }
}



