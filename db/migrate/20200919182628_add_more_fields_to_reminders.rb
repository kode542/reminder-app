class AddMoreFieldsToReminders < ActiveRecord::Migration[6.0]
  def change
    add_column :reminders, :start_from, :string
    add_column :reminders, :day, :integer
    add_column :reminders, :hour, :string
    add_column :reminders, :minute, :string
  end
end
