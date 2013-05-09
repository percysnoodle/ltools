#!/usr/bin/ruby

if ARGV.length < 1
  puts "usage: L2csv {folder containing lproj dirs} > strings.csv"
  exit 1
end

require 'csv'

def parse_strings_file path
  
  strings = {}
  in_comment = false

  File.open(path) do |file|
    file.each_line do |line|
      
      if in_comment
        in_comment = false if line.match /\*\//
      else
        if (line.match /^\/\*/) && !(line.match /\*\//)
          in_comment = true
        elsif match = line.match(/\"((\\\"|[^"])+)\"\s*=\s*\"((\\\"|[^"])+)\"/)
          strings[match[1]] = match[3]
        end
      end

    end
  end

  strings

end

pattern = File.join ARGV[0], '*.lproj'

langs = []
strings = {}

Dir.glob(pattern).each do |path|

  strings_file_path = File.join path, 'Localizable.strings'

  next unless File.file? strings_file_path

  lang = File.basename path, '.lproj'
  langs << lang

  parse_strings_file(strings_file_path).each do |key, value|

    strings[key] ||= {}
    strings[key][lang] = value

  end

end

CSV($stdout) do |csv|

  header_line = ["language"]
  header_line += langs
  csv << header_line

  strings.each do |key, value|
        
    csv_line = [key]
    langs.each do |lang|
      csv_line << value[lang]
    end

    csv << csv_line

  end

end
