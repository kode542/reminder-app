class ReminderMailer < ApplicationMailer

    default from: 'postmaster@sandboxdb966cca236c49d499292f3fc4596abf.mailgun.org'

    def created(title, email_to)
        @title = title
        mail(to: email_to, subject: "Your #{@title} reminder, the time has come")
    end

    def expires(title, description, date, email_to)
        @title = title
        @description = description
        @date = date
        mail(to: email_to, subject: "Your #{@title} reminder, the time has come")
    end
end
