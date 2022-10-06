# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'csv'

Fighter.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('fighters')

Fighter.create!([
  name: "Placeholder",
  active: false
])
CSV.foreach(Rails.root.join('lib/seed_csv/fighters.csv'), headers: true) do |row|
  Fighter.create( {
    name: row["name"]
  } )
   
end