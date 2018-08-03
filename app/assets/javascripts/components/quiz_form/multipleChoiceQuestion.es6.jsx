class QuizMultipleChoiceQuestionForm extends React.Component {
  static propTypes = {
    question: React.PropTypes.object,
    questionInputName: React.PropTypes.string,
    addAnswer: React.PropTypes.func
  }

  answerInputName = (id) => {
    return `${this.props.questionInputName}[lms_exam_answers_attributes][${id}]`
  }

  addAnswerClicked = (e) => {
    e.preventDefault()

    let answer = {
      id: this.props.question.answers.length,
      answer_text: '',
      correct: false
    }

    this.props.addAnswer(this.props.question, answer)
  }
  
  renderAnswerId (answer) {
    if(answer.lms_exam_question_id){
      return  <input type='hidden' defaultValue={answer.id} name={this.answerInputName(answer.id) + '[id]'} value={answer.id} />
    }
  }

  renderAnswer = (answer) => {
    return (
      <div key={answer.id} className='answer'>
        {this.renderAnswerId(answer)}
        <input
          className='form-control input-sm answer-text'
          placeholder='Enter Answer...'
          defaultValue={answer.answer_text}
          name={this.answerInputName(answer.id) + '[answer_text]'}
        />
        <span>Correct?</span>
        <input
          className='answer-correct'
          name={this.answerInputName(answer.id) + '[correct]'}
          defaultChecked={answer.correct}
          type='checkbox'
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
