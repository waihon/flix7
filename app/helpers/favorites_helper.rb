module FavoritesHelper
  def fave_or_unfave_button(movie, favorite)
    if favorite
      button_to "♡ Unfave", movie_favorite_path(movie, favorite),
        method: :delete, class: "button unfave"
    else
      button_to "♥️ Fave", movie_favorites_path(@movie),
        class: "button fave"
    end
  end
end
