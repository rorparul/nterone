class Admin::SettingsController < Admin::BaseController
  before_action :get_setting, only: [:edit, :update]
  before_action :authorize_user

  def index
    @settings = Setting.get_all
  end

  def edit
  end

  def update
    if @setting.value != params[:setting][:value]
      @setting.value = params[:setting][:value]
      result = @setting.save
      if result
        flash[:success] = 'Setting successfully updated!'
        render js: "window.location = '#{request.referrer}';"
      else
        render js: ""
      end
    else
      flash[:success] = 'Setting didn\'t update!'
      render js: "window.location = '#{request.referrer}';"
    end
  end

  private

  def get_setting
    @setting = Setting.find_by(var: params[:id]) || Setting.new(var: params[:id])
  end

  def authorize_user
    authorize Setting
  end
end
