class Note
  attr_accessor :note_number, :start, :duration

  POSITION_SCALER = 60.0

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

  def color_for_letter
    colors = {
      A: "#FF0000",
      B: "#3642F5",
      C: "#FFF400",
      D: "#FFAB21",
      E: "#81FFF8",
      F: "#E644FF",
      G: "#1EF010"
    }
    colors[note_letter.first.to_sym]
  end

  def fill_style
    fill_color = is_sharp?? "#343434" : color_for_letter
    "background: #{fill_color};"
  end
  def border_style
    if is_sharp?
      "border: 2px solid #{color_for_letter};"
    else
      "border: 1px solid #6F6F6F;"
    end
  end

  def is_sharp?
    note_letter.include?("#")
  end

  def note_letter
    pitches = %w(C C# D D# E F F# G G# A A# B)
    pitches[note_number % 12]
  end

  def to_s
    "#{note_number} at #{start} for #{duration}"
  end

end
