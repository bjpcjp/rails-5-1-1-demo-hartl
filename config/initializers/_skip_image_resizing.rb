# listing 13.68 
# allows test suite to skip image resizing (if needed)

if Rails.env.test?
  CarrierWave.configure do |config|
    config.enable_processing = false
  end
end