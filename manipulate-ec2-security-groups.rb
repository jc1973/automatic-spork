#!/opt/chefdk/embedded/bin/ruby

require 'optparse'
require 'json'

#data_bag = JSON.parse(`knife data bag show -Fj gocd orchestrate`)

# This hash will hold all of the options
# parsed from the command-line by
# OptionParser.
options = {}
exit_status = 0

optparse = OptionParser.new do |opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner = 'Usage: manipulate-ec2-security-groups.rb [options]'

  # Define the options, and what they do

  options['group'] = ''
  opts.on('-g', '--group-name group-name|group-id', 'Security group to manipulate (name or id)') do |group|
    options['group'] = group
  end

  options['source'] = ''
  opts.on('-s', '--source-group-id source-group-id', 'Source group ID') do |source|
    options['source'] = source
  end

  options['protocol'] = 'tcp'
  opts.on('-p', '--protocol protocol', 'Protocal (default tcp)') do |protocol|
    options['protocol'] = protocol
  end

  options['dport'] = ''
  opts.on('-d', '--dport port', 'Destination port') do |dport|
    options['dport'] = dport
  end

  options['action'] = ''
  opts.on('-a', '--action permit|revoke', 'Action - must be either: permit | revoke') do |action|
    options['action'] = action
  end

  # This displays the help screen, all programs are
  # assumed to have this option.
  opts.on('-h', '--help', 'Display this screen') do
    puts opts
    exit
  end
end

# Parse the command-line. Remember there are two forms
# of the parse method. The 'parse' method simply parses
# ARGV, while the 'parse!' method parses ARGV and removes
# any options found there, as well as any parameters for
# the options. What's left is the list of files to resize.
optparse.parse!

# let's make sure that we have no empty options
options.keys.sort.each do |k|
  if options[k] == '' 
    puts "#{k} cannot be empty"
#    exit_status ++ this does not work in ruby
    exit_status += 1
    else 
    puts "#{k} = #{options[k]}"
  end
end

#if exit_status > 0
#  exit exit_status
#end

puts options['group']

# Lets find the group id
if options['group'] =~ /^sg-\h{8}$/
  groupid = options['group']
else
  group = options['group']
  puts "aws ec2 describe-security-groups --filters Name=group-name,Values='#{group}'`"
  find_group = JSON.parse(`aws ec2 describe-security-groups --filters Name=group-name,Values='#{group}'`)
  if find_group['SecurityGroups'].count != 1 
    puts 'Need to match one security group only'
    puts 'found ' + find_group['SecurityGroups'].count.to_s
    puts find_group['SecurityGroups']
    exit 1;
  end
  groupid = find_group['SecurityGroups'][0]['GroupId']
end
  
if options['source'] =~ /^sg-\h{8}$/
  sourceid = options['source']
else  
  puts 'source-group-id does not appear to be correct'
  exit 1
end

protocol = options['protocol']

if options['dport'] =~ /\D+/
  puts 'Destination port must be numeric'
  exit 1
end

unless ( options['action'] == 'permit' || options['action'] == 'revoke' ) 
  puts 'Action must be either permit or revoke'
  exit 1
end
