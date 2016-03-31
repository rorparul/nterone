namespace :deploy do

  desc "deploy app for the first time (expects pre-created but empty DB)"
  task :cold do
    before 'deploy:migrate', 'deploy:initrvm'
    before 'deploy:migrate', 'deploy:initdb'
    invoke 'deploy'
  end

  desc "initialize rvm/ruby"
  task :initrvm do
    on primary :web do |host|
      within release_path do
        execute :rake, 'rvm1:install:gems'
        execute :rake, 'cap rvm1:install:gems'
      end
    end
  end


  desc "initialize a brand-new database (db:schema:load, db:seed)"
  task :initdb do
    on primary :web do |host|
      within release_path do
        execute :rake, 'db:schema:load'
#        execute :rake, 'db:seed'
      end
    end
  end

end
