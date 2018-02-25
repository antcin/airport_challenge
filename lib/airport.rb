require_relative 'weather'

class Airport
  DEFAULT_CAPACITY = 20
  attr_reader :planes, :capacity, :weather

  def initialize(weather, capacity = DEFAULT_CAPACITY)
    @weather = weather
    @capacity = capacity
    @planes = []

  end

  def instruct_landing(plane)
    raise 'Cannot land. Airport is full' if full?
    raise 'Cannot land due to stormy weather' if stormy?
    @planes << plane
  end

  def instruct_take_off(plane)
    raise 'Cannot take off due to stormy weather' if stormy?
    raise 'Plane cannot take off. Plane at another airport' unless at_airport?(plane)
  end

  private

  def full?
    @planes.size >= @capacity
  end

  def stormy?
    @weather.stormy?
  end

  def at_airport?(plane)
    @planes.include?(plane)
  end
end
