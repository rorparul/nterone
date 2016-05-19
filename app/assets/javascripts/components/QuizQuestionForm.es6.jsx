'use strict'

class QuizQuestionForm extends React.Component {
  state = {
    questions: []
  }

  questionInputName = (index) => {
    return `lms_exam[lms_exam_questions_attributes][${index}]`
  }

  addQuestion = (e) => {
    e.preventDefault()

    let questions = this.state.questions.concat([{
      index: this.state.questions.length,
      type: '0',
      answers: []
    }])

    this.setState({ questions })
  }

  typeChanged = (question, e) => {
    question.type = e.target.value
    this.setState({ questions: this.state.questions })
  }

  addAnswer = (question, answer) => {
    question.answers = question.answers.concat([answer])
    this.setState({ questions: this.state.questions })
  }

  renderAnswerForm (question) {
    if (question.type == '0') {
      return <QuizMultipleChoiceQuestionForm
        question={question}
        questionInputName={this.questionInputName(question.index)}
        addAnswer={this.addAnswer}
      />
    }

    if (question.type == '1') {
      return <QuizFreeFormQuestionForm
        question={question}
        questionInputName={this.questionInputName(question.index)}
        addAnswer={this.addAnswer}
      />
    }
  }

  renderQuestion = (question) => {
    return <div key={question.index} className='question'>
      <input
        className='form-control input-sm question-text'
        placeholder='Enter your Question'
        name={this.questionInputName(question.index) + '[question_text]'}
      />
      <select
        name={this.questionInputName(question.index) + '[question_type]'}
        defaultValue={question.type}
        onChange={this.typeChanged.bind(this, question)}
      >
        <option value='0'>Multiple Choice</option>
        <option value='1'>Free Choice</option>
      </select>

      {this.renderAnswerForm(question)}
    </div>
  }

  render () {
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
