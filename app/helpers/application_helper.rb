module ApplicationHelper
  def main_image(record, link=false)
    if record.main_image.attached?
      image = record.main_image.variant(resize_to_limit: [150, nil])
    else
      image = "placeholder.png"
    end

    if link
      link_to record do
        image_tag image
      end
    else
      image_tag image
    end
  end

  def page_title
    if content_for?(:title)
      content_tag :title, "Flix6 | #{content_for(:title)}"
    else
      content_tag :title, "Flix6"
    end
  end

  def content_for_title(title)
    content_for :title, title
  end
end
