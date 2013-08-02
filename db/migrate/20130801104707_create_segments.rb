class CreateSegments < ActiveRecord::Migration
  def change
    create_table :segments do |t|
      t.integer :recording_id
      t.float :start_time
      t.float :end_time
      t.string  :body

      t.timestamps
    end

    add_column :words, :segment_id, :integer
  end
end
