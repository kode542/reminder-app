class ReminderMailer < ApplicationMailer

    default from: 'app184910795@heroku.com'

    def reminder_expires(title, description, date, email_to)
        @title = title
        @description = description
        @date = date
        mail(to: email_to, subject: "Your #{@title} reminder, the time has come")
    end
end
