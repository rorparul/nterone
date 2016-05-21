'use strict'

var placeholder = document.createElement('li')
placeholder.className = 'placeholder'

class QuizCorrectOrderQuestionForm extends React.Component {
  static propTypes = {
    question: React.PropTypes.object,
    questionInputName: React.PropTypes.string,
    addAnswer: React.PropTypes.func,
    updateQuestion: React.PropTypes.func
  }

  answerInputName = (position) => {
    return `${this.props.questionInputName}[lms_exam_answers_attributes][${position}]`
  }

  addAnswerClicked = (e) => {
    e.preventDefault()

    let answer = {
      answer_text: '',
      correct: true,
      position: this.props.question.answers.length
    }

    this.props.addAnswer(this.props.question, answer)
  }

  changeAnswerText = (answer, e) => {
    answer.answer_text = e.target.value
    this.props.updateQuestion()
  }

  renderAnswer = (answer) => {
    let position = answer.position

    return (
      <div key={position} className='answer'>
        <input type='hidden' value='true' name={this.answerInputName(position) + '[correct]'}/>

        <input className='form-control input-sm answer-text'
          placeholder='Enter Answer...'
          defaultValue={answer.answer_text}
          name={this.answerInputName(position) + '[answer_text]'}
          onChange={this.changeAnswerText.bind(this, answer)}
        />

        <input type='number'
          className='form-control input-sm answer-position'
          defaultValue={position}
          name={this.answerInputName(position) + '[position]'}
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
