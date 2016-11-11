class QuizFreeFormQuestionForm extends React.Component {
  static propTypes = {
    question: React.PropTypes.object,
    questionInputName: React.PropTypes.string,
    addAnswer: React.PropTypes.func
  }

  componentWillMount () {
    let answer = {
      id: 0,
      answer_text: '',
      correct: true
    }

    if (this.props.question.answers.length == 0) {
      this.props.addAnswer(this.props.question, answer)
    }
  }

  answerInputName = (id) => {
    return `${this.props.questionInputName}[lms_exam_answers_attributes][${id}]`
  }

  renderAnswer = (answer) => {
    return (
      <div key={answer.id} className='answer'>
        <input
          className='form-control input-sm answer-text'
          placeholder='Enter correct Answer..'
          name={this.answerInputName(answer.id) + '[answer_text]'}
          defaultValue={answer.answer_text}
          />
      </div>
    )
  }


  render () {
    return <div className='answers'>
      {this.props.question.answers.map(answer => this.renderAnswer(answer))}
    </div>
  }
}
