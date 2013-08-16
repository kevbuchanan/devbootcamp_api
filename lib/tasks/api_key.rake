desc "Create api keys for all users who don't already have one"
task :generate_keys => :environment do
  
  User.all.each do |user|
    unless user.api_key
      newapikey = ApiKey.new(:user => user)
      newapikey.save
    end
  end

end

