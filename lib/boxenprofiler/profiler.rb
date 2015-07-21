##
# Profile runtime definitions
module BoxenProfiler
  # rubocop:disable Metrics/LineLength
  REGEX_PATTERNS = [
    /^Info: .*(?<class>[^\[]+)\[(?<name>[^\]].+)\]: Evaluated in (?<time>[\d\.]+) seconds$/,
    /^Notice: Compiled (?<class>catalog) .* environment (?<name>[^ ]+) in (?<time>[\d\.]+) seconds$/
  ]
  # rubocop:enable Metrics/LineLength

  DEFAULT_RESULT_COUNT = 100

  ##
  # Profiler runtime class
  class Profiler
    def run!
      results = parse(`#{cmd}`.split("\n"))
      results.sort! { |a, b| b.last <=> a.last }
      write results
    end

    private

    def write(results)
      results.lazy.take(DEFAULT_RESULT_COUNT).each do |pclass, name, time|
        puts "#{time} - #{pclass}[#{name}]"
      end
    end

    def parse(lines)
      lines.each_with_object([]) do |line, acc|
        next unless REGEX_PATTERNS.find { |pattern| line.match(pattern) }
        pclass, name, time = Regexp.last_match[1..3]
        time = time.to_f
        acc << [pclass, name, time]
      end
    end

    def command
      'boxen --profile'
    end
  end
end
