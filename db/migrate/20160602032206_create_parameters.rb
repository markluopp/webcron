class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.string :param_name
      t.text :param_value
      t.integer :job_id

      t.timestamps null: false
    end
  end
end
