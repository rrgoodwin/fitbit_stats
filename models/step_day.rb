require_relative 'day_from_json'
require_relative '../script/get_steps' # TODO consolidate where the boilerplate goes

class StepDay < DayFromJson

  def dataset
    @dataset ||= @json["activities-steps-intraday"]["dataset"]
    @dataset
  end

  def csv
    day = @json["activities-steps"].first["dateTime"]
    dataset.map {|row| "#{day} #{row["time"]},#{row["value"]}"}.join("\n")
  end

end