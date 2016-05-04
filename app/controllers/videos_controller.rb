class VideosController < ApplicationController

	def create
		@platform = Platform.find(video_params[:platform_id])
		@video_on_demand = VideoOnDemand.find(video_params[:video_on_demand_id])
		@video = Video.new(video_params.except(:platform_id, :video_on_demand_id))

    if @video.save
    	flash[:success] = "Video was uploaded to the #{@video.video_module.title} module!"
			redirect_to edit_platform_video_on_demand_path(@platform, @video_on_demand)
		end
	end

	private

  def video_params
    params.require(:video).permit(:id,
                                  :video_module_id,
                                  :position,
                                  :title,
                                  :embed_code,
                                  :free,
                                  :platform_id,
                                  :video_on_demand_id)
  end
end
