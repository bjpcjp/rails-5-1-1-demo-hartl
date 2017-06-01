class UserMailer < ApplicationMailer

  # listing 11.12

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "account activated"
  end

  def password_reset
    @greeting = "Hi"
    mail to: "to@example.org"
  end
end
