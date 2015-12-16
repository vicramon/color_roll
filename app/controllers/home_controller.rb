class HomeController < ApplicationController

  def index
    # split out notes by key lines
    # send those notes to the keyline
    # position them horizontally (left, width)
    get_notes
    @grouped_notes = @notes.group_by(&:note_number)
  end

  private

  def get_notes
    # TODO extract and clean up
    @notes = []

    require "midilib"
    seq = MIDI::Sequence.new()
    File.open('midi_files/moonlight_sonata.mid', 'rb') { | file | seq.read(file) }

    # get primary track
    track = seq.tracks.last
    # get all the note on events
    notes = track.events.select { |event| event.class == MIDI::NoteOn }
    last_note_end = 0

    @ppqn = seq.ppqn.to_f
    @measure_length = @ppqn * 4

    notes.each do |note|
      duration = scale(note.off.time_from_start - note.time_from_start)
      start = scale(note.time_from_start)
      puts "#{note.note} at #{start} for #{duration}"
      @notes << Note.new(note_number: note.note, start: start, duration: duration)
      last_note_end = [last_note_end, note.off.time_from_start].max
    end
    @last_note_end = last_note_end
    puts "Song ends at #{last_note_end}"
  end

  def scale(number)
    (number / @ppqn).round(2)
  end

end
