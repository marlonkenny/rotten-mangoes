class UserMailer < ActionMailer::Base
  default from: "admin@rottenmangoes.com"

  def account_deleted(user)
    @user = user
    @url  = 'http://www.rottenmangoes.com/'
    mail(to: @user.email, subject: 'Confirmation of deleted account')
  end
end