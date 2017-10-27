# == Schema Information
#
# Table name: guests
#
#  id                      :integer          not null, primary key
#  email                   :string           default(""), not null
#  created_at              :datetime
#  updated_at              :datetime
#  company_name            :string
#  first_name              :string
#  last_name               :string
#  contact_number          :string
#  country                 :string
#  website                 :string
#  street                  :string
#  city                    :string
#  state                   :string
#  zipcode                 :string
#  archived                :boolean          default(FALSE)
#  confirmation_token      :string
#  confirmed_at            :datetime
#  confirmation_sent_at    :datetime
#  unconfirmed_email       :string
#  billing_street          :string
#  billing_city            :string
#  billing_state           :string
#  billing_zip_code        :string
#  same_addresses          :boolean          default(FALSE)
#  forem_admin             :boolean          default(FALSE)
#  forem_state             :string           default("pending_review")
#  forem_auto_subscribe    :boolean          default(FALSE)
#  billing_first_name      :string
#  billing_last_name       :string
#  shipping_first_name     :string
#  shipping_last_name      :string
#  shipping_street         :string
#  shipping_city           :string
#  shipping_state          :string
#  shipping_zip_code       :string
#  shipping_company        :string
#  billing_company         :string
#  referring_partner_email :string
#  company_id              :integer
#  about                   :text
#  status                  :integer          default(0)
#  daily_rate              :decimal(8, 2)    default(0.0)
#  video_bio               :text
#  source_name             :string
#  source_user_id          :string
#  parent_id               :integer
#  salutation              :string
#  business_title          :string
#  do_not_call             :boolean
#  do_not_email            :boolean
#  email_alternative       :string
#  phone_alternative       :string
#  notes                   :text
#  aasm_state              :string
#  origin_region           :integer
#  active_regions          :text             default([]), is an Array
#  active                  :boolean          default(TRUE)
#  archive                 :boolean          default(FALSE)
#  sales_force_id          :string
#
# Indexes
#
#  index_guests_on_origin_region  (origin_region)
#

class Guest < ActiveRecord::Base
end
