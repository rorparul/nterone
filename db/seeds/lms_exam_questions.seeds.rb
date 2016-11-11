after :lms_exams do
  LmsExam.all.each do |exam|
    question1 = LmsExamQuestion.create(question_text: 'Name this number 8', question_type: 0)

    LmsExamQuestionJoin.create(lms_exam: exam, lms_exam_question: question1)
    LmsExamAnswer.create(answer_text: 'five', position: 1, correct: false, lms_exam_question: question1)
    LmsExamAnswer.create(answer_text: 'eight', position: 2, correct: true, lms_exam_question: question1)
    LmsExamAnswer.create(answer_text: 'zero', position: 3, correct: false, lms_exam_question: question1)

    question2 = LmsExamQuestion.create(question_text: 'How many legs the duck has?', question_type: 1)
    LmsExamQuestionJoin.create(lms_exam: exam, lms_exam_question: question2)
    LmsExamAnswer.create(answer_text: 'two', position: 1, correct: true, lms_exam_question: question2)

    question3 = LmsExamQuestion.create(question_text: 'Order numbers', question_type: 2)
    LmsExamQuestionJoin.create(lms_exam: exam, lms_exam_question: question3)
    LmsExamAnswer.create(answer_text: '8', position: 2, correct: true, lms_exam_question: question3)
    LmsExamAnswer.create(answer_text: '3', position: 1, correct: true, lms_exam_question: question3)
    LmsExamAnswer.create(answer_text: '19', position: 4, correct: true, lms_exam_question: question3)
    LmsExamAnswer.create(answer_text: '12', position: 3, correct: true, lms_exam_question: question3)
  end
end
