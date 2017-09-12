def say(msg, &block)
  puts "#{msg}..."

  if block_given?
      yield
    puts " Done."
  end
end

namespace :run_app do

  desc 'To do `bundle install` in given directory'
  task :bundle_install, [:dir_name] do |t, args|
    say 'bundle install command is executing inside '+ "#{args[:dir_name]}"  do
      if Dir.exists?("#{args[:dir_name]}")
        system("cd #{args[:dir_name]} && bundle install")
      else
        puts "File #{args[:dir_name]} not found."
      end
    end
  end

  desc 'To do `bundle update` in given directory'
  task :bundle_update, [:dir_name] do |t, args|
    say 'bundle update command is executing inside ' + "#{args[:dir_name]}" do
      if Dir.exists?("#{args[:dir_name]}")
        system("cd #{args[:dir_name]} && bundle update")
      end
    end
  end

  desc 'To do `bundle exec rails s` in given directory'
  task :rails_server, [:dir_name] do |t, args|
    say 'bundle update command is executing inside '+ "#{args[:dir_name]}"  do
      if Dir.exists?("#{args[:dir_name]}")
        system("cd #{args[:dir_name]} && bundle exec rails s")
      end
    end
  end

  desc 'To run demo_rails rails app '
  task :rails do
    say 'Running rails app..' do
      file_name = 'demo_rails'
      # Rake.application.invoke_task("run_app:bundle_install[#{file_name}]")
      # Rake.application.invoke_task("run_app:bundle_update[#{file_name}]")
      # Rake.application.invoke_task("run_app:rails_server[#{file_name}]")
      #
      # or do these lines:
      Rake::Task["run_app:bundle_install"].invoke("#{file_name}")
      Rake::Task["run_app:bundle_update"].invoke("#{file_name}")
      Rake::Task["run_app:rails_server"].invoke("#{file_name}")
    end
  end

end
