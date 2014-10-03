class MovieImporter
include RottenTomatoes
  
  Rotten.api_key = "xg8vg3f9v5f74wqjazrpmtae"
  Tmdb::Api.key("db378675c22f6b4f0383f6415a7957ea")

  def initialize
    @filename = "#{::Rails.root}/db/movie_list.csv"
  end

  def import
    field_names = ['title', 'director', 'runtime_in_minutes', 'release_date']

    print "Importing movies from #{@filename}: "
    Movie.transaction do
      File.open(@filename).each do |line|
        data = line.chomp.split(',')
        begin
          formatted_date = Date.strptime(data[3], "%m/%d/%Y")
        rescue TypeError => e
          puts e.message
          data[3] = nil
        rescue ArgumentError => e
          puts e.message
          data[3] = nil
        else
          data[3] = formatted_date
        end
        attribute_hash = Hash[field_names.zip(data)]
        movie = Movie.create!(attribute_hash)
      end
    end
    puts "\nDONE"
  end

  def populate
    Movie.find_each(batch_size: 100) do |m|
      rt_m = RottenMovie.find(
        title:          m.title, 
        limit:          1,
      )  
      unless rt_m.blank?
        m.runtime_in_minutes = rt_m.runtime if m.runtime_in_minutes.blank? && rt_m.runtime
        m.description = rt_m.synopsis if m.description.blank? && rt_m.synopsis 
        m.release_date = rt_m.release_dates.theater if m.release_date.blank? && rt_m.release_dates.theater 
        m.poster_image_url = rt_m.posters.original.gsub(/tmb/, 'org')
        m.rt_score = rt_m.ratings.critics_score if rt_m.ratings.critics_score
        m.save
        sleep(1.0/4.0)
        print "#{m.id}-#{rt_m.title} | " ; STDOUT.flush
      end
    end
  end

  def find_descriptions
    puts 'starting'
    Movie.find_each(start: 313, batch_size: 100) do |m|
      if m.description.start_with?('Lorem')
        @search = Tmdb::Search.new
        @search.resource('movie') # determines type of resource
        @search.query(m.title) # the query to search against
        @search.year(m.release_date.year) if m.release_date
        result = @search.fetch[0]
        if result
          movie = Tmdb::Movie.detail(result.id)
          m.description = movie.overview
          m.save
          sleep(1.0/3.0)
          print "#{m.id}-#{m.title} | " ; STDOUT.flush
        end
      end
    end
  end
end