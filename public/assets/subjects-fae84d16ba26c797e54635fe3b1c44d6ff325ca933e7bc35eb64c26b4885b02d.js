$(function() {
  function SubjectForm() {
    var _subjectNumber = $('#subject_number');
    _showHideExamPrice();

    function _showHideExamPrice() {
      $('#subject_object_type').change(function() {
        if ($(this).find('option:selected').text() === 'Exam') {
          _subjectNumber.prop('disabled', false);
          _subjectNumber.parent().removeClass('hidden');
        } else {
          _subjectNumber.prop('disabled', true);
          _subjectNumber.parent().addClass('hidden');
        }
      }).change();
    }
  }

  new SubjectForm();
});
