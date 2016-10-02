class Heatmap
  attr_reader :on, :off, :days_of_week
  def initialize
    @days_of_week = %w(Mon Tue Wed Thu Fri Sat Sun)
    @on = {}
    @off = {}
    @heatmap = {}
    @days_of_week.each do |day|
      @on[day] = Array.new(24,0)
      @off[day] = Array.new(24,0)
      @heatmap[day] = Array.new(24,0.0)
    end
  end

  def add_on_event(datetime)
    @on[datetime.strftime('%a')][datetime.hour] += 1
    end

  def add_off_event(datetime)
    @off[datetime.strftime('%a')][datetime.hour] += 1
  end

  def heatmap
    @days_of_week.each do |day|
      @heatmap[day].each_index do |hour|
        sum = (@on[day][hour] + @off[day][hour]).to_f
        # p sum
        p (@on[day][hour]/sum * 100.0).round(1)
        @heatmap[day][hour] = sum.zero? ? 0 : (@on[day][hour]/sum * 100.0).round(1)
      end
    end
    @heatmap
  end

  def inspect
    heatmap
  end
end