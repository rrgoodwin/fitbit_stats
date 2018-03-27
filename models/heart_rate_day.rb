require 'rails' # TODO
require_relative 'day_from_json'

class HeartRateDay < DayFromJson
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

  def dataset
    @dataset ||= @json["activities-heart-intraday"]["dataset"]
    @dataset
  end

  def heart_rate_csv
    day = @json["activities-heart"].first["dateTime"]
    dataset.map {|hr| "#{day} #{hr["time"]},#{hr["value"]}"}.join("\n")
  end

  def csv
    day = @json["activities-heart"].first["dateTime"]
    dataset.map {|hr| "#{day} #{hr["time"]},#{hr["value"]}"}.join("\n")
  end

  def filename_root
    @filename.scan(/\d{6}/).first
  end
end