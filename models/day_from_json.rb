require 'rails' # TODO

class DayFromJson
  attr_reader :json, :date

  def initialize(date_or_filename)
    if date_or_filename.is_a? String
      @filename = date_or_filename
      @date =  DateTime.parse(@filename.scan(/\d{6}/).first)
    else # date
      @filename = filename_for_date(date_or_filename)
      @date = date_or_filename
    end

    @json = JSON.parse(File.read(@filename))
  end

  def filename_root
    @filename.scan(/\d{6}/).first
  end

  def dataset
    raise "Child class must implement dataset"
  end

  def dataset_hash
    dataset.map {|d| [d["time"], d["value"]]}.to_h
  end

  def max_recorded_time
    dataset.map {|h| h["time"]}.max
  end

end