# About this
Its goal is to copy from one Amazon SimpleDB table to another table. You can choose items to copy with 'where clause'.


# Setup
It needs ruby(>1.9) and aws-sdk gem.

    gem install aws-sdk

## config
config.yml file is requried. It contains the aws keys along with a map of domains

Example : 

    aws_access_key: "AKIAJDYTLELFKOIKWX2Q"
    aws_secret_key: "lOzEWboR9vyyvQpfrzY2j/KOWNMDDetSdw5DBaFd"
    domain_map:
        -
            source_table: "people"
            destination_table: "students"
            where_clause: "score > '60'"
        -
            source_table: "people2"
            destination_table: "students2"
            where_clause: ""

## Sample Data
For test, you can add sample data by running `add_sample.rb`. It adds 10 sample data to `people` table. 
[Caution] It deletes existing tables first.

    ruby add_sample.rb


# Run

    ruby aws_sdb_copy.rb


Thank you.


*** Licensed under MIT: http://opensource.org/licenses/MIT