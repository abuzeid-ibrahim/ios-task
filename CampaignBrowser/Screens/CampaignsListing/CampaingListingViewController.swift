import UIKit
import RxSwift


/**
 The view controller responsible for listing all the campaigns. The corresponding view is the `CampaignListingView` and
 is configured in the storyboard (Main.storyboard).
 */
class CampaignListingViewController: UIViewController {

    let disposeBag = DisposeBag()

    @IBOutlet
    private(set) weak var typedView: CampaignListingView!

    override func viewDidLoad() {
        super.viewDidLoad()

        assert(typedView != nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Load the campaign list and display it as soon as it is available.
        ServiceLocator.instance.networkingService
            .createObservableResponse(request: CampaignListingRequest())
            .observeOn(MainScheduler.instance)
            .retryWhen { [weak self] error in
                error.flatMapLatest { error -> Observable<Void> in
                    guard let self = self else { return .empty() }
                    return self.showErrorAlert(with: error.localizedDescription)
                }
            }
            .subscribe(onNext: { [weak self] campaigns in
                self?.typedView.display(campaigns: campaigns)
            })
            .disposed(by: disposeBag)
    }
}

extension CampaignListingViewController {
    func showErrorAlert(with message: String) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer in
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                observer.onNext(())
                observer.onCompleted()
            }))
            self?.present(alert, animated: true, completion: nil)
            return Disposables.create { alert.dismiss(animated: true, completion: nil) }
        }
    }
}
