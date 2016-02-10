class LeadsController < ApplicationController
  before_action :authenticate_user!

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

  def show
    @buyer            = User.find(params[:id])
    @planned_subjects = @buyer.planned_subjects.where(active: true)
    @activities       = PublicActivity::Activity.where(trackable_id: @buyer.buyer_leads.pluck(:id)).order(created_at: :desc)
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
                           footer:  { html: { template:'layouts/_footer.html.slim' } })



    @lead.create_activity(key: 'lead.quote_downloaded',
                          owner: current_user,
                          parameters: { discount: @lead.discount, quote: @lead.discounted_price, course_titles: @lead.planned_unattended_courses_titles })
    send_data pdf, filename: "quote.pdf"
  end

  def email_quote
    @lead = Lead.find(params[:id])
    if QuoteMailer.pdf_attachment(@lead).deliver_later
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
end
