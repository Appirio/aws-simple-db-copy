require "aws-sdk"
require "yaml"

ROOT = File.expand_path('../',  __FILE__)
config = YAML.load_file(File.join(ROOT, "config.yml"))

sdb = AWS::SimpleDB.new(
  :access_key_id => config["aws_access_key"],
  :secret_access_key => config["aws_secret_key"])

config["domain_map"].each do |domain|
	unless sdb.domains[domain["source_table"]].exists?
		puts "Table #{src_domain} does not exist... exiting"
		break
	end

	src_domain = sdb.domains[domain["source_table"]]

	# make sure destination table exist
	dtable = domain["destination_table"]
	unless sdb.domains[dtable].exists?
	  puts "Table #{dtable} does not exist... Creating one."
	  sdb.domains.create(dtable)
	end

	dst_domain = sdb.domains[dtable]

	src_items = []

	if domain["where_clause"].empty?
		puts "Getting all items"
		src_items = src_domain.items
	else
		src_items = src_domain.items.where(domain["where_clause"])
	end
	
	puts "Found #{src_items.count} matching items."
	src_items.each do |sitem|
	  puts "  - Copying item #{sitem.name}"
	  ditem = dst_domain.items[sitem.name]
	  sitem.attributes.each do |atr|
	    ditem.attributes[atr.name] = atr.values
	  end
	end
	puts "Table #{dtable} now has #{dst_domain.items.count} items"
end

puts "Done"





