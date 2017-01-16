class RemoveJobParams < ActiveRecord::Migration
  def change
	remove_column :jobs,:params,:string
  end
end
