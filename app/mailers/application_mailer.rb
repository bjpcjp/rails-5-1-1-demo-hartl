class ApplicationMailer < ActionMailer::Base
  
  # listing 11.11

  default from: 'noreply@example.com'
  layout 'mailer'
  
end
