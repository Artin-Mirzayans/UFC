module EventHelper
  def start_time(time)
    if time.present?
      time.strftime("%l:%M %p (PST)")
    else 
    "TBD"
    end
  end

  def get_red_image_or_default(event)
    if event.red_image.present?
      event.red_image
    else
      "default_fighter.png"
    end
  end

  def get_blue_image_or_default(event)
    if event.blue_image.present?
      event.blue_image
    else
      "default_fighter.png"
    end
  end
end
