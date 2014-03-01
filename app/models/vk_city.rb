# -*- encoding : utf-8 -*-
require 'oj'
require 'typhoeus'

class VkCity < ActiveRecord::Base
  CITIES = {1 => 'Москва',2 => 'Санкт-Петербург',37 => 'Владивосток',10 => 'Волгоград',49 => 'Екатеринбург',60 => 'Казань',61 => 'Калининград',72 => 'Краснодар',73 => 'Красноярск',95 => 'Нижний Новгород',99 => 'Новосибирск',104 => 'Омск',110 => 'Пермь',119 => 'Ростов-на-Дону',123 => 'Самара',151 => 'Уфа',153 => 'Хабаровск',158 => 'Челябинск', 87 => 'Мурманск'}

  def self.pretty_country(country)
    @countries ||= {}
    @countries[country] ||= begin
      Oj.load(Typhoeus.post("https://api.vk.com/method/database.getCountriesById?country_ids=#{country}&access_token=794e9fcb0d26fe28c2010a8b87a802c3b82304fd644154d8daf0f676f7662291a3f30835259b81ced0e67", "Content-Type" => 'application/x-www-form-urlencoded'}).body)["response"].first["title"]
    end
  end

  def self.pretty_city(city)
    @countries ||= {}
    @countries[country] ||= begin
      Oj.load(Typhoeus.post("https://api.vk.com/method/database.getCitiesById?city_ids=#{city}&access_token=794e9fcb0d26fe28c2010a8b87a802c3b82304fd644154d8daf0f676f7662291a3f30835259b81ced0e67", "Content-Type" => 'application/x-www-form-urlencoded'}).body)["response"].first["title"]
    end
  end
end
