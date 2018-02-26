require 'rails' # TODO
require_relative 'day_from_json'
require_relative '../script/client_utils' # TODO should move these utils to a better place

class SleepDay < DayFromJson
  @filepath = "#{@root_filepath}/data/sleep_json/" # TODO these can be consolidated

  def levels
    @json["sleep"].map {|sleep_json| sleep_json["levels"]["data"]} # TODO what does it mean if there are more than one of these?
  end

  # Dir["data/sleep_json/*json"].map {|filename| json = JSON.parse(File.read(filename))}.map {|json| json["sleep"].map {|sleep_json| sleep_json["levels"]["data"].count rescue -1  } }

end