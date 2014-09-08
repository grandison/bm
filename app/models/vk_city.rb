# -*- encoding : utf-8 -*-
require 'oj'
require 'typhoeus'

class VkCity < ActiveRecord::Base
  CITIES = {1 => 'Москва',2 => 'Санкт-Петербург',37 => 'Владивосток',10 => 'Волгоград',49 => 'Екатеринбург',60 => 'Казань',61 => 'Калининград',72 => 'Краснодар',73 => 'Красноярск',95 => 'Нижний Новгород',99 => 'Новосибирск',104 => 'Омск',110 => 'Пермь',119 => 'Ростов-на-Дону',123 => 'Самара',151 => 'Уфа',153 => 'Хабаровск',158 => 'Челябинск', 87 => 'Мурманск'}

  validates :vk_city_id, presence: true

  def self.pretty_country(country)
    @@countries ||= {}
    @@countries[country] ||= begin
      if country && (country != 0)
        sleep(0.5)
        Oj.load(Typhoeus.get("https://api.vk.com/method/database.getCountriesById?country_ids=#{country}&access_token=9a01834553da900ab575b7bd3a2c436289f6a7a1d8cb3255f8b4b79c598948b5dfe49ab93c4b0dbb8f5cc").body)["response"].first["name"]
      end
    end
  end

  def self.pretty_city(city)
    if city && (city > 0)
      @@cities[city.to_s].name
    end
  end

  def self.prepare_cities(cities)
    @@cities ||= {}
    Oj.load(Typhoeus.get("https://api.vk.com/method/database.getCitiesById?city_ids=#{cities.join(",")}&access_token=9a01834553da900ab575b7bd3a2c436289f6a7a1d8cb3255f8b4b79c598948b5dfe49ab93c4b0dbb8f5cc").body)["response"].each do |city|
      @@cities[city['cid']] ||= begin 
        find_by_vk_city_id(city['cid']) || create!(vk_city_id: city['cid'], name: city['name'])
      end
    end
  end
end
