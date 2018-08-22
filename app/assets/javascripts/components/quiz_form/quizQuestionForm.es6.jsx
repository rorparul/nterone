class QuizQuestionForm extends React.Component {
  state = {
    questions: this.props.questions || []
  }

  questionInputName = (id) => {
    return `lms_exam[lms_exam_questions_attributes][${id}]`
  }

  addQuestion = (e) => {
    e.preventDefault()

    let questions = this.state.questions.concat([{
      id: this.state.questions.length,
      type: '0',
      position: this.state.questions.length,
      answers: []
    }])

    this.setState({ questions })
  }


  removeQuestion = (e, question) =>{
    e.preventDefault()
    for (var i = 0; i < this.state.questions.length; i++) {
      if(this.state.questions[i].id == question.id){
        this.state.questions[i]._destroy = true
      }
    }
    this.setState({ questions: this.state.questions})
  }

  typeChanged = (question, e) => {
    question.type = e.target.value
    question.answers = []

    this.setState({ questions: this.state.questions })
  }

  addAnswer = (question, answer) => {
    question.answers = question.answers.concat([answer])
    this.setState({ questions: this.state.questions })
  }

  updateQuestion = () => {
    this.setState({ questions: this.state.questions })
  }

  updateAnswer = (answer, answer_id, is_correct) => {

    for (var i = 0; i < answer.props.question.answers.length; i++) {
      if(answer.props.question.answers[i].id == answer_id){
        answer.props.question.answers[i].correct = is_correct
      }
    }

    this.setState({ questions: this.state.questions })
  }

  removeAnswer  = (question, answer) => {
    question.answers = question.answers.map((ans)=> (
        ans.id === answer.id ? { ...ans, _destroy: true } : ans
      ))
    this.setState({ questions: this.state.questions })
  }

  renderAnswerForm (question) {
    if (question.type == '0') {
      return <QuizMultipleChoiceQuestionForm
        question={question}
        questionInputName={this.questionInputName(question.id)}
        addAnswer={this.addAnswer}
        removeAnswer={this.removeAnswer}
        updateAnswer={this.updateAnswer}
      />
    }

    if (question.type == '1') {
      return <QuizFreeFormQuestionForm
        question={question}
        questionInputName={this.questionInputName(question.id)}
        addAnswer={this.addAnswer}
      />
    }

    if (question.type == '2') {
      return <QuizCorrectOrderQuestionForm
        question={question}
        questionInputName={this.questionInputName(question.id)}
        addAnswer={this.addAnswer}
        removeAnswer={this.removeAnswer}
        updateQuestion={this.updateQuestion}
      />
    }
  }

  renderQuestionId (question) {
    if (question.text != undefined) {
      return  <input type='hidden' name={this.questionInputName(question.id) + '[id]'} value={question.id} />
    }
  }

  renderQuestion = (question) => {
    return <div key={question.id} className='question'  data-id={question.id} style={{display: (question._destroy == true) ? 'none' : 'block' }}>
      {this.renderQuestionId(question)}
      <input
        className='form-control input-sm question-text'
        placeholder='Enter your Question'
        defaultValue={question.text}
        name={this.questionInputName(question.id) + '[question_text]'}
      />

      <input type='number'
        className='form-control input-sm question-position'
        defaultValue={question.position}
        name={this.questionInputName(question.id) + '[position]'}
        style={{display: 'inline-block', width: 60, marginLeft: 10, marginRight: 10}}
      />

      <select
        className='form-control input-sm'
        style={{display: 'inline-block', width: 120}}
        name={this.questionInputName(question.id) + '[question_type]'}
        defaultValue={question.type}
        onChange={this.typeChanged.bind(this, question)}
      >
        <option value='0'>Multiple Choice</option>
        <option value='1'>Free Choice</option>
        <option value='2'>Correct Order</option>
      </select>
      <br/>
      <input type='hidden' name={this.questionInputName(question.id) + '[_destroy]'} value={question._destroy} />
      <a href="javascript:void(0)" onClick={(e) => this.removeQuestion(e, question) } className="text-danger">Remove question and answers</a>
      {this.renderAnswerForm(question)}
    </div>
  }

  render () {
    console.log(this.props.questions)
    return (
      <div className='question-answer-form'>
        {this.state.questions.map(q => this.renderQuestion(q))}
        <button
          className='add-question btn btn-default'
          onClick={this.addQuestion.bind(this)} >
          Add Question
        </button>
      </div>
    )
  }
}
