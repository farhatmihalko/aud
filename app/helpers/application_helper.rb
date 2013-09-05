module ApplicationHelper
  def show_image(url)
    path = "http://audarme.kz#{url}"
  end
  def show_banner(url)
    path = "http://localhost:3000#{url}"
  end  
end
