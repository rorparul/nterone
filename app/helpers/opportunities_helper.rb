module OpportunitiesHelper
  def opportunity_stages_options
    [
      ['Closed/Lost (0%)', 0],
      ['Closed/Won (100%)', 100],
      ['Negotiation/Review (90%)', 90],
      ['Proposal/Quote (75%)', 75],
      ['Needs analysis (50%)', 50],
      ['Prospecting/Qualification (10%)', 10]
    ]
  end

  def opportunity_stage_in_text(percent)
    stage = opportunity_stages_options.find { |stage| stage[1] == percent }
    stage.first  if stage
  end

  def opportunity_reasons_for_loss_options
    [
      ['Better Pricing'],
      ['Bad Timing'],
      ['Competition'],
      ['Changed Mind']
    ]
  end

  def opportunity_kind_options
    [
      ['Live Online Public'],
      ['Live Online Private'],
      ['Onsite Private'],
      ['Self–paced Learning'],
      ['Lab Rental'],
      ['Other']
    ]
  end

  def opportunity_payment_kind_options
    [
      ['Check/PO'],
      ['Learning Credits'],
      ['Credit Card'],
      ['Wire']
    ]
  end
end
