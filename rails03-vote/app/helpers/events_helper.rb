module EventsHelper
  def sample_schedules
    t = Time.now
    dates = []
    3.times do
      t += 1.day + 1.hour
      dates += [t.strftime("%m/%d %H:00")]
    end
    dates.join(", ")
  end
end
