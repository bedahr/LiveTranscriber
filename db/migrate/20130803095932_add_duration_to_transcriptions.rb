class AddDurationToTranscriptions < ActiveRecord::Migration
  def change
    add_column :transcriptions, :duration, :float
  end
end
