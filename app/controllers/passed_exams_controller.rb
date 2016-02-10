class PassedExamsController < ApplicationController
  before_action :authenticate_user!
  
  def toggle
    passed_exam = PassedExam.find_by(passed_exam_params)
    @exam       = Exam.find(passed_exam_params[:exam_id])
    if passed_exam
      if passed_exam.destroy
        render :action => "destroy"
      end
    else
      if PassedExam.create(passed_exam_params)
        render :action => "create"
      end
    end
  end

  private

  def passed_exam_params
    params.require(:passed_exam).permit(:user_id, :exam_id)
  end
end
