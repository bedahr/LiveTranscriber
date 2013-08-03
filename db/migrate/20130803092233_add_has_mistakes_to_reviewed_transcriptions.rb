class AddHasMistakesToReviewedTranscriptions < ActiveRecord::Migration
  def change
    add_column :reviewed_transcriptions, :has_mistakes, :boolean
  end
end
