'use strict'

class QuizFreeFormQuestionForm extends React.Component {
  static propTypes = {
    question: React.PropTypes.object,
    questionInputName: React.PropTypes.string,
    addAnswer: React.PropTypes.func
  }

  componentWillMount () {
    let answer = {
      answer_text: '',
      correct: true,
      index: 0
    }

    this.props.addAnswer(this.props.question, answer)
  }

  answerInputName = (index) => {
    return `${this.props.questionInputName}[lms_exam_answers_attributes][${index}]`
  }

  renderAnswer = (answer) => {
    return (
      <div key={answer.index} className='answer'>
        <input
          className='form-control input-sm answer-text'
          placeholder='Enter correct Answer..'
          name={this.answerInputName(answer.index) + '[answer_text]'}
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
