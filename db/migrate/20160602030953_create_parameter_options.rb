class CreateParameterOptions < ActiveRecord::Migration
  def change
    create_table :parameter_options do |t|
      t.string :param_name
      t.text :param_help
      t.integer :jobtype_id

      t.timestamps null: false
    end
  end
end
