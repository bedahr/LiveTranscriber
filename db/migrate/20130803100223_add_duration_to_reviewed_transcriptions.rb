class AddDurationToReviewedTranscriptions < ActiveRecord::Migration
  def change
    add_column :reviewed_transcriptions, :duration, :float
  end
end
