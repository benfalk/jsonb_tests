require 'benchmark'

desc 'Run a series of benchmarks against both tables'
task benchmark: :environment do
  require_relative '../user'
  require_relative '../customer'
  bench_both "select count(*) from tablename where details->>'contact_me' = 'true';"
  bench_both "select count(*) from tablename where details->'address'->>'state' = 'IN';"

  bench_compare "JSON count with index",
                'select count(*) from users where details @> \'{"contact_me":true}\';',
                'select count(*) from users where details @> \'{"address":{"state":"IN"}}\';'

  bench_both "select AVG(cast(details->>'age' as integer)) from tablename;"
  bench_both "select DISTINCT(details->'address'->>'state') from tablename;"
  bench_both "select * from tablename limit 10000;"
  bench_compare "JSON WHERE IN versus JSONB",
                "select count(*) from users where details->'address'->'state' ?| array['TN', 'IN'];",
                'select count(*) from users where details @> \'{"address":{"state":"IN"}}\' OR details @> \'{"address":{"state":"TN"}}\';',
                "select count(*) from users where details->'address'->>'state' IN ('TN', 'IN');",
                "select count(*) from customers where details->'address'->>'state' IN ('TN', 'IN');"
end

def bench_both(query)
  config = ActiveRecord::Base.configurations['default']
  sql = "psql -h #{config['host']} -p #{config['port']} jsonb_tests"
  puts ''
  puts "Benching: #{query}"
  %w(users customers).each do |table|
    run = query.gsub(/tablename/, table)
    response = ''
    result = Benchmark.measure do
      response = `echo "#{run.gsub(/"/, '\"')}" | #{sql}`
    end
    puts "   #{run} (took #{result.real} seconds)"
  end
end

def bench_compare(group_name, *queries)
  config = ActiveRecord::Base.configurations['default']
  sql = "psql -h #{config['host']} -p #{config['port']} jsonb_tests"
  puts ''
  puts "Benching: #{group_name}"
  queries.each do |run|
    response = ''
    result = Benchmark.measure do
      response = `echo "#{run.gsub(/"/, '\"')}" | #{sql}`
    end
    puts "   #{run} (took #{result.real} seconds)"
  end
end
