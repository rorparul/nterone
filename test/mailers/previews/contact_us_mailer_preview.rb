class ContactUsMailerPreview < ActionMailer::Preview
  def contact_us
    params = {
      name: "Joe",
      phone: "555.555.5555",
      email: "joeshmoe@mail.com",
      inquiry: "How much wood can a woodchuck chuck, if a woodchuck could chuck wood?",
      feedback: "Twelve, the answer is twelve."
    }
    ContactUsMailer.contact_us(params)
  end
end
