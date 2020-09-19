class AddTimezoneToReminders < ActiveRecord::Migration[6.0]
  def change
    add_column :reminders, :timezone, :string
  end
end
