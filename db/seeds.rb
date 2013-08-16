# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)


require 'faker'

cohort = Cohort.create!(:name => 'Summer 2012', :location => 'San Francisco')

params = {
  :password => 'pizza',
  :password_confirmation => 'pizza',
  :cohort => cohort,
  :roles => ["student"],
  :github => "www.github.com/jtaylor",
  :quora => "www.quora.com",
  :twitter => "www.twitter.com",
  :facebook => "www.facebook.com/jtaylor",
  :linked_in => "www.linkedin/jtaylor",
  :blog => "www.tumblr.com/jtaylor",
  :hacker_news => "www.hacker_news/jtaylor"
}

User.create! params.merge(:name => 'Jeremy Taylor',   :email => "mayatron@gmail.com")
User.create! params.merge(:name => 'Douglas Calhoun', :email => "douglas.calhoun@gmail.com")
User.create! params.merge(:name => 'Lachy Groom',     :email => "lachygroom@gmail.com")
User.create! params.merge(:name => 'Tony Phillips',   :email => "anthony.phillips@gmail.com")
User.create! params.merge(:name => 'Kush Patel',      :email => "kushiskushy@gmail.com")
User.create! params.merge(:name => 'Jesse Farmer',    :email => 'jesse@devbootcamp.com')
User.create! params.merge(:name => 'Tanner Welsh',    :email => 'tanner@devbootcamp.com')
User.create! params.merge(:name => 'Anne Spalding',   :email => 'anne@devbootcamp.com')
User.create! params.merge(:name => 'Ed Shadi',        :email => "shadi@devbootcamp.com")
User.create! params.merge(:name => 'Jared Grippe',    :email => "jared@devbootcamp.com")
User.create! params.merge(:name => 'Zee Spencer',     :email => "zee@devbootcamp.com")

# Create some stock poll questions
questions = ['I was awesome',
             'I have good personal hygiene',
             "I'm receptive to my pair's ideas",
             "I was attentive",
             "I said or did something offensive"]

questions.each { |q| Question.create(:body => q) }

questions = Question.all
users     = User.all

# Have every user give feedback to every other user
users.permutation(2).each do |giver, receiver|
  Feedback.create do |f|
    f.giver    = giver
    f.receiver = receiver
    f.body     = Faker::Lorem.paragraphs(2).join("\n\n")
  end
end

User.create! params.merge(:name => 'Stud Ent',        :email => 'student@devbootcamp.com')

