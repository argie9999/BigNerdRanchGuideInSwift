import UIKit

class QuizViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel
    @IBOutlet weak var answerLabel: UILabel
    var currentQuestionIndex: Int = 0
    var questions: String[]
    var answers: String[]

    init() {
        questions = ["From what is cognac made?", "What is 7 + 7?", "What is the capital of Vermont?"]
        answers = ["Grapes", "14", "Montpelier"]
        super.init(nibName: nil, bundle: nil)
    }

    @IBAction func showQuestion(sender: AnyObject) {
        currentQuestionIndex++
        if currentQuestionIndex == questions.count {
            currentQuestionIndex = 0
        }
        questionLabel.text = questions[currentQuestionIndex]
        answerLabel.text = "???"
    }

    @IBAction func showAnswer(sender: AnyObject) {
        if questionLabel.text != "" {
            answerLabel.text = answers[currentQuestionIndex]
        }
    }
}
