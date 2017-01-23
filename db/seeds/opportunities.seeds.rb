require 'faker'
require_relative 'support'
extend Support

after :events do
  notify(__FILE__)

  Opportunity.destroy_all  if Rails.env.development?

  User.limit(3).each do |employee|
    50.times.each do
      customer = User.all.to_a.sample
      account  = Company.all.to_a.sample
      partner  = Company.all.to_a.sample
      course   = Course.all.to_a.sample
      event    = Event.all.to_a.sample
      opportunity = Opportunity.create(
        employee: employee,
        customer: customer,
        account: account,
        title: Faker::Lorem.sentence,
        stage: [0, 10, 50, 75, 90, 100].sample,
        amount: Faker::Number.decimal(2),
        kind: Faker::Lorem.word,
        reason_for_loss: Faker::Lorem.sentence,
        waiting: [true, false].sample,
        payment_kind: Faker::Lorem.sentence,
        billing_street: Faker::Address.street_address,
        billing_city: Faker::Address.city,
        billing_state: Faker::Address.state,
        billing_zip_code: Faker::Address.state_abbr,
        partner: partner,
        date_closed: nil,
        course: course,
        event: event,
        email_optional: Faker::Internet.free_email,
        notes: Faker::Lorem.paragraph(10)
      )
      opportunity.update date_closed: Faker::Date.between(3.years.ago, Date.today)
    end
  end
end
