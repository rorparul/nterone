'use strict'

class QuizForm extends React.Component {
  state = {
    questions: []
  }

  QuestionInputName = (index) => {
    return `lms_exam[lms_exam_questions_attributes][${index}]`
  }

  AnswerInputName = (questionIndex, answerIndex) => {
    return `${this.QuestionInputName(questionIndex)}[lms_exam_answers_attributes][${answerIndex}]`
  }

  renderQuestion = (question) => {
    return <div key={question.index} className='question'>
      <input name={this.QuestionInputName(question.index) + '[question_text]'} />
      <select  name={this.QuestionInputName(question.index) + '[question_type]'} defaultValue={question.type}>
        <option value='0'>Multiple Choice</option>
        <option value='1'>Free Choice</option>
      </select>

      <div className='answers'>
        {question.answers.map(answer => this.renderAnswer(question, answer))}
        <button onClick={this.addAnswer.bind(this, question)}>Add Answer</button>
      </div>
    </div>
  }

  renderAnswer = (question, answer) => {
    return <div key={answer.index} className='answer'>
      <input name={this.AnswerInputName(question.index, answer.index) + '[answer_text]'} />
      <span>Correct?</span>
      <input name={this.AnswerInputName(question.index, answer.index) + '[correct]'} type='checkbox' value='true'/>
    </div>
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

  addAnswer = (question, e) => {
    e.preventDefault()

    question.answers = question.answers.concat([{
      index: question.answers.length,
      answer_text: '',
      correct: false
    }])

    this.setState({ questions: this.state.questions })
  }

  render () {
    return (
      <div>
        {this.state.questions.map(q => this.renderQuestion(q))}
        <button onClick={this.addQuestion.bind(this)}>Add Question</button>
      </div>
    )
  }
}
