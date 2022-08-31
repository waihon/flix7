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
end
