Dir.glob(File.join(File.dirname(__FILE__), 'api_error', '*.rb')) do |file|
  require file
end
