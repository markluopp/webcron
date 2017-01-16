class RemoveJobtypeParamsStd < ActiveRecord::Migration
  def change
    remove_column :jobtypes, :params_std, :text
  end
end
