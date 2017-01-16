class AddExecutionTime2histories < ActiveRecord::Migration
  def change
    add_column :histories, :execution_time, :integer
  end
end
