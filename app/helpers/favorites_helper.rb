module FavoritesHelper
  def fave_or_unfave_button(movie, favorite, disabled=false)
    html_options = { disabled: disabled }
    if disabled
      html_options[:data] = { toggle: "tooltip", placement: "botton" }
      html_options[:title] = "Please sign in first"
    end

    if favorite
      html_options = html_options.merge({ method: :delete, class: "button unfave" })
      button_to "♡ Unfave", movie_favorite_path(movie, favorite), html_options
    else
      html_options = html_options.merge({ class: "button fave" })
      button_to "♥️ Fave", movie_favorites_path(@movie), html_options
    end
  end
end
