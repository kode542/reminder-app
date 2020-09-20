module RemindersHelper
    include ActiveSupport

    def options_for_days
        ( 1..31 ).map { |day| [ day ] }
    end

    def options_for_hours
        ( 0..23 ).map { |hour| [ format( '%02d', hour ) ] }
    end

    def options_for_minutes
        ( 0..59 ).map { |min| [ format( '%02d', min ) ] }
    end

    def options_for_months
        [[ 'Day of the month', 'day_of_month'], ['Last day of the month', 'last_day_of_month']]
    end


    def format_date( params )
        # Set Reminder timezone
        timezone = "UTC"

        days_in_month = Time::COMMON_YEAR_DAYS_IN_MONTH

        current_year = DateTime.current.year
        current_month = DateTime.current.month
        current_day = DateTime.current.day
        current_hour = DateTime.current.hour
        current_minute = DateTime.current.minute

        reminder_day = params[ :day_selection ].to_i
        reminder_hour = params[ :hour_selection ].to_i
        reminder_minute = params[ :minute_selection ].to_i

        beginning_of_month = params[ :month_selection ] == 'day_of_month'
        end_of_month = params[ :month_selection ] == 'last_day_of_month'


        if beginning_of_month #Start counting from the beginning of the month

            if reminder_day <= days_in_month[ current_month ] #Reminder day should not exceed the number of days in the current month

                if reminder_minute > current_minute + 10 || reminder_hour > current_hour || reminder_day > current_day #Set Reminder for this month (At least a 10 minute headstart for the job to run)
                    reminder_datetime = DateTime.new( current_year, current_month, reminder_day, reminder_hour, reminder_minute, 00, timezone )
                else #Set Reminder for next month
                    reminder_datetime = DateTime.new( current_year, current_month, reminder_day, reminder_hour, reminder_minute, 00, timezone ).next_month
                end

            else #Reminder day exceeds the number of days in the current month, set last day of the month
                reminder_datetime = DateTime.new( current_year, current_month, days_in_month[ current_month ], reminder_hour, reminder_minute, 00, timezone ) #Fallback to last day
            end

        else #Start counting from the end of the month

            if reminder_day <= days_in_month[ current_month ] #Reminder day should not exceed the number of days in the current month

                reverse_day = reminder_day * -1
                remaining_month_days = days_in_month[ current_month ] - current_day + 1 #Including the current day

                if reminder_minute > current_minute + 10 || reminder_hour > current_hour || reminder_day <= remaining_month_days #Set Reminder for this month (At least a 10 minute headstart for the job to run)
                    reminder_datetime = DateTime.new( current_year, current_month, reverse_day, reminder_hour, reminder_minute, 00, timezone )
                else #Set Reminder for next month
                    reminder_datetime = DateTime.new( current_year, current_month, reverse_day, reminder_hour, reminder_minute, 00, timezone ).next_month
                end

            else #Reminder day exceeds the number of days in the current month, set last day of the month
                max_reverse_day = days_in_month[ current_month ] * -1

                reminder_datetime = DateTime.new( current_year, current_month, max_reverse_day, reminder_hour, reminder_minute, 00, timezone, timezone ) # Fallback to last reverse day
            end

        end

    end
end
