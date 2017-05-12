module FlyForm
  extend ActiveSupport::Concern
  
  private

  def fly_form(action)
    instantiate_variables
    return post_form_settings    if action == 'post'
    return get_form_settings     if action == 'get'
    return destroy_form_settings if action == 'destroy'
  end

  def post_form_settings
    instance = instance_variable_get("@#{@class_name.downcase}")
    current_user.settings[@form_name_symbol] = instance
  end

  def get_form_settings
    if current_user.settings.send(@form_name_symbol)
      return current_user.settings.send(@form_name_symbol)
    else
      return @class_name.constantize.new
    end
  end

  def destroy_form_settings
    if current_user.settings.send(@form_name_symbol)
      current_user.settings.destroy @form_name_symbol
    end
  end

  def instantiate_variables
    @class_name          = self.controller_name.classify
    @form_name           = "form_for_#{@class_name.to_s.downcase}"
    @form_name_symbol    = @form_name.to_sym
  end
end
