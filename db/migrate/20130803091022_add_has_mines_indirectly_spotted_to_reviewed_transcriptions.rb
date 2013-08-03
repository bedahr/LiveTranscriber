class AddHasMinesIndirectlySpottedToReviewedTranscriptions < ActiveRecord::Migration
  def change
    add_column :reviewed_transcriptions, :has_mines_indirectly_spotted, :boolean
  end
end
