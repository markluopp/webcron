class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :params
      t.string :alert_email
      t.string :status
      t.string :progress # percentage of completion	
      t.timestamp :last_end_at 
      t.timestamp :next_run_at
      t.timestamp :first_run_at
      t.string :frequency
      t.string :job_type
      t.integer :pid #shell process id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
