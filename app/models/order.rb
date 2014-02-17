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
  end

  private

  def download_code
    Digest::MD5.hexdigest(plug + "ifiksr35")
  end
end
