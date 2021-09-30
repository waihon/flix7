module ApplicationHelper
  def main_image(record)
    if record.main_image.attached?
      image_tag record.main_image.variant(resize_to_limit: [150, nil])
    else
      image_tag "placeholder.png"
    end
  end
end
