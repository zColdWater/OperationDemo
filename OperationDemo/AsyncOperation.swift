import Foundation


/// 如果是需要异步执行代码
/// 需要覆盖: 1.isAsynchronous(默认是false,需要修改成true. 仅是给外界声明自己是 同步操作还是异步操作，没有什么特殊功能。)
/// 需要覆盖: 2.isExecuting 当开始任务 设置成 Ture，执行完成后 设置成 False
/// 需要覆盖: 3.isFinished 当开始任务 设置成 False，执行完成后 设置成 True
/// 需要覆盖: 4.start 异步代码 编写的位置
/// 注意⚠️:  需要手动的来控制Operation状态，Operation才能结束。
class AsyncOperation: Operation {
    
    override init() {}
    
    var result: String = ""
    
    var taskName: String = ""
    
    override var isAsynchronous: Bool { return true }
    
    private let stateLock = NSLock()
    
    // 一定要写KVO 否则无法更改状态
    // willChangeValue && didChangeValue
    private var _executing: Bool = false
    override private(set) var isExecuting: Bool {
        get {
            return stateLock.withCriticalScope { _executing }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            stateLock.withCriticalScope {
                if _executing != newValue {
                    _executing = newValue
                }
            }
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    // 一定要写KVO 否则无法更改状态
    // willChangeValue && didChangeValue
    private var _finished: Bool = false
    override private(set) var isFinished: Bool {
        get {
            return stateLock.withCriticalScope { _finished }
        }
        set {
            willChangeValue(forKey: "isFinished")
            stateLock.withCriticalScope {
                if _finished != newValue {
                    _finished = newValue
                }
            }
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override func start() {
        launchOperation()
        let queue: DispatchQueue = DispatchQueue(label: "serialQueue")
        queue.async {
            // 当前线程睡10s
            sleep(10)
            
            // 结果赋值
            if self.taskName == "任务1" {
                self.result = "I"
            }
            if self.taskName == "任务2" {
                self.result = "Love"
            }
            if self.taskName == "任务3" {
                self.result = "U"
            }
            
            // 改变Operation状态告诉外界，我执行完了，结束了。
            self.completeOperation()
        }
    }
    
    func completeOperation() {
        isExecuting = false
        isFinished = true
    }
    
    func launchOperation() {
        isExecuting = true
        isFinished = false
    }
}

