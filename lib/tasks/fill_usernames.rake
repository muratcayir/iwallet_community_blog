namespace :fill_usernames do
    desc "Fill missing usernames for existing users"
    task fill: :environment do
      User.find_each do |user|
        if user.username.blank?
          base_username = user.email.split('@').first
          username = base_username
          suffix = 1
  
          while User.exists?(username: username)
            username = "#{base_username}#{suffix}"
            suffix += 1
          end
  
          user.update(username: username)
          puts "Updated user #{user.id} with username #{username}"
        end
      end
    end
  end
  