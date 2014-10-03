namespace :populate do
  desc "import the movies csv"
  require_relative '../movie_importer'
  task import: :environment do
    MovieImporter.new.import
  end

  desc "populate missing date"
  task rtapi: :environment do
    MovieImporter.new.populate
  end

  desc "get descriptions from TMDB"
  task tmdb_descriptions: :environment do
    MovieImporter.new.find_descriptions
  end
end
