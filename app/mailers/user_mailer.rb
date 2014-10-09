class UserMailer < ActionMailer::Base
  default from: "admin@trinitylistings.com"

  def welcome_email(user)
    @user = user
    @url  = root_path
    mail(to: @user.email, subject: 'Welcome to Trinity Listings!')
  end
end
