class BrandsController < ApplicationController
  before_action :set_brand,          only:   [:show, :edit, :update]
  before_action :authenticate_user!, except: :show
  before_action :authorize_brand,    except: :show
  after_action  :verify_authorized,  except: :show

  def index
    @brands = Brand.all
  end

  def show
    @platforms = Platform.where(brand_id: @brand.id)
    render 'platforms/index'
  end

  def new
    @brand = Brand.new
    @brand.build_logo
    @brand.build_visual_asset
    @brand.visual_asset.build_email_logo
    @brand.build_brand_favicon
    @brand.brand_favicon.build_favicon
  end

  def edit
    @brand.build_logo unless @brand.logo.present?
    @brand.build_visual_asset unless @brand.visual_asset.present?
    @brand.visual_asset.build_email_logo unless @brand.visual_asset.email_logo.present?
    @brand.build_brand_favicon unless @brand.brand_favicon.present?
    @brand.brand_favicon.build_favicon unless @brand.brand_favicon.favicon.present?
  end

  def create
    @brand = Brand.new(brand_params)

    @brand.set_image(url_param: params['brand'], for: :logo)

    if !@brand.visual_asset.present?
      @brand.build_visual_asset
      @brand.visual_asset.set_image(url_param: params['brand']['visual_asset_attributes'], for: :email_logo)
    else
      @brand.visual_asset.set_image(url_param: params['brand']['visual_asset_attributes'], for: :email_logo)
    end

    if !@brand.brand_favicon.present?
      @brand.build_brand_favicon
      @brand.brand_favicon.set_image(url_param: params['brand']['brand_favicon_attributes'], for: :favicon)
    else
      @brand.brand_favicon.set_image(url_param: params['brand']['brand_favicon_attributes'], for: :favicon)
    end

    if @brand.save
      flash[:success] = 'Brand successfully created!'
      redirect_to(brand_path(@brand))
    else
      flash[:alert] = 'Brand unsuccessfully created!'
      render 'new'
    end
  end

  def update
    @brand.assign_attributes(brand_params)

    @brand.set_image(url_param: params['brand'], for: :logo)

    if !@brand.visual_asset.present?
      @brand.build_visual_asset
      @brand.visual_asset.set_image(url_param: params['brand']['visual_asset_attributes'], for: :email_logo)
    else
      @brand.visual_asset.set_image(url_param: params['brand']['visual_asset_attributes'], for: :email_logo)
    end

    if !@brand.brand_favicon.present?
      @brand.build_brand_favicon
      @brand.brand_favicon.set_image(url_param: params['brand']['brand_favicon_attributes'], for: :favicon)
    else
      @brand.brand_favicon.set_image(url_param: params['brand']['brand_favicon_attributes'], for: :favicon)
    end

    if @brand.save
      flash[:success] = 'Company successfully updated!'
      redirect_to :back
    else
      flash[:alert] = 'Company unsuccessfully updated!'
      render 'edit'
    end
  end

  private

  def set_brand
    @brand = params[:id].present? ? Brand.find(params[:id]) : brand
  end

  def brand_params
    params.require(:brand).permit(:title,
                                  :header,
                                  :url,
                                  :email,
                                  :phone_number,
                                  :contact_us_link,
                                  :general_street,
                                  :general_city,
                                  :general_state,
                                  :general_zipcode,
                                  :payment_street,
                                  :payment_city,
                                  :payment_state,
                                  :payment_zipcode,
                                  :footer,
                                  :color1,
                                  :color2,
                                  :color3,
                                  :color4,
                                  :confirmation_subject)
  end

  def authorize_brand
    @brand ||= Brand.new
    authorize @brand
  end
end
