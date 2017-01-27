Dumper::Agent.start_if(app_key: 'YRNUdfrysGblchEd5h83Yj') do
  Rails.env.production? && Socket.gethostname == 'www.nterone.com'
end

Dumper::Agent.start_if(app_key: '9d5Q5cp9FvYLE3goq13KH6') do
  Rails.env.production? && Socket.gethostname == 'nterone.la'
end

Dumper::Agent.start_if(app_key: 'UnBZTswiW0ZTVu4EWww1Gz') do
  Rails.env.production? && Socket.gethostname == 'www-nterone-ca'
end
