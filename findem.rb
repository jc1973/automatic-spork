#!/opt/chefdk/embedded/bin/ruby

require 'find'
require 'json'

pwd = Dir.pwd
files = []

Find.find(pwd) do |path|
  Find.prune if path.include? '.git'
  next unless path.include? '.gopipeline.json'
  next if path.include? 'auto-pr-'
  files << path
end

#puts files
=begin
files.each do |file|
  puts "json file is #{file}"
end
=end

# We have a list of the GoCD json config pipeline files

node = { 'js-identity' => { 'gocd' => { 'server' => { 'scm' => { 'git@github.com:JSainsburyPLC/id-terraform.git' => '0222b5cd-8d08-46de-848f-95668c2a7e5c',
            'git@github.com:JSainsburyPLC/id-chef.git' => '7b4252a6-a7e6-470e-9c0e-f0c2e34683f7',
            'git@github.com:jc1973/musical-meme.git' => '1e229a92-80e2-4fef-b588-1382888d6610',
            'git@github.com:jc1973/bookish-octo-barnacle.git' => 'b02d1bed-c5d5-4ca9-9617-a6ccad5b4bda',
            'git@github.com:jc1973/automatic-spork.git' => 'bb9d6ce2-6019-4440-835d-6bb7a8ee4fef' } } } } }

puts node['js-identity']['gocd']['server']['scm']
files.each do |file|
  config_file = File.read(file)
  pipeline = JSON.parse(config_file)
  pipeline['materials'].each do |material|
    material['scm_id'] = node['js-identity']['gocd']['server']['scm'][material['url']] if material['type'] == 'git'
    material['type'] = 'plugin' if material['type'] == 'git'
    puts material['scm_id']
  end
  puts pipeline
  
end



