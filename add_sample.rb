require "aws-sdk"
require "yaml"

ROOT = File.expand_path('../',  __FILE__)
config = YAML.load_file(File.join(ROOT, "config.yml"))

sdb = AWS::SimpleDB.new(
  :access_key_id => config["aws_access_key"],
  :secret_access_key => config["aws_secret_key"])

# clear tables first
puts "Clearing #{config["source_table"]} and #{config["destination_table"]} tables"
sdb.domains[config["source_table"]].delete!
sdb.domains[config["destination_table"]].delete!

puts "Creating #{config["source_table"]} table"
domain = sdb.domains.create(config["source_table"])

puts "Adding 10 sample items"
10.times do |i|
  score = rand(100)
  puts "  - Adding item #{i} with score #{score}"
  item = domain.items["person_#{i}"]
  item.attributes[:name] = "name_#{i}"
  item.attributes[:role] = %w(student teacher)
  item.attributes[:score] = score
end

puts "Added #{domain.items.count} items"
puts "Done"