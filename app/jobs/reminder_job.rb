class ReminderJob < ApplicationJob

  def perform
    reschedule_job

    reminder_job_logic
  end

  def reminder_job_logic
    # search db for dates within a timeframe of 5 minutes
    reminders = Reminder.where("date >= ? AND date <= ?", DateTime.current, (DateTime.current + ENV['HOURS'].to_i.hours)) rescue nil

    if reminders
      reminders.each do |reminder|
        date = reminder.date
        timezone = reminder.timezone

        if date >= DateTime.current && date <= DateTime.current + 5.minutes
          ReminderMailer.expires(reminder.title, reminder.description, reminder.date, reminder.user.email).deliver_later

          # Format the next date
          user_selection = {
            :day_selection => reminder.day_selection,
            :hour_selection => reminder.hour_selection,
            :minute_selection => reminder.minute_selection,
            :month_selection => reminder.month_selection
          }

          new_date = ApplicationController.helpers.format_date( user_selection )

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