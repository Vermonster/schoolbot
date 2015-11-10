class ApplicationMailer < ActionMailer::Base
  default from: "SchoolBot <no-reply@#{ENV.fetch('APPLICATION_HOST')}>"
end
