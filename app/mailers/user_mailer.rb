class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t(".content2")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t(".content3")
  end
end
