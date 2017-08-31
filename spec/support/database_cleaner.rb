RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do

      FactoryGirl.create :platform
      FactoryGirl.create :page, title: 'Welcome'
      FactoryGirl.create :page, title: 'NterOne Privacy Policy'
      FactoryGirl.create :page, title: 'NterOne Terms and Conditions'

      example.run
    end
  end
end
