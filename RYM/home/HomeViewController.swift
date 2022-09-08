//
//  HomeViewController.swift
//  RYM
//
//  Created by Yauheni Skiruk on 02/09/2022.
//

import SwiftUI
import UIKit
import CoreData

// MARK: - Basic class for navigation
final class HomeViewController: UIViewController {
    private let homeRouter = HomeRouter.shared
    private let homePresenter = HomePresenter.shared
    var viewContext: NSPersistentContainer

    init(viewContex: NSPersistentContainer) {
        self.viewContext = viewContex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.width,
                                        height: scrollView.height)
        let contextView = RemaindersListView().environment(\.managedObjectContext, viewContext.viewContext)
        let mainVC = UIHostingController(rootView: contextView)
        addChild(mainVC)
        scrollView.addSubview(mainVC.view)
        mainVC.didMove(toParent: self)
        mainVC.view.clipsToBounds = true
        homeRouter.navigationController = navigationController
        homePresenter.navigationController = navigationController
        (navigationController as? NavigationController)?.isSwipeToBackEnabled = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0,
                                  y: -view.safeAreaInsets.top,
                                  width: view.width,
                                  height: view.height + view.safeAreaInsets.bottom + view.safeAreaInsets.top)
        for (index, subview) in scrollView.subviews.enumerated() {
            subview.frame = CGRect(x: view.width * CGFloat(index),
                                   y: 0,
                                   width: scrollView.width,
                                   height: scrollView.height)
        }
    }
}
