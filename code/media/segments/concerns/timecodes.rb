module Timecodes

  def start_timecode
    @start_timecode ||= Time.at(start_time).strftime('%M:%S.%3N')
  end

  def end_timecode
    @end_timecode ||= Time.at(end_time).strftime('%M:%S.%3N')
  end


end
