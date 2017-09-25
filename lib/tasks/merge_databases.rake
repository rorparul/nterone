require 'objspace'

begin
  class << Platform
    remove_method :import
  end
rescue Exception => e
end

require 'activerecord-import'

namespace "merge" do
  task :databases, [:database] => [:environment] do |t, args|

    @database = args[:database].to_sym

    Db::MergeService.new(@database).call

  end
end


