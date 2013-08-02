class AddPositionToSegments < ActiveRecord::Migration
  def change
    add_column :segments, :position, :integer

    # Recording.all.each do |recording|
    #   recording.segments.reorder(:created_at).each_with_index do |segment, idx|
    #     segment.update_attribute(:position, idx+1)
    #   end
    # end

  end
end
