class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.integer :recording_id
      t.string :body
      t.float :start_time
      t.float :end_time
      t.float :confidence

      t.timestamps
    end
  end
end
