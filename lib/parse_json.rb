require 'json'
require 'pathname'

def parse_json(file_path)
  path = Pathname(__FILE__).dirname.parent + file_path
  File.readlines(path).map{|l| JSON.parse(l)}
end