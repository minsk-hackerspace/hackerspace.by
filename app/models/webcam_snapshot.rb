require 'scanf'
require 'date'

class WebcamSnapshot
  attr_reader :time, :filename, :url

  SNAPSHOT_DIR=File.join('public', 'webcam')
  SNAPSHOT_BASE_URL = '/webcam/'
  TZ = 3

  def initialize(filename, time)
    @filename = filename
    @time = time
    @url = SNAPSHOT_BASE_URL + File.basename(filename)
  end

  def self.find_all(sort_by_time=true)
    snapshots = Array.new

    return snapshots unless Dir.exists?(Rails.root.join SNAPSHOT_DIR)

    Dir.foreach(Rails.root.join SNAPSHOT_DIR) do |filename|
      next unless File.file? Rails.root.join(SNAPSHOT_DIR, filename)

      # Filenames are like IMG_chn1_md_20160714232619.jpg
      attrs = filename.scanf("%12s%4d%2d%2d%2d%2d%2d%4s")
      next unless attrs[0] == "IMG_chn1_md_"

      y, m, d, hour, min, sec = attrs[1..-2]

      t = DateTime.new(y, m, d, hour, min, sec, Rational(TZ, 24))
      snapshots << WebcamSnapshot.new(filename, t)
    end
    snapshots.sort! {|a, b| a.time <=> b.time } if sort_by_time
    snapshots
  end


end
