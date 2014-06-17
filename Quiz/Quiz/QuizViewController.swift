import UIKit

class QuizViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel
    @IBOutlet weak var answerLabel: UILabel
    @NSCopying var currentQuestionIndex: NSNumber?
    @NSCopying var questions: NSArray?
    @NSCopying var answers: NSArray?

    @IBAction func showQuestion(sender: AnyObject) {

    }

    @IBAction func showAnswer(sender: AnyObject) {

    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}
