class FixColumnName < ActiveRecord::Migration[6.0]
  def self.up
    rename_column :reminders, :start_from, :month_selection
  end
end
