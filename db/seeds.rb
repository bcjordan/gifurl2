# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'EMPTY THE MONGODB DATABASE'
Mongoid.master.collections.reject { |c| c.name =~ /^system/}.each(&:drop)

a = Gif.create!(title: "Michael Jackson eating popcorn", url: "http://i.imgur.com/tCp90.gif")
       .tag("jackson").tag("popcorn")
       .tag('a b c d e f g')

b = Gif.create!(title: "Conan String Dance", url: "http://i.eho.st/pgzlex7r.gif")
       .tag("conan string dance")

5.times do |n|
  sleep(0.1)
  Gif.create!(title: "Gif #{n}", url: "http://i.eho.st/pgzlex7r.gif?#{n}")
       .tag("#{n}")
       .tag("jackson").tag("popcorn")
       .tag('a b c d e f g')
end