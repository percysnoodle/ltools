#!/usr/bin/ruby

require 'xcodeproj'
require 'ruby-debug'

def find_files group, path, regex
  files = []

  group_path = case group.source_tree
    when '<group>' then File.join(path, group.path.to_s)
    else group.path.to_s
  end

  group.children.each do |child|
    case child

      when Xcodeproj::Project::Object::PBXVariantGroup
        if child.name.match regex
          lprojs = child.children.map {|c| c.name + '.lproj'}
          lprojs.each do |l|
            files << File.join(group_path, l, child.name)
          end
        end

      when Xcodeproj::Project::Object::PBXGroup
        group_files = find_files(child, group_path, regex)
        files.concat group_files
  
      when Xcodeproj::Project::Object::PBXFileReference
        if child.path.match regex
          files << File.join(group_path, child.path)
        end

    end
  end

  files
end

proj = Xcodeproj::Project.new ARGV[0]

source_files = find_files proj.root_object.main_group, '.', /\.[hm]$/
source_file_strings = Set.new

source_files.each do |path|
  File.open(path) do |f|
    f.read.scan /(?<=L\(@)[^)]*|(?<=LU\(@)[^)]*|(?<=LF\(@)[^,]*/ do |match|
      source_file_strings << match.to_s
    end
  end
end

string_files = find_files proj.root_object.main_group, '.', /^Localizable\.strings$/
missing_strings_count = 0

string_files.each do |path|
  string_file_strings = Set.new

  File.open(path) do |f|
    f.read.scan /^"[^"]*"/ do |match|
      string_file_strings << match.to_s
    end
  end

  source_not_strings = (source_file_strings - string_file_strings)
  if source_not_strings.count > 0
    puts "In source but not #{path}:"
    puts source_not_strings.to_a
    puts
  end

  strings_not_source = (string_file_strings - source_file_strings)
  if strings_not_source.count > 0
    puts "In strings but not source:"
    puts strings_not_source.to_a
    puts
  end

  missing_strings_count += source_not_strings.count
end

exit missing_strings_count
