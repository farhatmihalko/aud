class Advert < ActiveRecord::Base
  mount_uploader :banner, BannerUploader
  attr_accessible :company, :counter, :banner, :anchor, :place


  PLACES = {
    1 => "Верхняя реклама",
    2 => "Боковая реклама",
    3 => "Нижняя реклама"
  }

  # def addsloader=(obj)
  #   super(obj)
  # end
  def self.get_adverts
    adverts = Hash.new
    adverts[1] = Advert.get_first
    adverts[2] = Advert.get_second
    adverts[3] = Advert.get_third
    adverts
  end

  def self.get_first
    ad = Advert.where(:place => 1).last
    if ad
      ad.counter+=1
      ad.save
      return ad
    end
  end

  def humanized_place
    PLACES[self.place]
  end

  def self.get_second
    ad = Advert.where(:place => 2).last
    if ad
      ad.counter+=1
      ad.save
      return ad
    end
  end

  def self.get_third
    ad = Advert.where(:place => 3).last
    if ad
      ad.counter+=1
      ad.save
      return ad
    end
  end
end
