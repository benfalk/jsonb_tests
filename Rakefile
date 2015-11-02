require 'bundler/setup'

require 'active_record'

include ActiveRecord::Tasks
load './lib/tasks/add_users.rake'
load './lib/tasks/add_customers.rake'

db_dir = File.expand_path('../db', __FILE__)
config_dir = File.expand_path('../config', __FILE__)

DatabaseTasks.env = ( ENV['ENV'] || 'development' ).to_sym
DatabaseTasks.db_dir = db_dir
DatabaseTasks.database_configuration = YAML.load(File.read(File.join(config_dir, 'database.yml')))
DatabaseTasks.migrations_paths = File.join(db_dir, 'migrate')

task :environment do
  ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection DatabaseTasks.env
end

desc "generate migration"
task :generate_migration, [:migration_class_name] do |t, args|
  migration_class_name = args[:migration_class_name]
  raise "Usage: rake db:generate_migration[MyFantasticMigration]" if migration_class_name.blank?
  timestamp = Time.now.to_s(:number)
  suffix    = migration_class_name.underscore
  migration_dir = File.join(db_dir, 'migrate')
  migration_file_name = [timestamp, suffix].join("_") + ".rb"
  content = <<-EOF
class #{migration_class_name} < ActiveRecord::Migration
  def change
    #
  end
end
EOF
  File.open(File.join(migration_dir, migration_file_name), "w").write(content)
  puts "Created #{File.join(migration_dir, migration_file_name)}"
end

desc 'Creats and starts Postgres9.4 docker'
task :docker_create do
  `docker run -e POSTGRES_USER=$USER -d -p 127.0.0.1:30101:5432 --name jsonb_tests_db lonelyplanet/postgres:9.4`
end

desc 'Starts previously created Postgres9.4 docker'
task :docker_start do
  `docker start jsonb_tests_db`
end


desc 'Stops Postgres9.4 docker'
task :docker_stop do
  `docker stop jsonb_tests_db`
end

desc 'Deletes Postgres9.4 docker'
task :docker_stop do
  `docker stop jsonb_tests_db`
  `docker rm -f jsonb_tests_db`
end


desc 'Open up a console'
task console: :environment do
  require 'irb'
  require 'irb/completion'
  require_relative 'lib/user'
  require_relative 'lib/customer'

  ARGV.clear
  IRB.start
end

load 'active_record/railties/databases.rake'
