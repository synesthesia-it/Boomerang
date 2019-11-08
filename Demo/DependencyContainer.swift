    import Foundation
    import Boomerang
    
    class AppDependencyContainer: DependencyContainer {
        typealias Key = Keys
        
        enum Keys: CaseIterable, Hashable {
            case routeFactory
            case collectionViewCellFactory
            case viewFactory
        }
        
        var container: [Key: () -> Any ] = [:]
        
        var routeFactory: RouteFactory { self[.routeFactory] }
             var viewFactory: ViewFactory { self[.viewFactory] }
             var collectionViewCellFactory: CollectionViewCellFactory { self[.collectionViewCellFactory] }
        
        init() {
            self.register(for: .routeFactory) { MainRouteFactory(container: self) }
            self.register(for: .viewFactory) { MainViewFactory()}
            self.register(for: .collectionViewCellFactory) { MainCollectionViewCellFactory(viewFactory: self.viewFactory) }
        }
        
        subscript<T>(index: Keys) -> T {
            guard let element: T = resolve(index) else {
                fatalError("No dependency found for \(index)")
            }
            return element
        }
    }
    
    ///Convert in Test
    extension AppDependencyContainer {
        func testAll() {
            
            Keys.allCases.forEach {
                //expect not nil
                let v: Any = self[$0]!
            }
        }
    }
    
