case Rails.env
when "development"

    Article.destroy_all
    Company.destroy_all
    Category.destroy_all
    Cart.destroy_all
    Course.destroy_all
    Event.destroy_all
    LabRental.destroy_all
    Order.destroy_all
    OrderItem.destroy_all
    Page.destroy_all
    Platform.destroy_all
    Role.destroy_all
    User.destroy_all


    Article.create!(
      page_title: 'Page Title',
      page_description: 'Page Description',
      content: 'Content',
      slug: 'Title',
      kind: 'Kind',
      title: 'Title'
    )


    c1 = Company.create!(
          title: "Company One")

    c2 = Company.create!(
          title: "Company Two"
          )

    c3 = Company.create!(
        title: "Company Three")

    c4 = Company.create!(
        title: "Company Four")

    c5 = Company.create!(
        title: "Company Five")

    c6 = Company.create!(
        title: "Company Six")

    c7 = Company.create!(
        title: "Company Seven")


    Page.create!([{
      title: 'Welcome',
      content: 'Content',
      page_title: 'Page Title',
      slug: 'welcome',
      static: false,
      page_description: 'Page Description'

    }, {
      title: 'NterOne Privacy Policy',
      content: 'Content',
      page_title: 'Page Title',
      slug: 'welcome',
      static: false,
      page_description: 'Page Description'

    }, {
      title: 'NterOne Terms and Conditions',
      content: 'Content',
      page_title: 'Page Title',
      slug: 'welcome',
      static: false,
      page_description: 'Page Description'

    }, {
      title: 'About NterOne',
      content: 'Content',
      page_title: 'Page Title',
      slug: 'welcome',
      static: false,
      page_description: 'Page Description'

    }, {
      title: 'Executive Bios',
      content: 'Content',
      page_title: 'Page Title',
      slug: 'welcome',
      static: false,
      page_description: 'Page Description'

    }, {
      title: 'Instructor Bios',
      content: 'Content',
      page_title: 'Page Title',
      slug: 'welcome',
      static: false,
      page_description: 'Page Description'

    }, {
      title: 'Press Index',
      content: 'Content',
      page_title: 'Page Title',
      slug: 'welcome',
      static: false,
      page_description: 'Page Description'

    }, {
      title: 'Blog Index',
      content: 'Content',
      page_title: 'Page Title',
      slug: 'welcome',
      static: false,
      page_description: 'Page Description'

    }, {
      title: 'Industry Index',
      content: 'Content',
      page_title: 'Page Title',
      slug: 'welcome',
      static: false,
      page_description: 'Page Description'

    }, {
      title: 'Consulting',
      content: 'Content',
      page_title: 'Page Title',
      slug: 'welcome',
      static: false,
      page_description: 'Page Description'

    }, {
      title: 'Partners',
      content: 'Content',
      page_title: 'Page Title',
      slug: 'welcome',
      static: false,
      page_description: 'Page Description'

    }, {
      title: 'Labs',
      content: 'Content',
      page_title: 'Page Title',
      slug: 'welcome',
      static: false,
      page_description: 'Page Description'

    }, {
      title: 'NterOne Gives Back',
      content: 'Content',
      page_title: 'Page Title',
      slug: 'welcome',
      static: false,
      page_description: 'Page Description'

    }, {
      title: 'Featured Classes',
      content: 'Content',
      page_title: 'Page Title',
      slug: 'welcome',
      static: false,
      page_description: 'Page Description'

    }, {
      title: 'Sitemap',
      content: 'Content',
      page_title: 'Page Title',
      slug: 'welcome',
      static: false,
      page_description: 'Page Description'

    }, {
      title: 'Vendor Index',
      content: 'Content',
      page_title: 'Page Title',
      slug: 'welcome',
      static: false,
      page_description: 'Page Description'

    }, {
      title: 'Testimonials',
      content: 'Content',
      page_title: 'Page Title',
      slug: 'welcome',
      static: false,
      page_description: 'Page Description'

    }
    ])


    pf = Platform.create!(
      title: "Platform One",
      url: "platformoneurl.com",
      slug: "platform-one-slug",
      page_title: "Platform One Page Title",
      page_description: "Platform One Page Description"
    )

    cat = Category.create!(
      platform_id: pf.id,
      title: "Category One",
      slug: "category-one-slug",
      description: "Description",
      page_title: "Category One Page Title",
      heading: "Heading"
    )

    crs1 = Course.new(
      title: "Course One",
      platform_id: pf.id,
      active: true,
      abbreviation: "Course 1",
      intro: "Intro",
      overview: "Overview",
      outline: "Outline",
      intended_audience: "Intended Audience",
      slug: "course-one-slug",
      page_title: "Course One Page Title",
      page_description: "Course One Page Description",
      partner_led: false,
      heading: "Heading"
    )
    crs1.save!(validate: false)

    CategoryCourse.create!(
      category_id: cat.id,
      course_id: crs1.id
    )

    crs2 = Course.new(
      title: "Course Two",
      platform_id: pf.id,
      active: true,
      abbreviation: "Course 2",
      intro: "Intro",
      overview: "Overview",
      outline: "Outline",
      intended_audience: "Intended Audience",
      slug: "course-one-slug",
      page_title: "Course One Page Title",
      page_description: "Course One Page Description",
      partner_led: false,
      heading: "Heading"
    )
    crs2.save!(validate: false)

    CategoryCourse.create!(
      category_id: cat.id,
      course_id: crs2.id
    )

    crs3 = Course.new(
      title: "No Cart",
      platform_id: pf.id,
      active: true,
      abbreviation: "Course 3",
      intro: "Intro",
      overview: "Overview",
      outline: "Outline",
      intended_audience: "Intended Audience",
      slug: "course-one-slug",
      page_title: "Course One Page Title",
      page_description: "Course One Page Description",
      partner_led: false,
      heading: "Heading"
    )
    crs3.save!(validate: false)

    CategoryCourse.create!(
      category_id: cat.id,
      course_id: crs3.id
    )

    crs4 = Course.new(
      title: "No Cart",
      platform_id: pf.id,
      active: true,
      abbreviation: "Course 4",
      intro: "Intro",
      overview: "Overview",
      outline: "Outline",
      intended_audience: "Intended Audience",
      slug: "course-one-slug",
      page_title: "Course One Page Title",
      page_description: "Course One Page Description",
      partner_led: false,
      heading: "Heading"
    )
    crs4.save!(validate: false)

    CategoryCourse.create!(
      category_id: cat.id,
      course_id: crs4.id
    )

    e1 = Event.new(
      start_date: Time.now,
      end_date: Time.now,
      format: "Format",
      price: 1000.50,
      course_id: crs1.id,
      start_time: Time.now,
      end_time: Time.now
    )
    e1.save!(validate: false)

    e2 = Event.new(
      start_date: Time.now,
      end_date: Time.now,
      format: "Format",
      price: 1000.50,
      course_id: crs2.id,
      start_time: Time.now,
      end_time: Time.now
    )
    e2.save!(validate: false)

    e3 = Event.new(
      start_date: Time.now,
      end_date: Time.now,
      format: "Format",
      price: 1000.50,
      course_id: crs3.id,
      start_time: Time.now,
      end_time: Time.now
    )
    e3.save!(validate: false)

    e4 = Event.new(
      start_date: Time.now,
      end_date: Time.now,
      format: "Format",
      price: 1000.50,
      course_id: crs4.id,
      start_time: Time.now,
      end_time: Time.now
    )
    e4.save!(validate: false)
    #
    #
    # u1 = User.create!(
    #     first_name: 'Admin',
    #     last_name: 'Test',
    #     email: 'admin@test.com',
    #     password: 'Test123',
    #     company_name: c1.title,
    #     company_id: c1.id
    #     )
    #
    #     Role.create!(
    #     user_id: u1.id,
    #     role: 1
    #     )
    #
    #     LabRental.create!(
    #       first_day: 3530421,
    #       start_time: Time.now,
    #       num_of_students: 10,
    #       instructor: "Instructor",
    #       instructor_email: "instructor@test.com",
    #       instructor_phone: "555.555.5555",
    #       notes: "Notes Notes Notes",
    #       location: "Location",
    #       confirmed: 1,
    #       course: "Course One",
    #       user_id: u1.id,
    #       company_id: c1.id,
    #       canceled: 0
    #     )
    #
    #
    # u2 = User.create!(
    #     first_name: 'Salesmanager',
    #     last_name: 'Test',
    #     email: 'salesmanager@test.com',
    #     password: 'Test123',
    #     company_name: c2.title,
    #     company_id: c2.id
    #     )
    #
    #     Role.create!(
    #     user_id: u2.id,
    #     role: 2
    #     )
    #
    #     LabRental.create!(
    #       first_day: 3530421,
    #       start_time: Time.now,
    #       num_of_students: 10,
    #       instructor: "Instructor",
    #       instructor_email: "instructor@test.com",
    #       instructor_phone: "555.555.5555",
    #       notes: "Notes Notes Notes",
    #       location: "Location",
    #       confirmed: 1,
    #       course: "Course Two",
    #       user_id: u2.id,
    #       company_id: c2.id,
    #       canceled: 0
    #     )
    #
    #
    #
    # u3 = User.create!(
    #     first_name: 'Salesrep',
    #     last_name: 'Test',
    #     email: 'salesrep@test.com',
    #     password: 'Test123',
    #     company_name: c3.title,
    #     company_id: c3.id
    #     )
    #
    #     Role.create!(
    #     user_id: u3.id,
    #     role: 3
    #     )
    #
    #     LabRental.create!(
    #       first_day: 3530421,
    #       start_time: Time.now,
    #       num_of_students: 10,
    #       instructor: "Instructor",
    #       instructor_email: "instructor@test.com",
    #       instructor_phone: "555.555.5555",
    #       notes: "Notes Notes Notes",
    #       location: "Location",
    #       confirmed: 1,
    #       course: "Course Three",
    #       user_id: u3.id,
    #       company_id: c3.id,
    #       canceled: 0
    #     )
    #
    #
    # u4 = User.create!(
    #     first_name: 'Member',
    #     last_name: 'Test',
    #     email: 'member@test.com',
    #     password: 'Test123',
    #     company_name: c4.title,
    #     company_id: c4.id
    #     )
    #
    #     Role.create!(
    #     user_id: u4.id,
    #     role: 4
    #     )
    #
    #     LabRental.create!(
    #       first_day: 3530421,
    #       start_time: Time.now,
    #       num_of_students: 10,
    #       instructor: "Instructor",
    #       instructor_email: "instructor@test.com",
    #       instructor_phone: "555.555.5555",
    #       notes: "Notes Notes Notes",
    #       location: "Location",
    #       confirmed: 1,
    #       course: "Course Four",
    #       user_id: u4.id,
    #       company_id: c4.id,
    #       canceled: 0
    #     )
    #
    #
    # u5 = User.create!(
    #     first_name: 'Lmsmanager',
    #     last_name: 'Test',
    #     email: 'lmsmanager@test.com',
    #     password: 'Test123',
    #     company_name: c5.title,
    #     company_id: c5.id
    #     )
    #
    #     Role.create!(
    #     user_id: u5.id,
    #     role: 5
    #     )
    #
    #     LabRental.create!(
    #       first_day: 3530421,
    #       start_time: Time.now,
    #       num_of_students: 10,
    #       instructor: "Instructor",
    #       instructor_email: "instructor@test.com",
    #       instructor_phone: "555.555.5555",
    #       notes: "Notes Notes Notes",
    #       location: "Location",
    #       confirmed: 1,
    #       course: "Course Five",
    #       user_id: u5.id,
    #       company_id: c5.id,
    #       canceled: 0
    #     )
    #
    #
    # u6 = User.create!(
    #     first_name: 'Lmsstudent',
    #     last_name: 'Test',
    #     email: 'lmsstudent@test.com',
    #     password: 'Test123',
    #     company_name: c6.title,
    #     company_id: c6.id
    #     )
    #
    #     Role.create!(
    #     user_id: u6.id,
    #     role: 6
    #     )
    #
    #     LabRental.create!(
    #       first_day: 3530421,
    #       start_time: Time.now,
    #       num_of_students: 10,
    #       instructor: "Instructor",
    #       instructor_email: "instructor@test.com",
    #       instructor_phone: "555.555.5555",
    #       notes: "Notes Notes Notes",
    #       location: "Location",
    #       confirmed: 1,
    #       course: "Course Six",
    #       user_id: u6.id,
    #       company_id: c6.id,
    #       canceled: 0
    #     )
    #
    #
    #  u7 = User.create!(
    #      first_name: 'Instructor',
    #      last_name: 'Test',
    #      email: 'instructor@test.com',
    #      password: 'Test123',
    #      company_name: c7.title,
    #      company_id: c7.id
    #      )
    #
    #      Role.create!(
    #      user_id: u7.id,
    #      role: 7
    #      )
    #
    #      LabRental.create!(
    #        first_day: 3530421,
    #        start_time: Time.now,
    #        num_of_students: 10,
    #        instructor: "Instructor",
    #        instructor_email: "instructor@test.com",
    #        instructor_phone: "555.555.5555",
    #        notes: "Notes Notes Notes",
    #        location: "Location",
    #        confirmed: 1,
    #        course: "Course Seven",
    #        user_id: u7.id,
    #        company_id: c7.id,
    #        canceled: 0
    #      )
    #
    #      cart1 = Cart.create!
    #
    #      o1 = Order.create!(
    #        auth_code: "Auth_Code",
    #        first_name: "First Name",
    #        last_name: "Last Name",
    #        shipping_street: "Shipping Street",
    #        shipping_city: "Shipping City",
    #        shipping_state: "Shipping State",
    #        shipping_zip_code: "Shipping Zip Code",
    #        shipping_country: "Shipping Country",
    #        email: "E-Mail",
    #        clc_number: "CLC Number",
    #        billing_name: "Billing Name",
    #        billing_zip_code: "Billing Zip Code",
    #        paid: 100.00,
    #        billing_street: "Billing Street",
    #        billing_city: "Billing City",
    #        billing_state: "Billing State",
    #        seller_id: u1.id,
    #        buyer_id: u4.id,
    #        status: "Status",
    #        total: 200.00,
    #        billing_country: "Billing Country",
    #        payment_type: "Payment Type",
    #        clc_quantity: 5,
    #        billing_first_name: "Billing First Name",
    #        billing_last_name: "Billing Last Name",
    #        shipping_company: "Shipping Company",
    #        billing_company: "Billing Company",
    #        same_addresses: false,
    #        shipping_first_name: "Shipping First Name",
    #        shipping_last_name: "Shipping Last Name",
    #        po_number: "PO Number",
    #        po_paid: 123.45,
    #        verified: false,
    #        invoiced: false,
    #        invoice_number: "Invoice Number",
    #        status_position: 1,
    #        reviewed: false,
    #        balance: 10.10,
    #        referring_partner_email: "Referring Partner E-Mail",
    #        gilmore_order_number: "Gilmore Order Number",
    #        gilmore_invoice: "Gilmore Invoice",
    #        royalty_id: "Royalty ID",
    #      )
    #
    #      OrderItem.create!(
    #        orderable_id: e1.id,
    #        orderable_type: "Event",
    #        cart_id: nil,
    #        price: 200.00,
    #        order_id: o1.id,
    #        user_id: u4.id,
    #        sent_webex_invite: false,
    #        sent_course_material: false,
    #        sent_lab_credentials: false,
    #        status: "Status",
    #        note: "Note Note Note"
    #      )
    #
    #
    #      cart2 = Cart.create!
    #
    #      o2 = Order.create!(
    #        auth_code: "Auth_Code",
    #        first_name: "First Name",
    #        last_name: "Last Name",
    #        shipping_street: "Shipping Street",
    #        shipping_city: "Shipping City",
    #        shipping_state: "Shipping State",
    #        shipping_zip_code: "Shipping Zip Code",
    #        shipping_country: "Shipping Country",
    #        email: "E-Mail",
    #        clc_number: "CLC Number",
    #        billing_name: "Billing Name",
    #        billing_zip_code: "Billing Zip Code",
    #        paid: 100.00,
    #        billing_street: "Billing Street",
    #        billing_city: "Billing City",
    #        billing_state: "Billing State",
    #        seller_id: u1.id,
    #        buyer_id: u4.id,
    #        status: "Status",
    #        total: 200.00,
    #        billing_country: "Billing Country",
    #        payment_type: "Payment Type",
    #        clc_quantity: 5,
    #        billing_first_name: "Billing First Name",
    #        billing_last_name: "Billing Last Name",
    #        shipping_company: "Shipping Company",
    #        billing_company: "Billing Company",
    #        same_addresses: false,
    #        shipping_first_name: "Shipping First Name",
    #        shipping_last_name: "Shipping Last Name",
    #        po_number: "PO Number",
    #        po_paid: 123.45,
    #        verified: false,
    #        invoiced: false,
    #        invoice_number: "Invoice Number",
    #        status_position: 1,
    #        reviewed: false,
    #        balance: 10.10,
    #        referring_partner_email: "Referring Partner E-Mail",
    #        gilmore_order_number: "Gilmore Order Number",
    #        gilmore_invoice: "Gilmore Invoice",
    #        royalty_id: "Royalty ID",
    #      )
    #
    #      OrderItem.create!(
    #        orderable_id: e2.id,
    #        orderable_type: "Event",
    #        cart_id: nil,
    #        price: 200.00,
    #        order_id: o2.id,
    #        user_id: u4.id,
    #        sent_webex_invite: false,
    #        sent_course_material: false,
    #        sent_lab_credentials: false,
    #        status: "Status",
    #        note: "Note Note Note"
    #      )
    #
    #      cart3 = Cart.create!
    #
    #      o3 = Order.create!(
    #        auth_code: "Auth_Code",
    #        first_name: "First Name",
    #        last_name: "Last Name",
    #        shipping_street: "Shipping Street",
    #        shipping_city: "Shipping City",
    #        shipping_state: "Shipping State",
    #        shipping_zip_code: "Shipping Zip Code",
    #        shipping_country: "Shipping Country",
    #        email: "E-Mail",
    #        clc_number: "CLC Number",
    #        billing_name: "Billing Name",
    #        billing_zip_code: "Billing Zip Code",
    #        paid: 100.00,
    #        billing_street: "Billing Street",
    #        billing_city: "Billing City",
    #        billing_state: "Billing State",
    #        seller_id: u1.id,
    #        buyer_id: u4.id,
    #        status: "Status",
    #        total: 200.00,
    #        billing_country: "Billing Country",
    #        payment_type: "Payment Type",
    #        clc_quantity: 5,
    #        billing_first_name: "Billing First Name",
    #        billing_last_name: "Billing Last Name",
    #        shipping_company: "Shipping Company",
    #        billing_company: "Billing Company",
    #        same_addresses: false,
    #        shipping_first_name: "Shipping First Name",
    #        shipping_last_name: "Shipping Last Name",
    #        po_number: "PO Number",
    #        po_paid: 123.45,
    #        verified: false,
    #        invoiced: false,
    #        invoice_number: "Invoice Number",
    #        status_position: 1,
    #        reviewed: false,
    #        balance: 10.10,
    #        referring_partner_email: "Referring Partner E-Mail",
    #        gilmore_order_number: "Gilmore Order Number",
    #        gilmore_invoice: "Gilmore Invoice",
    #        royalty_id: "Royalty ID",
    #      )
    # #
    #      OrderItem.create!(
    #        orderable_id: e3.id,
    #        orderable_type: "Event",
    #        cart_id: cart3.id,
    #        price: 200.00,
    #        order_id: nil,
    #        user_id: nil,
    #        sent_webex_invite: false,
    #        sent_course_material: false,
    #        sent_lab_credentials: false,
    #        status: "Status",
    #        note: "Note Note Note"
    #        )
    #
    #        cart4 = Cart.create!
    #
    #        o4 = Order.create!(
    #          auth_code: "Auth_Code",
    #          first_name: "First Name",
    #          last_name: "Last Name",
    #          shipping_street: "Shipping Street",
    #          shipping_city: "Shipping City",
    #          shipping_state: "Shipping State",
    #          shipping_zip_code: "Shipping Zip Code",
    #          shipping_country: "Shipping Country",
    #          email: "E-Mail",
    #          clc_number: "CLC Number",
    #          billing_name: "Billing Name",
    #          billing_zip_code: "Billing Zip Code",
    #          paid: 100.00,
    #          billing_street: "Billing Street",
    #          billing_city: "Billing City",
    #          billing_state: "Billing State",
    #          seller_id: u1.id,
    #          buyer_id: u4.id,
    #          status: "Status",
    #          total: 200.00,
    #          billing_country: "Billing Country",
    #          payment_type: "Payment Type",
    #          clc_quantity: 5,
    #          billing_first_name: "Billing First Name",
    #          billing_last_name: "Billing Last Name",
    #          shipping_company: "Shipping Company",
    #          billing_company: "Billing Company",
    #          same_addresses: false,
    #          shipping_first_name: "Shipping First Name",
    #          shipping_last_name: "Shipping Last Name",
    #          po_number: "PO Number",
    #          po_paid: 123.45,
    #          verified: false,
    #          invoiced: false,
    #          invoice_number: "Invoice Number",
    #          status_position: 1,
    #          reviewed: false,
    #          balance: 10.10,
    #          referring_partner_email: "Referring Partner E-Mail",
    #          gilmore_order_number: "Gilmore Order Number",
    #          gilmore_invoice: "Gilmore Invoice",
    #          royalty_id: "Royalty ID",
    #        )
    #
    #        OrderItem.create!(
    #          orderable_id: e4.id,
    #          orderable_type: "Event",
    #          cart_id: cart4.id,
    #          price: 200.00,
    #          order_id: nil,
    #          user_id: nil,
    #          sent_webex_invite: false,
    #          sent_course_material: false,
    #          sent_lab_credentials: false,
    #          status: "Status",
    #          note: "Note Note Note"
    #          )


        # i = 0
        #
        # 20.times {
        #
        # i = i + 1
        #
        # c =  Company.create!(
        #       title: "Company #{i.to_s}"
        #       )
        #
        # u =  User.create!(
        #       first_name: "Member #{i.to_s}",
        #       last_name: 'Test',
        #       email: "member#{i.to_s}@test.com",
        #       password: 'Test123',
        #       company_name: c.title,
        #       company_id: c.id
        #       )
        #
        #   Role.create!(
        #       user_id: u.id,
        #       role: 4
        #       )
        # }
end
