//
//  UIPicker.swift
//  Boomerang
//
//  Created by Stefano Mondino on 28/11/16.
//
//

import UIKit
import RxCocoa
import RxSwift


private struct AssociatedKeys {
    static var viewModel = "viewModel"
    static var disposeBag = "disposeBag"
    static var pickerViewDataSource = "pickerViewDataSource"
    
}

private class ViewModelPickerViewDataSource : NSObject, PickerViewCombinedDelegate {
    weak var viewModel: ListViewModelType?
    init (viewModel: ListViewModelType) {
        super.init()
        self.viewModel = viewModel
        
    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        let count =  self.viewModel?.dataHolder.modelStructure.value.children?.count ?? 1
        return count
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count =  self.viewModel?.dataHolder.modelStructure.value.children?[component].models?.count
        count =  count ?? self.viewModel?.dataHolder.modelStructure.value.models?.count
        return count ?? 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let viewModel:ItemViewModelType? = self.viewModel?.viewModel(atIndex:IndexPath(row: row, section: component))
        return viewModel?.itemTitle ?? ""
    }
}
public protocol PickerViewCombinedDelegate : UIPickerViewDelegate, UIPickerViewDataSource{}
public extension ListViewModelType  {
    
    var pickerViewDataSource:PickerViewCombinedDelegate? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.pickerViewDataSource) as? PickerViewCombinedDelegate}
        set { objc_setAssociatedObject(self, &AssociatedKeys.pickerViewDataSource, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
}

extension UIPickerView : ViewModelBindable {
    public var viewModel: ListViewModelType? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.viewModel) as? ListViewModelType}
        set { objc_setAssociatedObject(self, &AssociatedKeys.viewModel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
    public var disposeBag: DisposeBag {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.disposeBag) as? DisposeBag ?? DisposeBag()}
        set { objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    public func bind(to viewModel: ViewModelType?) {
        
        guard let vm = viewModel as? ListViewModelType else {
            return
        }
        self.viewModel = vm

        
        let picker = self
        
        if (vm.pickerViewDataSource == nil) {
            vm.pickerViewDataSource = ViewModelPickerViewDataSource(viewModel: vm)
        }
        self.dataSource = vm.pickerViewDataSource
        self.delegate = vm.pickerViewDataSource
        
        self.disposeBag = DisposeBag()
        vm.dataHolder.resultsCount.asObservable().subscribe(onNext:{_ in picker.reloadAllComponents()}).addDisposableTo(self.disposeBag)
    }
}
