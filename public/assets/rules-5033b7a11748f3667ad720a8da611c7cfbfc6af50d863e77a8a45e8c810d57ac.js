$(function() {
  function RuleValidator(elem) {
    var rule = elem;
    var errorMessage = '';

    function _setErrorMessage(error) { errorMessage = error; }
    function _clearErrorMessage() { errorMessage = ''; }
    function _defaultFor(arg, val) { return (typeof arg !== 'undefined' ? arg : val); }
    function _lastValueOfRule() { return rule.val()[rule.val().length - 1] }
    function _beginingOfRule() { return rule.val().length === 0 }
    function _afterOperationSign() { return _lastValueOfRule() === ' ' }
    function _afterClosingBracket() { return _lastValueOfRule() === ')' }
    function _afterOpeningBracket() { return _lastValueOfRule() === '(' }
    function _afterSubjectValue() {
      if (_afterOperationSign() || _beginingOfRule() || _afterOpeningBracket()) { return false; }
      return true;
    } //TODO this should be adjusted after configuring validations for subject and category name

    this.openingBracket = function(message) {
      _clearErrorMessage();
      if (_beginingOfRule() || _afterOperationSign()) { return true; }
      _setErrorMessage(_defaultFor(message, "You cannot use '(' in this place."));
      return false;
    }

    this.closingBracket = function(message) {
      _clearErrorMessage();
      if (_afterClosingBracket() || _afterSubjectValue()) { return true; }
      _setErrorMessage(_defaultFor(message,"You cannot use ')' in this place."));
      return false;
    }

    this.operation = function() {
      return this.closingBracket("You cannot use operation in this place.");
    }

    this.subjectValue = function() {
      _clearErrorMessage();
      if (_afterOpeningBracket()) { return true; }
      return this.openingBracket("You cannot use subject value in this place.");
    }

    this.wholeRule = function() { // TODO this should send request to server where we will try parse whole rule
      _clearErrorMessage();
      if (_beginingOfRule() || _afterOperationSign() || _afterOpeningBracket()) {
        _setErrorMessage("You cannot submit rule, it's composed not correctly.");
        return false;
      }
      return true;
    }

    this.errorMessage = function() { return errorMessage; }
  }

  function RuleForm() {
    var _subjectRule = $("#rule_statement");
    var _validator = new RuleValidator(_subjectRule);
    var _subjectRuleIds = $("#rule_statement_with_ids");
    _categorySelected() ? _hideSubjectsInfo() : _hideCategoryInfo()
    _categorySubjectCheckbox();
    _categoriesAutocomplete();
    _subjectsAutocomplete();
    _operationHandlers();
    _submitHandler();

    function _categorySelected() {
      return $('#cat_yes').is(':checked')
    }

    function _hideSubjectsInfo() {
      $('.categories.hidden').removeClass('hidden');
      $('.subjects').addClass('hidden');
      $('#op_btn').addClass('hidden');
      $('#cl_btn').addClass('hidden');
    }

    function _hideCategoryInfo() {
      $('.categories').addClass('hidden');
      $('.subjects.hidden').removeClass('hidden');
      $('#op_btn.hidden').removeClass('hidden');
      $('#cl_btn.hidden').removeClass('hidden');
    }

    function _categorySubjectCheckbox() {
      $('#cat_yes').click(function() { _hideSubjectsInfo(); });
      $('#cat_no').click(function() { _hideCategoryInfo(); });
    }

    function _setCategoryName(item) {
      $('#rule_category_id').val(item.id);
      $('#category_name').text(item.label);
    }

    function _setCategoryOperation(item) {
      $('#rule_category_operation').val(item.id);
      $('#category_op').text(item.label);
    }

    function _categoriesAutocomplete() {
      $('#q_c').autocomplete({
        source: "/categories/autocomplete",
        minLength: 2,
        appendTo: ".categories-suggestions",
        select: function(event, ui) {
          _setCategoryName(ui.item);
          $(this).val('');
          return false;
        }
      });
    }

    function _addRule(item) {
      _subjectRule.val(_subjectRule.val() + item.label);
      _subjectRuleIds.val(_subjectRuleIds.val() + item.id)
    }

    function _showErrorMessage(message) {
      $('.content').children('hr').first().after("<div class='alert alert-danger alert-dismissible' role='alert'><button type='button' data-dismiss='alert' class='close' aria-label='Close'><span aria-hidden='true'>×</span></button><p>" + message + "</p></div>");
      $('.alert-danger').alert();
      $('.alert-danger').delay(4000).slideUp(200, function() { $(this).alert('close'); });
    }

    function _showResult(item, validation_passed) {
      validation_passed ? _addRule(item) : _showErrorMessage(_validator.errorMessage())
    }

    function _subjectsAutocomplete() {
      $('#q').autocomplete({
        source: "/subjects/autocomplete",
        minLength: 2,
        appendTo: ".subjects-suggestions",
        select: function(event, ui) {
          _showResult(ui.item, _validator.subjectValue());
          $(this).val('');
          return false;
        }
      });
    }

    function _operationHandlers() {
      $("#and_btn").click(function(e) {
        e.preventDefault();
        if (_categorySelected()) {
          _setCategoryOperation({ id: '*', label: 'and'});
        } else {
          _showResult({ label: " and ", id: " * " }, _validator.operation());
        }
      });
      $("#or_btn").click(function(e) {
        e.preventDefault();
        if (_categorySelected()) {
          _setCategoryOperation({ id: '+', label: 'or' });
        } else {
          _showResult({ label: " or ", id: " + " }, _validator.operation());
        }
      });
      $("#op_btn").click(function(e) {
        e.preventDefault();
        _showResult({ label: "(", id: "(" }, _validator.openingBracket());
      });
      $("#cl_btn").click(function(e) {
        e.preventDefault();
        _showResult({ label: ")", id: ")" }, _validator.closingBracket());
      });
      $("#cancel_btn").click(function(e) {
        e.preventDefault();
        if (_categorySelected()) {
          _setCategoryName({ id: '', label: '' });
          _setCategoryOperation({ id: '', label: '' });
        } else {
          _subjectRule.val('');
          _subjectRuleIds.val('');
        }
      });
    }

    function _submitHandler() {
      $(".rule_form").submit(function(e) {
        if (!_categorySelected() && !_validator.wholeRule()) {
          e.preventDefault();
          _showErrorMessage(_validator.errorMessage())
        }
      });
    }
  }

  new RuleForm();
});
