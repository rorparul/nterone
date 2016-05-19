'use strict'

class QuizFreeFormQuestionForm extends React.Component {
  static PropTypes = {
    question: React.PropTypes.object,
    questionInputName: React.PropTypes.string,
    addAnswer: React.PropTypes.func
  }

  answerInputName = (index) => {
    return `${this.props.questionInputName}[lms_exam_answers_attributes][${index}]`
  }

  addAnswerClicked = (e) => {
    e.preventDefault()

    let answer = {
      answer_text: '',
      correct: true,
      index: this.props.question.answers.length
    }

    this.props.addAnswer(this.props.question, answer)
  }

  renderAnswer = (answer) => {
    return <div key={answer.index} className='answer' placeholder='Enter correct Answer..'>
      <input name={this.answerInputName(answer.index) + '[answer_text]'} />
    </div>
  }

  renderAddAnswer = () => {
    if (this.props.question.answers.length == 0) {
      return <button onClick={this.addAnswerClicked.bind(this)}>Add Answer</button>
    }
  }

  render () {
    return <div className='answers'>
      {this.props.question.answers.map(answer => this.renderAnswer(answer))}
      {this.renderAddAnswer()}
    </div>
  }
}
