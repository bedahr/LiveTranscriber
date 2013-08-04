class AddIsActiveToTranscriptions < ActiveRecord::Migration
  def change
    add_column :transcriptions, :is_active, :boolean
  end
end
