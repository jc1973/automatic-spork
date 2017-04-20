#!/opt/chefdk/embedded/bin/ruby

require 'json'

file = File.read('pipelines/test-gocd.gopipeline.json')
pipeline = JSON.parse(file)

#puts pipeline

#puts pipeline['materials'].first
pipeline['materials'].each do |material|
  puts material['type']
end


