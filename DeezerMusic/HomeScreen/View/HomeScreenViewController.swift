//
//  ViewController.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 11/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import SwiftUI
import RxCocoa

enum VisualizerType {
    case spectogram
    case bar
    case circle
}

class HomeScreenViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        return tableView
    }()
    private let viewModel: HomeScreenViewModel
    private let activityIndicator: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        loader.hidesWhenStopped = true
        loader.color = StyleManager.shared.labelTextColor
        return loader
    }()
    private var visualizerType = VisualizerType.spectogram
    private var isShown = false
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    let circleLabel: UILabel = {
        let label = UILabel()
        label.text = "Circle"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.backgroundColor = .white
        label.isUserInteractionEnabled = true
        return label
    }()
    let barLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.isUserInteractionEnabled = true
        label.text = "Bar"
        return label
    }()
    let spectogramLabel: UILabel = {
        let label = UILabel()
        label.text = "Spectogram"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.backgroundColor = .white
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let circleTapGesture = UITapGestureRecognizer()
    let barTapGesture = UITapGestureRecognizer()
    let spectogramTapGesture = UITapGestureRecognizer()
    
    let moreBarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "hamburger"), for: .normal)
        button.contentMode = .scaleToFill
        return button
    }()
    init(viewModel: HomeScreenViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("Deinit \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StyleManager.shared.apply(for: .SongList, view: view)
        setupUI()
        viewModel.loadData()
        _ = viewModel.initializeViewModelObservables()
            .map{$0.disposed(by: disposeBag)}
        _ = initializeHomeScreenObservables()
            .map{$0.disposed(by: disposeBag)}
        moreBarButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                animateStackView()
            }).disposed(by: disposeBag)
        circleTapGesture.rx.event
            .subscribe(onNext: { [unowned self] _ in
                animateStackView()
                visualizerType = .circle
            }).disposed(by: disposeBag)
        
        barTapGesture.rx.event
            .subscribe(onNext: { [unowned self] _ in
                animateStackView()
                visualizerType = .bar
            }).disposed(by: disposeBag)
        
        spectogramTapGesture.rx.event
            .subscribe(onNext: { [unowned self] _ in
                animateStackView()
                visualizerType = .spectogram
            }).disposed(by: disposeBag)
    }
    
    func animateStackView() {
        if isShown{
            UIView.animate(withDuration: 1) {
                self.stackView.alpha = 0
                self.stackView.transform = .identity
            }
        }else {
            UIView.animate(withDuration: 1) {
                self.stackView.alpha = 1
                self.stackView.transform = CGAffineTransform(translationX: 200, y: 0)
            }
        }
        isShown = !isShown
    }
    
    private func initializeHomeScreenObservables() -> [Disposable]{
        var disposables = [Disposable]()
        disposables.append(initializeLoaderObservable())
        disposables.append(initializeDataStatusObservable())
        disposables.append(initializeAlertObservable())
        return disposables
    }
    
    private func initializeAlertObservable() -> Disposable{
        viewModel.alertObservable
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [unowned self] type in
                self.processAlertType(for: type)
            }
            )
    }
    
    private func processAlertType(for type: AlertType){
        switch type{
        case .errorAlert(let message):
            showAlertWith(title: "Error", message: message)
        }
    }
    
    
    private func initializeLoaderObservable() -> Disposable{
        viewModel.loaderSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext:{ [unowned self] status in
                self.checkLoaderStatus(status: status)
            })
    }
    
    private func checkLoaderStatus(status: Bool){
        if status{
            self.activityIndicator.startAnimating()
        }
        else{
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func initializeDataStatusObservable() -> Disposable{
        viewModel.dataStatusObservable
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext:{ [unowned self] status in
                self.tableView.reloadData()
            }, onError: { [unowned self] error in
                self.showAlertWith(title: "Error", message: error.localizedDescription)
            })
    }
    
    private func setupUI(){
        view.addSubviews(views: [activityIndicator, tableView, stackView])
        view.backgroundColor = .white
        
        navigationController?.navigationBar.addSubview(moreBarButton)
        stackView.addArrangedSubview(circleLabel)
        stackView.addArrangedSubview(barLabel)
        stackView.addArrangedSubview(spectogramLabel)
        view.bringSubviewToFront(activityIndicator)
        circleLabel.addGestureRecognizer(circleTapGesture)
        barLabel.addGestureRecognizer(barTapGesture)
        spectogramLabel.addGestureRecognizer(spectogramTapGesture)
        setupConstraints()
        setupTableView()
    }
    
    private func setupConstraints(){
        activityIndicator.snp.makeConstraints { (maker) in
            maker.centerX.centerY.equalToSuperview()
        }
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(view.safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.leading)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(200)
        }
        barLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        circleLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        spectogramLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        moreBarButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(30)
        }
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        StyleManager.shared.apply(for: .ContentView, view: tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(TrendingLabelTableViewCell.self, forCellReuseIdentifier: "TrendingCell")
        tableView.register(SongTableViewCell.self, forCellReuseIdentifier: "SongTableViewCell")
    }
    
}
extension HomeScreenViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.screenData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentItem  = viewModel.screenData[indexPath.row]
        moreBarButton.alpha = 0
        moreBarButton.isUserInteractionEnabled = false
        switch visualizerType {
        case .bar:
            let vc = CustomHostingViewController(rootView: VisualizerView())
            vc.stopAVPlayerDelegate = self
            viewModel.audioSubject.onNext(currentItem.songList?.preview ?? "")
            navigationController?.pushViewController(vc, animated: true)
        case .circle:
            let vc = CustomHostingCircleViewController(rootView: VisualizerCircleView())
            vc.stopAVPlayerDelegate = self
            viewModel.audioSubject.onNext(currentItem.songList?.preview ?? "")
            navigationController?.pushViewController(vc, animated: true)
        case .spectogram:
            let vc = AudioSpectogramViewController()
            vc.stopAVPlayerDelegate = self
            viewModel.audioSubject.onNext(currentItem.songList?.preview ?? "")
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let screenElement = viewModel.screenData[indexPath.row]
        switch screenElement.cellType {
        case .Trending:
            let trendingCell: TrendingLabelTableViewCell = tableView.dequeueCell(identifier: "TrendingCell")
            return trendingCell
        case .Song:
            guard let songList = screenElement.songList else{ return UITableViewCell()}
            let songCell: SongTableViewCell = tableView.dequeueCell(identifier: "SongTableViewCell")
            songCell.configure(title: songList.title, albumURL: songList.album.cover, artistURL: songList.artist.picture, duration: songList.duration, albumName: songList.album.title, artist: songList.artist.name)
            return songCell
        }
    }
}

extension HomeScreenViewController: StopAVPlayerDelegate {
    func stopPlayer() {
        viewModel.avPlayer?.pause()
        moreBarButton.alpha = 1
        moreBarButton.isUserInteractionEnabled = true
    }
}
