class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.text :log
      t.integer :job_id

      t.timestamps null: false
    end
  end
end
