class AddAlternativesToWords < ActiveRecord::Migration
  def change
    add_column :words, :alternatives, :text
  end
end
