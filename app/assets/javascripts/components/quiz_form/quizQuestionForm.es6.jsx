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
      answers: []
    }])

    this.setState({ questions })
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

  renderAnswerForm (question) {
    if (question.type == '0') {
      return <QuizMultipleChoiceQuestionForm
        question={question}
        questionInputName={this.questionInputName(question.id)}
        addAnswer={this.addAnswer}
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
    return <div key={question.id} className='question'>
      {this.renderQuestionId(question)}
      <input
        className='form-control input-sm question-text'
        placeholder='Enter your Question'
        defaultValue={question.text}
        name={this.questionInputName(question.id) + '[question_text]'}
      />
      <select
        name={this.questionInputName(question.id) + '[question_type]'}
        defaultValue={question.type}
        onChange={this.typeChanged.bind(this, question)}
      >
        <option value='0'>Multiple Choice</option>
        <option value='1'>Free Choice</option>
        <option value='2'>Correct Order</option>
      </select>

      {this.renderAnswerForm(question)}
    </div>
  }

  render () {
    console.log(this.props.questions)
    return (
      <div className='question-answer-form'>
        <button
          className='add-question btn btn-default'
          onClick={this.addQuestion.bind(this)} >
          Add Question
        </button>
        {this.state.questions.map(q => this.renderQuestion(q))}
      </div>
    )
  }
}
