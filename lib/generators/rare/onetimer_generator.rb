require 'rails/generators'
module Rare
  class OnetimerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

    def create_helper_file
      create_file "lib/one_timers/#{file_name}#{Time.zone.now.strftime("%Y%m%d%H%M%S")}.rb", <<-FILE
        module OneTimers
        module #{class_name}#{Time.zone.now.strftime("%Y%m%d%H%M%S")}
        	def self.run_once
        	end
        end
        end
      FILE
    end
  end
end