class QuizQuestions extends React.Component {
  static propTypes = {
    answers: React.PropTypes.array,
    type: React.PropTypes.string
  }

  renderMultipleChoice = (answers) => {
    return <div>
      {answers.map(answer => {
        return <div key={answer.id}>
          <input type='radio' name='answer' value={answer.id} />
          {answer.answer_text}
          <br/>
        </div>
      })}
    </div>
  }

  renderFreeForm = (answers) => {
    return <div>
      {answers.map(answer => {
        return <div key={answer.id}>
          <input type='hidden' name='answer_id' value={answer.id} />
          <input name='answer' />
          <br/>
        </div>
      })}
    </div>
  }

  renderCorrectOrder = (answers) => {
    return <div>
      {answers.map((answer, i) => {
        return <div key={answer.id}>
          <input type='hidden' name={'answers[' + i + '][answer]'} value={answer.id} />
          {answer.answer_text}
          <input type='number' name={'answers[' + i + '][position]'} defaultValue={i} />
          <br/>
        </div>
      })}
    </div>
  }

  render () {
    let type = this.props.type
    let answers = this.props.answers

    if (type == 'multiple_choice') return this.renderMultipleChoice(answers)
    if (type == 'free_form') return this.renderFreeForm(answers)
    if (type == 'correct_order') return this.renderCorrectOrder(answers)
  }
}
