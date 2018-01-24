# encoding: utf-8
# -*- SkipSchemaAnnotations

class SpaceAPIEndpoint
  DEFAULT_DATA = {
    api: "0.13",
    space: "Example Hackerspace",
    logo: "http://example.com/logo.png",
    url: "http://example.com",
    location: {
      address: "Nowhere",
      lon: 42,
      lat: 42,
    },
    contact: {
      ml: "hackerspacek@example.com",
    },

    issue_report_channels: [:ml],

    state: {
      open: nil,
    },
    sensors: {
      people_now_present: [{
        value: 0,
      }]
    }
  }

  def initialize
    @data = DEFAULT_DATA.merge Rails.configuration.spaceapi_data
  end

  def to_json(options)
    @data.to_json(options)
  end

  def [](key)
    @data[key]
  end

  def []=(key, value)
    @data[key] = value
  end
end
