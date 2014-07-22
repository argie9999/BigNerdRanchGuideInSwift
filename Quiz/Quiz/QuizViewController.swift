import UIKit

class QuizViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel?
    @IBOutlet weak var answerLabel: UILabel?
    var currentQuestionIndex: Int = 0
    var questions: [String]
    var answers: [String]

    init() {
        questions = ["From what is cognac made?", "What is 7 + 7?", "What is the capital of Vermont?"]
        answers = ["Grapes", "14", "Montpelier"]
        super.init(nibName: nil, bundle: nil)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func showQuestion(sender: AnyObject) {
        currentQuestionIndex++
        if currentQuestionIndex == questions.count {
            currentQuestionIndex = 0
        }

        // Silver challenge: Animate the new question coming in from the left
        questionLabel!.frame = CGRectMake(-200, 20, view.bounds.width, 44)
        questionLabel!.alpha = 0.0
        UIView.animateWithDuration(0.8) {
            self.questionLabel!.frame = CGRectMake(0, 20, self.view.bounds.width, 44)
            self.questionLabel!.alpha = 1.0
        }

        questionLabel!.text = questions[currentQuestionIndex]
        answerLabel!.text = "???"
    }

    @IBAction func showAnswer(sender: AnyObject) {
        if questionLabel!.text != "" {
            answerLabel!.text = answers[currentQuestionIndex]
            answerLabel!.frame = CGRectMake(-200, self.view.bounds.height - 90, view.bounds.width, 44)
            UIView.animateWithDuration(0.8) {
                self.answerLabel!.frame = CGRectMake(0, self.view.bounds.height - 90,
                    self.view.bounds.width, 44)
                self.answerLabel!.alpha = 1.0
            }
        }
    }
}
