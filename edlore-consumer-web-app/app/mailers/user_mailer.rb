class UserMailer < ActionMailer::Base
  default from: "admin@edlore.com"
  #send forgot passord link to user
  def forgot_password(user)
    @user = user
    mail(to: @user.email, subject: 'New Password')
  end
  #send password while creating expert
  def send_expert_password(user)
    @expert = user
    mail(to: @expert.email, subject: 'New Password')
  end
  #send invoice mail to consumer and experts
  def invoice_mail(user,job)
    @user = user
    @job = job
    mail(to: @user.email, subject: 'Job Invoice')
  end
end
