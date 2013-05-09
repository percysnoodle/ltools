#!/usr/bin/ruby

if ARGV.length < 1
  puts "usage: L2csv {folder containing lproj dirs} < strings.csv"
  exit 1
end

require 'csv'

file_handles = nil
folder_path = ARGV[0]

Dir.mkdir(folder_path) unless Dir.exists? folder_path

CSV.parse($stdin) do |csv_line|

  if !file_handles

    file_handles = csv_line[1..-1].map do |lang|
      lproj_path = File.join folder_path, "#{lang}.lproj"
      Dir.mkdir(lproj_path) unless Dir.exists? lproj_path

      file_path = File.join lproj_path, "Localizable.strings"
      File.open(file_path, "w")
    end
    
  else
    
    key = csv_line[0]

    csv_line[1..-1].each_with_index do |value, i|
      value.gsub! '"', '\"'
      file_handles[i].puts "\"#{key}\" = \"#{value}\";"
    end

  end

end

file_handles.each do |file|
  file.close
end
