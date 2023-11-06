class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.dig(:gmail, :user_name)
  layout "mailer"
end
