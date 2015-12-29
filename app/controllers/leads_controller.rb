class LeadsController < ApplicationController
  before_action :check_clearance, only: [:index]

  def request_quote
    lead = Lead.new(lead_params)
    if lead.save
      lead.create_activity(key: 'lead.quote_requested',
                            owner: current_user,
                            parameters: { discount: lead.discount,
                                          quote: lead.discounted_price,
                                          course_titles: lead.planned_unattended_courses_titles })
      flash[:success] = "Thank you for your inquiry. Someone will be in contact with
                       you soon! Feel free to #{view_context.link_to('contact us',
                       'http://www.nterone.com/contact-us/', html_options = {target: 'none'})}
                       if you have any questions in the meantime.".html_safe
    else
      falsh[:alert] = "Request failed to send!"
    end
    redirect_to :back
  end

  # def index
  #   if current_user.sales_manager? || current_user.admin?
  #     @sales_force      = Role.where(role: 3)
  #     @assigned_leads   = Lead.where(status: 'assigned').where.not(seller_id: [nil, 0]).order(created_at: :asc)
  #     @unassigned_leads = Lead.where(status: 'unassigned', seller_id: [nil, 0]).order(created_at: :asc)
  #     @archived_leads   = Lead.where(status: 'archived').order(created_at: :desc)
  #   elsif current_user.sales_rep?
  #     @assigned_leads   = Lead.where(status: 'assigned', seller_id: current_user.id).order(created_at: :asc)
  #     @unassigned_leads = Lead.where(status: 'unassigned', seller_id: [nil, 0]).order(created_at: :asc)
  #     @archived_leads   = Lead.where(seller_id: current_user.id, status: 'archived').order(created_at: :desc)
  #   end
  # end

  def show
    @buyer = User.find(params[:id])
    @planned_subjects = @buyer.planned_subjects.where(active: true)
    @activities = PublicActivity::Activity.where(trackable_id: @buyer.buyer_leads.pluck(:id)).order(created_at: :desc)
  end

  def edit
    @lead = Lead.find(params[:id])
  end

  def update
    @lead = Lead.find(params[:id])
    if lead_params.has_key?(:seller_id)
      if lead_params[:seller_id] == '0' || lead_params[:seller_id] == 'nil'
        @lead.status = 'unassigned'
      else
        @lead.status = 'assigned'
      end
    end
    if @lead.update_attributes(lead_params)
      flash[:success] = "Lead successfully saved!"
      if lead_params.has_key?(:discount)
        @lead.create_activity(key: 'lead.quote_updated',
                              owner: current_user,
                              parameters: { discount: @lead.discount, quote: @lead.discounted_price, course_titles: @lead.planned_unattended_courses_titles })
      end
    else
      flash[:alert] = "Lead unsuccessfully saved!"
    end
    redirect_to :back
  end

  def download_quote
    @lead = Lead.find(params[:id])
    pdf = render_to_string(pdf: 'quote',
                           margin: { bottom: 32 },
                           template: 'leads/quote.html.slim',
                           locals: { lead: @lead },
                           footer:  { html: { template:'layouts/_footer.html.slim'}})



    @lead.create_activity(key: 'lead.quote_downloaded',
                          owner: current_user,
                          parameters: { discount: @lead.discount, quote: @lead.discounted_price, course_titles: @lead.planned_unattended_courses_titles })
    send_data pdf, filename: "quote.pdf"
  end

  def email_quote
    @lead = Lead.find(params[:id])
    if QuoteMailer.pdf_attachment(@lead).deliver_now
      flash[:success] = "Email successfully sent!"
      @lead.create_activity(key: 'lead.quote_emailed',
                            owner: current_user,
                            recipient: @lead.buyer,
                            parameters: { discount: @lead.discount, quote: @lead.discounted_price, course_titles: @lead.planned_unattended_courses_titles })
    else
      flash[:alert] = "Email unsuccessfully sent!"
    end
    redirect_to :back
  end

  private

  def lead_params
    params.require(:lead).permit(:seller_id, :buyer_id, :status, :discount)
  end

  def check_clearance
    if current_user.member?
      redirect_to root_path
    end
  end
end
