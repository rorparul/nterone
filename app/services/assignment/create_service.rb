class Assignment::CreateService
  def initialize(assigner, student, item)
    @assigner = assigner
    @student = student
    @item = item
  end

  def call
    return ResultObjects::Failure.new('assignment exists') if assignment_exists?
    create_assignment
  end

private

  def assignment_exists?
    AssignedItem.exists?(assigner: @assigner, student: @student, item: @item)
  end

  def create_assignment
    asignment = AssignedItem.create(assigner: @assigner, student: @student, item: @item)

    if asignment.errors.present?
      ResultObjects::Failure.new(asignment.errors)
    else
      ResultObjects::Success.new(asignment)
    end
  end
end
