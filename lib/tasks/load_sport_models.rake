# frozen_string_literal: true

namespace :syg do
    require 'csv'
    require 'pp'

    desc 'Load / update sport sessions table into the database'
    task load_sessions: ['db/data/sport_session.csv', 'db:migrate'] do |t|
      puts 'Loading sport sessions...'

      user = User.first
      file = File.new(t.prerequisites.first)

      result = Session.import(file, user)

      puts "Sessions imported - #{result[:creates]} added; #{result[:updates]} updated; #{result[:errors]} errors"
    end
  
    desc 'Load / update sport venues table into the database'
    task load_venues: ['db/data/sport_venue.csv', 'db:migrate'] do |t|
      puts 'Loading sport venues...'

      user = User.first
      file = File.new(t.prerequisites.first)

      result = Venue.import(file, user)

      puts "Venues imported - #{result[:creates]} added; #{result[:updates]} updated; #{result[:errors]} errors"
    end
  
    desc 'Load / update sports table into the database'
    task load_sports: ['db/data/sport.csv', 'db:migrate'] do |t|
        puts 'Loading sports...'

        user = User.first
        file = File.new(t.prerequisites.first)

        result = Sport.import(file, user)
  
        puts "Sports imported - #{result[:creates]} added; #{result[:updates]} updated; #{result[:errors]} errors"
    end
end
