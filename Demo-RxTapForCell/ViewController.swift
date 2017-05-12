//
//  ViewController.swift
//  Demo-RxTapForCell
//
//  Created by 孙继刚 on 2017/5/9.
//  Copyright © 2017年 madordie. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let disposeBag = DisposeBag()

    let list = UITableView()
    let binded = PublishSubject<String>()
    let cacheCell = Cell.init(style: .default, reuseIdentifier: "123")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        plain()

        return
        list.delegate = self
        list.dataSource = self
        view.addSubview(list)
        list.frame = view.bounds

        binded
            .debug()
            .subscribe { (event) in
                print(event)
            }
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func config(cell: Cell) {
        cell.backgroundColor = UIColor.gray

        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }

        let button = UIButton.init()
        button.backgroundColor = UIColor.blue
        button.frame = cell.contentView.frame
        cell.contentView.addSubview(button)
        button.rx.tap.throttle(1, latest: false, scheduler: MainScheduler.instance).map ({ (_) -> String in
            return "bingo"
        })
            .bind(to: binded)
            .addDisposableTo(cell.reuseDisposeBag)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? Cell ?? Cell.init(style: .default, reuseIdentifier: "cell")
        config(cell: cell)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /*** 忽略dequeueReusableCell返回值需要扔给TableView ***/
        config(cell: cacheCell)
        return 100
    }
}

class Cell: UITableViewCell {

    var reuseDisposeBag = DisposeBag()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reuseDisposeBag = DisposeBag()
    }
    
    deinit {
        print("")
    }
}
