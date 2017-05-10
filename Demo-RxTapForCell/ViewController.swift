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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        list.delegate = self
        list.dataSource = self
//        list.register(Cell.self, forCellReuseIdentifier: "cell")
        view.addSubview(list)
        list.frame = view.bounds

        binded
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

        cell.tap.rx.event
            .map { $0.description }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? Cell ?? Cell.init(style: .default, reuseIdentifier: "cell")
        config(cell: cell)
        return 100
    }
}

class Cell: UITableViewCell {

    var reuseDisposeBag = DisposeBag()

    let tap = UITapGestureRecognizer()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        addGestureRecognizer(tap)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reuseDisposeBag = DisposeBag()
    }
}
