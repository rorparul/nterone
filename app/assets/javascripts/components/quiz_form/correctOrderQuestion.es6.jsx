class QuizCorrectOrderQuestionForm extends React.Component {
  static propTypes = {
    question: React.PropTypes.object,
    questionInputName: React.PropTypes.string,
    addAnswer: React.PropTypes.func,
    updateQuestion: React.PropTypes.func
  }

  answerInputName = (id) => {
    return `${this.props.questionInputName}[lms_exam_answers_attributes][${id}]`
  }

  addAnswerClicked = (e) => {
    e.preventDefault()

    let answer = {
      id: this.props.question.answers.length + 1,
      answer_text: '',
      correct: true,
      position: this.props.question.answers.length + 1
    }

    this.props.addAnswer(this.props.question, answer)
  }

  changeAnswerText = (answer, e) => {
    answer.answer_text = e.target.value
    this.props.updateQuestion()
  }

  renderAnswerId (answer) {
    if(answer.lms_exam_question_id){
      return  <input type='hidden' name={this.answerInputName(answer.id) + '[id]'} value={answer.id} />
    }
  }

  ChangedeleteValue =(answer,e) =>{
    this.props.removeAnswer(this.props.question, answer)
  }

  renderAnswer = (answer) => {
    return (
      <div key={answer.id} className='answer' style={{display: (answer._destroy == true) ? 'none' : 'block' }}>
        {this.renderAnswerId(answer)}
        
        <input type='hidden' value='true' name={this.answerInputName(answer.id) + '[correct]'}/>
        <input className='form-control input-sm answer-text'
          placeholder='Enter Answer...'
          defaultValue={answer.answer_text}
          name={this.answerInputName(answer.id) + '[answer_text]'}
          onChange={this.changeAnswerText.bind(this, answer)}
        />

        <input type='number'
          className='form-control input-sm answer-position'
          defaultValue={answer.position}
          name={this.answerInputName(answer.id) + '[position]'}
        />
        <br/>
        <input type='hidden' name={this.answerInputName(answer.id) + '[_destroy]'} value={answer._destroy} />
        <a href="javascript:void(0)" onClick={this.ChangedeleteValue.bind(this,answer) } className="text-danger">Remove</a>
      </div>
    )
  }

  render () {
    return <div className='answers'>
      {this.props.question.answers.sort((a,b)=>(a.position - b.position)).map(answer => this.renderAnswer(answer))}

      <button
        onClick={this.addAnswerClicked.bind(this)}
        className='add-answer btn btn-info'>
        Add Answer
      </button>
    </div>
  }
}
