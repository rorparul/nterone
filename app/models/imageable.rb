module Imageable
  def set_image(params = {})
    if params[:url_param].present?
      model_image = self.send(params[:for])
      atribute = "#{params[:for]}_attributes"
      model_image = send("build_#{params[:for]}") unless model_image.present?
      if params[:url_param][atribute] && params[:url_param][atribute]['file']
        model_image.file = params[:url_param][atribute]['file']
      end
    end
  end
end
