import Foundation


/// 如果是需要执行同步代码，只需要重写 main() 方法即可，
/// main() 填写同步的方法
/// 注意⚠️:  不需要手动控制自己的状态。
class SyncOperation: Operation {
    
    var result: String = ""
    var taskName: String = ""
    
    override func main() {
        
        if isCancelled { return }
        // 同步睡10s
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
        
    }
    
}
