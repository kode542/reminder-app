class ReminderJob < ApplicationJob

  def perform
    reschedule_job

    reminder_job_logic
  end

  def reminder_job_logic
    # search db for dates within a timeframe of 5 minutes
    reminders = Reminder.where("date >= ? AND date <= ?", Time.now, (Time.now + 1.day)) rescue nil

    if reminders
      reminders.each do |reminder|
        date = reminder.date
        timezone = reminder.timezone

        if date >= Time.now.in_time_zone(timezone) && date <= Time.now.in_time_zone(timezone) + 5.minutes
          ReminderMailer.expires(reminder.title, reminder.description, reminder.date, reminder.user.email).deliver

          # Format the next date
          user_selection = {
            :timezone => reminder.timezone,
            :day_selection => reminder.day_selection,
            :hour_selection => reminder.hour_selection,
            :minute_selection => reminder.minute_selection,
            :month_selection => reminder.month_selection
          }

          new_date = format_date( user_selection )

          reminder.date = new_date
          reminder.save
        end
      end
    end
  end

  def reschedule_job
    self.class.set(wait: 5.minutes).perform_later
  end
end