class FixColumnNames < ActiveRecord::Migration[6.0]
  def self.up
    rename_column :reminders, :day, :day_selection
    rename_column :reminders, :hour, :hour_selection
    rename_column :reminders, :minute, :minute_selection
  end
end
