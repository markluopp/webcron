class AddCallScript2jobtypes < ActiveRecord::Migration
  def change
    add_column :jobtypes, :call_script, :string
  end
end
