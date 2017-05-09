class FlyFormsController < ApplicationController
  include FlyForm

  def update
    object_name      = params.keys.third
    form_name        = "form_for_#{object_name.to_s.downcase}"
    form_name_symbol = form_name.to_sym
    unlocked_params  = ActiveSupport::HashWithIndifferentAccess.new(params[object_name.to_sym])
    instance         = object_name.capitalize.constantize.new(unlocked_params)
    current_user.settings[form_name_symbol] = instance
    render :nothing => true
  end
end
