module MoviesHelper
  def total_gross(movie)
    if movie.flop?
      "Flop!"
    else
      number_to_currency(movie.total_gross, precision: 0)
    end
  end

  def year_of(movie)
    movie.released_on.year
  end

  def nav_link_to(text, url)
    # Adding check_parameters because the filter is now part of the params,
    # and not part of the path.
    # Index/Released: http://localhost:3000/movies
    # Upcoming: http://localhost:3000/movies?filter=upcoming
    # https://apidock.com/rails/ActionView/Helpers/UrlHelper/current_page%3f
    if current_page?(url, check_parameters: true)
      link_to text, url, class: "active"
    else
      link_to text, url
    end
  end
end
