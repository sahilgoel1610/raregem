namespace :rare do
  desc "It runs all the pending one timers on the local machine"
  task run_all: :environment do
  	onetimer_ran = []
		onetimer_ran = TimeOneTimer.order(:creation_time).pluck(:creation_time)
		Dir.chdir("lib/one_timers") do
			all_files = Dir["*.rb"]
			unran_files = all_files.select { |f| onetimer_ran.exclude?(f[f.length - 17..f.length - 4])  && f[f.length - 17..f.length - 4].to_i > 0 }
			unran_files.each do |file|
				onmodule = file.camelize[0..file.length - 4]
				("::OneTimers::" + onmodule).constantize.run_once
				TimeOneTimer.create(:creation_time => file[file.length - 17..file.length - 4])
			end
		end
  end

  task :run_step, [:step_number] => :environment do |task,args|
  	puts args[:step_number]
  	step_onetimer = TimeOneTimer.order(:creation_time).pluck(:creation_time).last(args[:step_number].to_i).first.to_i
		puts step_onetimer
		Dir.chdir("lib/one_timers") do
			rerun_file = Dir["*.rb"].select { |f| f[f.length - 17..f.length - 4].to_i  == step_onetimer }.first
			onmodule = rerun_file.camelize[0..rerun_file.length - 4]
			("::OneTimers::" + onmodule).constantize.run_once
		end	
  end

  

end
