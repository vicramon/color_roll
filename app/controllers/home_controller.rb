class HomeController < ApplicationController

  def index
    @files = Dir.glob(Dir.pwd + '/midi_files/**/*.mid').map do |f|
      { name: File.basename(f, ".mid").humanize, path: f }
    end
  end

  def song
    get_notes
    @grouped_notes = @notes.group_by(&:note_number)
    @measure_pixels = Note::POSITION_SCALER * 4.0
  end

  private

  def get_notes
    # TODO extract and clean up
    @notes = []

    require "midilib"
    seq = MIDI::Sequence.new()
    File.open(params[:file], 'rb') { | file | seq.read(file) }
    @title = seq.name
    @author = ""

    # get primary track
    events = seq.tracks.map(&:events).flatten
    # get all the note on events
    notes = events.select { |event| event.class == MIDI::NoteOn }
    last_note_end = 0

    @ppqn = seq.ppqn.to_f
    @measure_length = @ppqn * 4
    @measure_count = seq.get_measures.count

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
