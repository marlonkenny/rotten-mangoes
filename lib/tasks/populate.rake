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
end
