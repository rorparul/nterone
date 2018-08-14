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


  changeAnswerText = (answer, e) => {
    this.props.updateAnswer(answer, parseInt(e.target.dataset.answerid), e.target.checked)
  }

  ChangedeleteValue =(answer,e) =>{
    this.props.removeAnswer(this.props.question, answer)
  }


  renderAnswer = (answer) => {
    return (
      <div key={answer.id} className='answer' style={{display: (answer._destroy == true) ? 'none' : 'block' }}>
        {this.renderAnswerId(answer)}
        <input
          className='form-control input-sm answer-text'
          placeholder='Enter Answer...'
          defaultValue={answer.answer_text}
          name={this.answerInputName(answer.id) + '[answer_text]'}
        />
        <span>Correct?</span>
        <input type="checkbox" data-answerid={answer.id} checked={answer.correct} className='answer-correct'
        onChange={this.changeAnswerText.bind(answer, this)}
         />

        <input name={this.answerInputName(answer.id) + '[correct]'} type="hidden" value={answer.correct} />
        <br/>
        <input type='hidden' name={this.answerInputName(answer.id) + '[_destroy]'} value={answer._destroy} />
        <a href="javascript:void(0)" onClick={this.ChangedeleteValue.bind(this,answer) } className="text-danger">Remove answer</a>
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
