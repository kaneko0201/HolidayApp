class CreateDays < ActiveRecord::Migration[6.1]
  def change
    create_table :days do |t|
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
