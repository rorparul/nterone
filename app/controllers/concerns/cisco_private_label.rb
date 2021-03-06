module CiscoPrivateLabel
  require 'net/http'

  extend ActiveSupport::Concern

  private

  def cpl_get_log()
    new_request('/log')
  end

  def cpl_post_orders(order)
    payment_type = ['Credit Card', 'Tarjeta de Credito'].include?(order.payment_type) ? 'CC' : 'PO'

    post_object = {
      "orderId": order.id.to_s,
      "orderDate": DateTime.parse((order.created_at.utc - 10.seconds).to_s).rfc3339(3)[0..22] + 'Z',
      "paymentMethod": payment_type,
      "paymentReferenceId": 'Not provided',
      "orderItems": order.cisco_private_label_products.map do |cplp|
        {
          "productCode": cplp.orderable.cisco_course_product_code,
          "quantity": 1
        }
      end
    }

    new_request('/orders', post_object)
  end

  def cpl_get_orders()
    new_request('/orders')
  end

  def cpl_post_orders_cancel(order)
    post_object = {
      "orderId": order.id.to_s
    }

    new_request('/orders/cancel', post_object)
  end

  def cpl_post_enrollments(order)
    order.cisco_private_label_products.map do |cplp|
      post_object = {
        "orderId": order.id.to_s,
        "productCode": cplp.orderable.cisco_course_product_code,
        "enrollments": [
          {
            "email": order.buyer.email,
            "firstName": order.buyer.first_name,
            "lastName": order.buyer.last_name,
            "startDate": DateTime.parse(order.created_at.utc.to_s).rfc3339(3)[0..22] + 'Z',
            "endDate": DateTime.parse((order.created_at + 1.year).utc.to_s).rfc3339(3)[0..22] + 'Z'
          }
        ]
      }

      new_request('/enrollments', post_object)
    end
  end

  def cpl_get_enrollments()
    new_request('/enrollments')
  end

  def cpl_post_launch(post_object)
    new_request('/launch', post_object)
  end

  def cpl_get_learning_progress()
  end

  def cpl_get_reports()
  end

  def new_request(url_endpoint, post_object = nil)
    url_base                 = Rails.env.production? ? 'https://digital-learning.cisco.com/lpapi/v1' : 'https://private-label.cte.systems/lpapi/v1'
    uri                      = URI.parse(url_base + url_endpoint)
    request                  = "Net::HTTP::#{post_object ? 'Post' : 'Get'}".constantize.new(uri.request_uri)
    request['Authorization'] = "Bearer #{new_access_token}"
    request['Content-Type']  = 'application/json'
    request.body             = post_object.to_json
    http                     = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl             = true
    http.verify_mode         = Rails.env.production? ? OpenSSL::SSL::VERIFY_PEER : OpenSSL::SSL::VERIFY_NONE

    http.request(request)
  end

  def new_access_token
    client_id      = Rails.env.production? ? '39450595357f4ad581184ccb5b1e67c0' : 'a1a1fc70e1e34c9291848cc17726c5e2'
    client_secret  = Rails.env.production? ? '5C2E19a038b84B2Da16eB47f73CbE4cDu' : '9b308cFaC4Cb410Cad9D2B7711AD0446'
    grant_type     = 'client_credentials'
    scope          = 'IDENTITY'
    url_base       = Rails.env.production? ? 'https://digital-learning.cisco.com/lpapi/ckoauth/token' : 'https://private-label.cte.systems/ckoauth/token'
    url_params     = "?client_id=#{client_id}&client_secret=#{client_secret}&grant_type=#{grant_type}&scope=#{scope}"
    uri            = URI(url_base + url_params)
    cisco_response = Net::HTTP.get(uri)
    json           = JSON.parse(cisco_response)

    json['access_token']
  end
end
