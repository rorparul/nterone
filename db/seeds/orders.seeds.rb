after :events do
  Event.all.each do |event|
    order = Order.create(
      first_name: 'George',
      last_name: 'RR Martin',
      shipping_street: 'Main Street',
      shipping_city: 'Winterfell',
      shipping_state: 'Winterfell',
      shipping_zip_code: 111,
      shipping_country: 'Westeross',
      email: 'johnsnow@gmail.com',
      clc_number: "",
      paid: 0,
      buyer_id: User.first.id,
      status: 'No Charge',
      total: 0,
      payment_type: 'Credit Card',
      same_addresses: false,
      po_paid: 0,
      verified: false,
      invoiced: false,
      invoice_number: '1234',
      status_position: 3
    )

    order_item = OrderItem.create(
      orderable: event,
      order: order,
      user: User.first,
      sent_webex_invite: false,
      sent_course_material: false,
      sent_lab_credentials: false,
      status: 'pending'
    )

    order_item = OrderItem.create(
      orderable: event,
      order: order,
      user: User.last,
      sent_webex_invite: false,
      sent_course_material: false,
      sent_lab_credentials: false,
      status: 'pending'
    )
  end
end
