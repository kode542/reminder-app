class ReminderJob < ApplicationJob

  def perform
    reschedule_job

    reminder_job_logic
  end

  def reminder_job_logic
    # search db for dates within a timeframe of 5 minutes
    reminders = Reminder.where("date >= ? AND date <= ?", DateTime.now, (DateTime.now + 10.minutes)) rescue nil

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

  def reschedule_job
    self.class.set(wait: 5.minutes).perform_later
  end


end
