module ApplicationHelper
  def show_image(url)
    path = "http://audarme.kz#{url}"
  end
  def show_banner(url)
    path = "http://audarme.kz#{url}"
  end
  def catalog_anchor(lang,letter)
  	anchor = 'http://audarme.kz/catalog/'+lang.to_s+'/'+letter.to_s	
  end
  def kz_letters
  	letters = "АӘБВГҒДЕЁЖЗИЙКҚЛМНҢОӨПРСТУҰҮФХҺЦЧШЩЪЫІЬЭЮЯ"
  end
  def ru_letters
  	letters = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"
  end
end
