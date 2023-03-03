#!/usr/bin/env ruby

require "optparse"

def main
  options = {}

  OptionParser.new do |opts|
    opts.banner = "Usage: summarize-meeting.rb [options] input-file"

    opts.on("-h", "--help", "Prints this help") do
      puts opts
      exit
    end
  end.parse!

  if ARGV.length != 1
    puts "Error: You must specify a transcript file to summarize."
    exit 1
  end

  transcript_file = ARGV[0]
  transcript = File.read(transcript_file)

  puts "The transcript is:"
  puts transcript
end

if __FILE__ == $0
  main
end
