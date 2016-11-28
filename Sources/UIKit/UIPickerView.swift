//
//  UIPicker.swift
//  Boomerang
//
//  Created by Stefano Mondino on 28/11/16.
//
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

private struct AssociatedKeys {
    static var viewModel = "viewModel"
    static var disposable = "disposable"
    static var pickerViewDataSource = "pickerViewDataSource"
    
}

private class ViewModelPickerViewDataSource : NSObject, PickerViewCombinedDelegate {
    weak var viewModel: ListViewModelType?
    init (viewModel: ListViewModelType) {
        super.init()
        self.viewModel = viewModel
        
    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        let count =  self.viewModel?.dataHolder.models.value.children?.count ?? 1
        return count
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count =  self.viewModel?.dataHolder.models.value.children?[component].models?.count
        count =  count ?? self.viewModel?.dataHolder.models.value.models?.count
        return count ?? 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let viewModel:ItemViewModelType? = self.viewModel?.viewModelAtIndex(IndexPath(row: row, section: component))
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
    
    public var disposable: CompositeDisposable? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.disposable) as? CompositeDisposable}
        set { objc_setAssociatedObject(self, &AssociatedKeys.disposable, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    public func bind(_ viewModel: ViewModelType?) {
        
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
        
        vm.dataHolder.resultsCount.producer.map {_ in return ()}.startWithValues { _ in
            picker.reloadAllComponents()
        }
        vm.reload()
    }
}
