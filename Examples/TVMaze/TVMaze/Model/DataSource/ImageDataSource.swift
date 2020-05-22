//
//  ImageDataSource.swift
//  Demo
//
//  Created by Stefano Mondino on 24/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import Kingfisher

public typealias Image = KFCrossPlatformImage

public protocol WithImage {
    func getImage() -> ObservableImage
    func getImage(with placeholder: WithImage?) -> ObservableImage
}
extension WithImage {
    public func getImage() -> ObservableImage {
        return getImage(with: nil)
    }
}

public typealias ObservableImage = Observable<Image>

private struct ImageDownloader {

    private static let downloader: Kingfisher.KingfisherManager = {
        return KingfisherManager.shared
    }()

    func download(_ url: URL) -> Observable<Image> {
        return Observable<Image>.create { observer in
            let start = Date()
            let task = ImageDownloader.downloader.retrieveImage(with: url) { result in

                switch result {
                case .success(let value):
                    let image = value.image
                    image.downloadTime = value.cacheType.cached ? 0 : Date().timeIntervalSince(start)
                    observer.onNext(image)
                    observer.onCompleted()
                case .failure(let error):
                    if error.isTaskCancelled { return }
                    observer.onError(error)
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
//        .retryWhen { _ in
//            Reachability.rx.status.filter { $0.isReachable }
//        }
    }

}

extension Image: WithImage {

    public func getImage(with placeholder: WithImage?) -> ObservableImage {
        return .just(self)
    }
}

extension URL: WithImage {

    public func getImage(with placeholder: WithImage?) -> ObservableImage {
        return ImageDownloader().download(self)
            .catchError { _ in return (placeholder ?? "")
                .getImage()
                .asObservable()
        }
    }
}

extension String: WithImage {
    public func getImage(with placeholder: WithImage?) -> ObservableImage {
        if let url = URL(string: self),
            let scheme = url.scheme,
            ["http", "https"].contains(scheme) {
            return url.getImage(with: placeholder)
        }
        guard let img = Image(named: self) else {
            return placeholder?.getImage() ?? .just(Image())}
        return .just(img)
    }
}

private struct AssociatedKeys {
    static var downloadtime = "imageDownloader_downloadtime"
}

extension Image {
    /// How long must take an image to be available in order to be considered "downloaded"
    var downloadTimeThreshold: TimeInterval { return 0.2 }

    ///Total amount of time that took this image to be "downloaded"
    /// This is useful to decide if, in the UI, an image should fade-in when presented or not
    /// Defaults to 0.0
    public fileprivate(set) var downloadTime: TimeInterval {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.downloadtime) as? TimeInterval ?? 0.0 }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.downloadtime, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }

    /// Defaults to false
    public var isDownloaded: Bool {
        return downloadTime > downloadTimeThreshold
    }
}

