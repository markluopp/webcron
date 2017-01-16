class JobParams2text < ActiveRecord::Migration
  def change
	remove_column :jobs,:params,:string
	add_column :jobs,:params,:text
  end
end
