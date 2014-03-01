# -*- encoding : utf-8 -*-
require 'securerandom'
 require 'digest/md5'
class Order < ActiveRecord::Base
  before_save :generate_slug
  before_save :set_group_id

  def generate_slug
    self.plug = SecureRandom.hex(15)
  end

  def to_param
    plug
  end

  def set_group_id
    return true if vk_group_link.blank?
    vk_index = vk_group_link.index("vk.com/")
    return false unless vk_index
    screen_name = vk_group_link.match(/vk.com\/([\d\_\w\.]+)/).try(:[],1)
    return false unless 
    request = Typhoeus.get("http://api.vk.com/method/utils.resolveScreenName?screen_name=#{screen_name}")
    response = Oj.load(request.body)["response"]
    return false if response.blank?
    self.vk_group_id = response["object_id"].to_i
  end

  def generate!
    f = File.open(Rails.root.join("public", download_code + ".txt"), "w")
    VkAccount.search(self).pluck(:email).each do |v|
      f.write(v + "\n")
    end
    f.close
  end

  def generate_with_names!
    f = File.open(Rails.root.join("public", download_code + ".txt"), "w:windows-1251")
    VkAccount.search(self).each_slice(200) do |accounts|
      Oj.load(Typhoeus.post("https://api.vk.com/method/getProfiles?fields=city,sex&access_token=794e9fcb0d26fe28c2010a8b87a802c3b82304fd644154d8daf0f676f7662291a3f30835259b81ced0e67", body:{uids: accounts.map(&:vk_id).join(","), "Content-Type" => 'application/x-www-form-urlencoded'}).body)["response"].each_with_index do |account,index|
        f.write("#{account["first_name"].encode('windows-1251', {:invalid => :replace, :undef => :replace, :replace => '?'})} #{account["last_name"].encode('windows-1251', {:invalid => :replace, :undef => :replace, :replace => '?'})},#{accounts[index].email}\n")
      end
      sleep(0.2)
    end
    f.close
  end

  def generate_full!
    f = File.open(Rails.root.join("public", download_code + ".txt"), "w:windows-1251")
    VkAccount.search(self).each_slice(200) do |accounts|
      Oj.load(Typhoeus.post("https://api.vk.com/method/getProfiles?fields=photo,sex,bdate,city,country,site,education,universities,schools,status,relation&access_token=794e9fcb0d26fe28c2010a8b87a802c3b82304fd644154d8daf0f676f7662291a3f30835259b81ced0e67", body:{uids: accounts.map(&:vk_id).join(","), "Content-Type" => 'application/x-www-form-urlencoded'}).body)["response"].each_with_index do |account,index|
        account["uid"] = nil
        account["sex"] = VkAccount.pretty_sex(account["sex"])
        account["country"] = VkCity.pretty_country(account["country"])
        account["city"] = VkCity.pretty_city(account["city"])
        if account["universities"]
          account["universities"] = account["universities"].map do |un| 
            un["country"] = VkCity.pretty_country(un["country"])
            un["city"] = VkCity.pretty_city(un["city"])
            un
          end
        end
        if account["schools"]
          account["schools"] = account["schools"].map do |un| 
            un["country"] = VkCity.pretty_country(un["country"])
            un["city"] = VkCity.pretty_city(un["city"])
            un
          end
        end
        account["relation"] = VkAccount.pretty_relation(account["relation"])
        f.write("#{Oj.dump(account).encode('windows-1251', {:invalid => :replace, :undef => :replace, :replace => '?'})}")
      end
      sleep(0.2)
    end
    f.close
  end


  private

  def download_code
    plug
  end
end
