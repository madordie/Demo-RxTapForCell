## Demo-RxTapForCell
__[已解决]__尝试重现Rx在cell销毁的时候发送Completed消息。 

## 问题

经过简化之后：
```swift
let noDieBag = DisposeBag()

/// 简化问题
func plain() {
    let btn = UIButton()
    btn.rx.tap
        .subscribe({ (event) in
            print(event)
        })
        .addDisposableTo(noDieBag)
}
```
上面的`subscribe`中并不是什么都不会输出，而是收到一个`Completed`事件。

## 原因

当`Rx`所依附的实体生命周期结束时，[本身](https://github.com/ReactiveX/RxSwift/blob/master/RxCocoa/iOS/UIControl%2BRx.swift#L50)会发出最后一个`Completed`事件。

然后，将其`addDisposableTo`到一个生命周期比`btn`长的`DisposeBag`上时，这个`Completed`就出现了。

## 解决办法

首先，这并不是一个问题。`Rx`的逻辑就是如此。

然后针对当前场景`Cell`中，如果`Cell`中出现这样的`subscribe`出现`deinit`的时候，

可以使用最简单的方法去处理：在填充cell的时候去重置`reuseDisposeBag`，即可解决。
