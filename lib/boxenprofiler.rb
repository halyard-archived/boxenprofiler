require 'boxenprofiler/profiler'

##
# Main BoxenProfiler class
module BoxenProfiler
  class << self
    ##
    # Insert a helper .new() method for creating a new Gem object

    def new(*args)
      self::Profiler.new(*args)
    end
  end
end
