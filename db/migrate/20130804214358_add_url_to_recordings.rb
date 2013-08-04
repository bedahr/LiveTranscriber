class AddURLToRecordings < ActiveRecord::Migration
  def change
    add_column :recordings, :url, :text
  end
end
