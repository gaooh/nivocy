desc 'Load Nivocy default configuration data'

namespace :nivocy do
  task :load_default_data => :environment do
    begin
      Loader.load
      puts "Default configuration data loaded."
    rescue => error
      puts "Error: " + error
      puts "Default configuration data was not loaded."
    end
  end
end
