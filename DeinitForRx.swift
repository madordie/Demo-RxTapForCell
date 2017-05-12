//
//  DeinitForRx.swift
//  Demo-RxTapForCell
//
//  Created by 孙继刚 on 2017/5/12.
//  Copyright © 2017年 madordie. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let noDieBag = DisposeBag()

/// 简化问题
func plain() {

    let btn = UIButton()
    btn.rx.tap
        .subscribe({ (event) in
            print("接下来一定会输出`completed`")
            print(event)
        })
        .addDisposableTo(noDieBag)
}
