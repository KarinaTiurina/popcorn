class FilmsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_film, only: [:show]

  def index
    @is_search = false
    if params.include?(:query)
      if params[:query].present?
        @film_to_watch = Film.search(params[:query]).sample
      else
        @film_to_watch = Film.all.sample
      end
      @is_search = true
    end

    @films = Film.all
  end

  def show
    @new_film_user = @film.film_users.build(params[:film_user])
    @new_comment = @film.comments.build(params[:comment])
  end

  def get_films
    url = 'https://www.kinopoisk.ru/top/lists/1/filtr/all/sort/order/page/'

    films = []
    1.upto(4) do |i|
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

  private

  def set_film
    @film = Film.find(params[:id])
  end

  def film_params
    params.require(:event).permit(:title, :director, :year, :poster, :kinopoisk_id)
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
end
