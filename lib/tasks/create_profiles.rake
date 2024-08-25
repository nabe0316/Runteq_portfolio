namespace :users do
  desc "Create profiles for existing users"
  task create_profiles: :environment do
    User.find_each do |user|
      unless user.profile
        username = user.name.present? ? user.name : "User#{user.id}"
        user.create_profile!(username: username)
        puts "Created profile for user: #{user.email} with username: #{username}"
      end
    end
  end
end
