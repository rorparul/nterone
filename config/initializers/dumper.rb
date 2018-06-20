Dumper::Agent.start_if(app_key: 'YRNUdfrysGblchEd5h83Yj') do
  Rails.env.production? && Socket.gethostname == 'www.nterone.com'
end
