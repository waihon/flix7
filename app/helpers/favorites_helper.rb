module FavoritesHelper
  def fave_or_unfave_button(movie, favorite, disabled=false)
    html_options = { disabled: disabled }

    if favorite
        html_options = html_options.merge({ class: "button unfave", method: :delete })
        path = movie_favorite_path(movie, favorite)
        label = "♡ Unfave"
    else
        html_options = html_options.merge({ class: "button fave" })
        path = movie_favorites_path(@movie)
        label = "♥️ Fave"
    end

    if disabled
      html_options[:data] = { toggle: "tooltip", placement: "bottom" }
      html_options[:title] = "Please sign in first"
      html_options[:method] = :get
      path = signin_path
    end

    button_to label, path, html_options
  end
end
