class CreateJobtypes < ActiveRecord::Migration
  def change
    create_table :jobtypes do |t|
      t.string :jobtype_name
      t.string :params_std

      t.timestamps null: false
    end
  end
end
