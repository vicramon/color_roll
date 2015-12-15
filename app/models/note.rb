class Note
  attr_accessor :note_number, :start, :duration

  POSITION_SCALER = 40.0

  def initialize(note_number:, start:, duration:)
    self.note_number = note_number
    self.start = start
    self.duration = duration
  end

  def left_pixels
    start * POSITION_SCALER
  end

  def width_pixels
    duration * POSITION_SCALER
  end

  def to_s
    "#{note_number} at #{start} for #{duration}"
  end

end
