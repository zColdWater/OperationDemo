import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var input: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        input.delegate = self
        input.text = "1"
    }

    
    @IBAction func onLaunch(_ sender: Any) {

        let operation1: AsyncOperation = AsyncOperation()
        operation1.taskName = "任务1"
        let operation2: SyncOperation = SyncOperation()
        operation2.taskName = "任务2"
        let operation3: AsyncOperation = AsyncOperation()
        operation3.taskName = "任务3"
        
        let operation4 = BlockOperation {
            
            // 如果开启并发大于等于3，最早10s被打印出来
            // 如果并发设置成12，最早也要30s被打印出来
            print(operation1.result + " " + operation2.result + " " + operation3.result + "!!!")
        }
        
        operation4.addDependency(operation1)
        operation4.addDependency(operation2)
        operation4.addDependency(operation3)
        
        let queue = OperationQueue.init()
        // 这里设置成10 是让他们并发去执行。
        queue.maxConcurrentOperationCount = Int(input.text!) ?? 1
        queue.addOperations([operation1,operation2,operation3,operation4], waitUntilFinished: false)
        print("我肯定最早被打印出来!!!")
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}

