class FilmsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_film, only: [:show]

  def index
    @is_search = false
    if params[:query]
     @film_to_watch = Film.search(params[:query]).sample
     @is_search = true
    end

    @films = Film.all
  end

  def show
  end

  def get_films
    url = 'https://www.kinopoisk.ru/top/lists/1/filtr/all/sort/order/page/'

    films = []
    1.upto(4) do |i|
      films += parse_films(url + i.to_s)
    end

    films.each do |film|
      if film.title.present? && !Film.where(title: film.title).present?
        film.save
      end
    end

    @films_count = films.count

    redirect_to root_path
  end

  private

  def set_film
    @film = Film.find(params[:id])
  end

  def film_params
    params.require(:event).permit(:title, :director, :year, :poster)
  end

  def parse_films(url)
    doc = Nokogiri::HTML(open(url))

    return films = doc.css('table#itemList tr').map do |node|
      film = Film.new(
        title: node.css('.news div a').first.text,
        director: node.css('.news .gray_text a').first.text,
        year: node.css('.news div span').first.text.gsub(/.*\(/, '').gsub(/\).*/, '')
      )
      poster_url = node.css('.poster img')[0]["src"].gsub(/\/images\/spacer.gif/, '') +
        node.css('.poster img')[0]["title"]
      poster_url.gsub!(/sm_film\//, 'film_iphone/iphone360_')
      film.remote_poster_url = poster_url
      film
    end
  end
end
