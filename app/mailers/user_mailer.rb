class UserMailer < ActionMailer::Base
  default from: "admin@trinitylistings.com"

  def welcome_email(user)
    @user = user
    @url  = new_user_session
    mail(to: @user.email, subject: 'Welcome to Trinity Listings!')
  end
end
