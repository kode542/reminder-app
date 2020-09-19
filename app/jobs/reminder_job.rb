class ReminderJob < ApplicationJob

  after_perform do |job|
    # invoke another job at your time of choice
    self.class.set(:wait => 5.minutes).perform_later()
  end

  def perform()
    # search db for dates within a timeframe of 5 minutes
    reminders = Reminder.where("date >= ? AND date <= ?", DateTime.now, (DateTime.now + 10.minutes))

    reminders do |reminder|
      ReminderMailer.reminder_expires(reminder.title, reminder.description, reminder.date, reminder.user.email).deliver

      # Format the next date
      user_selection = {
        :timezone => reminder.timezone,
        :day_selection => reminder.day,
        :hour_selection => reminder.hour,
        :minute_selection => reminder.minute,
        :month_selection => reminder.start_from
      }

      new_date = format_date( user_selection )

      reminder.date = new_date
      reminder.save

    end
  end

end
