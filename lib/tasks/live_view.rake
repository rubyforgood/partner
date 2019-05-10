desc "Update the development db to what is being used in prod"
task :copy_live => :environment do
  system("echo Performing dump of the database.")
  system("ssh partnerdeploy 'pg_dump -U diaper_partner -h localhost -Fc diaper_partner_production > backup.dump'")
  system("echo Downloading dump of the database locally.")
  system("scp partnerdeploy:~/backup.dump .")
  system("echo Download complete, removing remote copy of dump.")
  system("ssh partnerdeploy 'rm backup.dump'")
  system("echo Loading dump into local database.")
  system("pg_restore --verbose --clean --no-acl --no-owner -h localhost -d partner_dev backup.dump")
  system("echo Removing local copy of the database dump.")
  system("rm backup.dump")
end