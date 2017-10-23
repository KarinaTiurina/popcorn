class FilmsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_film, only: [:show]

  after_action :verify_authorized, only: [:get_films, :destroy_films]

  def index
    @films = Film.all.to_a
    @selected_genres = []

    if params[:selected_g].present?
      @selected_genres = params[:selected_g]

      suitable_films = []
      @selected_genres.each do |genre|
        suitable_films += Film.search(genre)
      end

      delete_watched(suitable_films)

      @random_film = suitable_films.sample
    else
      s_films = @films
      delete_watched(s_films)
      @random_film = s_films.sample
    end

    @trailer = trailer(@random_film)

    @all_genres = genres(@films)
  end

  def show
    @new_film_user = @film.film_users.build(params[:film_user])
    @new_comment = @film.comments.build(params[:comment])
    @trailer = trailer(@film)
  end

  def get_films
    authorize Film

    url = 'https://www.kinopoisk.ru/top/lists/1/filtr/all/sort/order/page/'

    films = []
    1.upto(20) do |i|
      films += parse_films(url + i.to_s)
    end

    films.each do |film|
      film_new = Film.where(kinopoisk_id: film[:kinopoisk_id]).first

      unless film_new.present?
        film_new = Film.new
        film_new[:kinopoisk_id] = film[:kinopoisk_id]
      end

      film_new.title = film[:title]
      film_new.director = film[:director]
      film_new.year = film[:year]
      film_new.genre = film[:genre]

      film_new.remote_poster_url = film[:poster_url]

      film_new.save
    end

    @films_count = films.count

    redirect_to root_path
  end

  def destroy_films
    authorize Film

    Film.destroy_all

    redirect_to root_path
  end

  private

  def set_film
    @film = Film.find(params[:id])
  end

  def film_params
    params.require(:event).permit(:title, :director, :year, :poster, :kinopoisk_id)
  end

  def genres(films)
    all_genres = []

    films.each do |film|
      film_genres = film.genre.split(',')
      film_genres.each do |genre|
        all_genres << { id: genre, name: genre}
      end
    end

    all_genres.uniq!
  end

  def delete_watched(films)
    if current_user.present?
      films.delete_if { |film| film.users.include?(current_user) }
      # films.each do |film|
      #   if film.users.include?(current_user)
      #     films.delete(film)
      #   end
      # end
    end
  end

  def parse_films(url)
    doc = Nokogiri::HTML(open(url))

    return films = doc.css('table#itemList tr').map do |node|
      kinopoisk_id = node["id"].gsub(/tr_/, '')
      title = node.css('.news div a').first.text
      year = node.css('.news div span').first.text.gsub(/.*\(/, '').gsub(/\).*/, '')
      director = node.css('.news .gray_text a').first.text
      genre = node.css('.news .gray_text').first.text.gsub(/[\n .]/, '').gsub(/.*\(/, '').gsub(/\).*/, '')

      film = {
        kinopoisk_id: kinopoisk_id,
        title: title,
        director: director,
        year: year,
        genre: genre
      }
      poster_url = node.css('.poster img')[0]["src"].gsub(/\/images\/spacer.gif/, '') +
        node.css('.poster img')[0]["title"]
      poster_url.gsub!(/sm_film\//, 'film_iphone/iphone360_')
      film[:poster_url] = poster_url
      film
    end
  end

  def trailer(film)
    url = "https://www.youtube.com/results?search_query="
    title_s = film.title.split(' ')
    title_s.each do |word|
      word.gsub!('ё', 'е')
      word.gsub!('Ё', 'Е')
      word.gsub!('ю', 'у')
      word.gsub!('Ю', 'У')
      url += Translit.convert(word) + "+"
    end
    url += film.year.to_s + "+trailer"
    doc = Nokogiri::HTML(open(url))

    node =  doc.css('h3 a').first
    return "https://www.youtube.com/embed/" +
                node["href"].gsub('/watch?v=', '') +
                "?rel=0"
  end
end
