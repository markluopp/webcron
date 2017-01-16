class ModifyJobtype2jobtypeId < ActiveRecord::Migration
  def change
	add_column :jobs, :jobtype_id, :integer
	remove_column :jobs, :job_type, :string
  end
end
