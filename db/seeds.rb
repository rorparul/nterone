member        = User.create(email: 'member@mail.com',        password: 'password')
sales         = User.create(email: 'sales@mail.com',         password: 'password')
sales_manager = User.create(email: 'sales_manager@mail.com', password: 'password')
brand_admin   = User.create(email: 'brand_admin@mail.com',   password: 'password')
super_admin   = User.create(email: 'super_admin@mail.com',   password: 'password', admin: true)

case Rails.env
when "development"
  Brand.create(title: "Example", url: 'example.com')

  brand = Brand.create(title: 'localhost' , url: 'localhost', header: 'localhost')
  brand.create_logo

  BrandUser.create([{ user_id: member.id,        brand_id: brand.id, role: :member },
                    { user_id: sales.id,         brand_id: brand.id, role: :sales },
                    { user_id: sales_manager.id, brand_id: brand.id, role: :sales_manager },
                    { user_id: brand_admin.id,   brand_id: brand.id, role: :brand_admin }])

  platforms = brand.platforms.create([{title: 'test platform 1'}, {title: 'test platform 2'}])
  platforms.each do |platform|
    platform.categories.create([{title: "category 1 for platform #{platform.id}"},
                                {title: "category 2 for platform #{platform.id}"}])
  end

  Category.first.subjects.create(title: 'aaa', description: 'bbbbb')

  # For testing on NterOne servers
  emails = ['kirk@nterone.com', 'anthony@nterone.com', 'brandon@nterone.com']
  nter_brand = Brand.create(title: 'NterOne' , url: 'nterone', header: 'NterOne')
  nterone_users = emails.map { |email| User.create(email: email, password: 'changeme') }
  nterone_users.each do |user|
    BrandUser.create(user_id: user.id, brand_id: nter_brand.id, role: :brand_admin)
  end

when "production"
  # nter_brand = Brand.create(title: 'NterOne' , url: 'nci.nterone.com', header: 'NterOne')
  nter_brand = Brand.create(title: 'NterOne' , url: 'nterone-nci-staging.herokuapp.com', header: 'NterOne')
  nter_brand.create_logo

  BrandUser.create([{ user_id: member.id,        brand_id: brand.id, role: :member },
                    { user_id: sales.id,         brand_id: brand.id, role: :sales },
                    { user_id: sales_manager.id, brand_id: brand.id, role: :sales_manager },
                    { user_id: brand_admin.id,   brand_id: brand.id, role: :brand_admin }])

  # For testing on NterOne servers
  emails = ['kirk@nterone.com', 'anthony@nterone.com', 'brandon@nterone.com', 'Trevorham22@gmail.com']
  nterone_users = emails.map{ |email| User.create(email: email, password: 'changeme') }
  nterone_users.each do |user|
    BrandUser.create(user_id: user.id, brand_id: nter_brand.id, role: :brand_admin)
  end
end
