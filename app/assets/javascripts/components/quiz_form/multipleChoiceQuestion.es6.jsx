class QuizMultipleChoiceQuestionForm extends React.Component {
  static propTypes = {
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
      correct: false,
      index: this.props.question.answers.length
    }

    this.props.addAnswer(this.props.question, answer)
  }

  renderAnswer = (answer) => {
    return (
      <div key={answer.index} className='answer'>
        <input
          className='form-control input-sm answer-text'
          placeholder='Enter Answer...'
          name={this.answerInputName(answer.index) + '[answer_text]'}
        />
        <span>Correct?</span>
        <input
          className='answer-correct'
          name={this.answerInputName(answer.index) + '[correct]'}
          type='checkbox'
          value='true'
        />
      </div>
    )
  }

  render () {
    return <div className='answers'>
      {this.props.question.answers.map(answer => this.renderAnswer(answer))}

      <button
        onClick={this.addAnswerClicked.bind(this)}
        className='add-answer btn btn-info'>
        Add Answer
      </button>
    </div>
  }
}
