# -*- encoding : utf-8 -*-
require 'oj'
require 'vk_group'

class VkAccount < ActiveRecord::Base
  def self.search(order)
    return none unless order.persisted?
    scope = all
    if order.vk_city_id.present?
      scope = scope.where("vk_city_id = ?", order.vk_city_id)
    end
    if order.sex.present?
      scope = scope.where("sex = ?", order.sex)
    end
    if order.vk_group_id.present?
      group_id = order.vk_group_id
      connection = ActiveRecord::Base.connection
      unless connection.execute("show tables like 'vk_group_#{order.vk_group_id}'").first
        VkGroup.delay.prepare(group_id)
        return false
      end
      return false unless connection.execute("SHOW INDEX FROM vk_group_#{order.vk_group_id}").first
      scope = scope.joins("INNER JOIN vk_group_#{group_id} ON vk_accounts.vk_id = vk_group_#{group_id}.vk_user_id")
    end
    scope
  end

  def self.update_sex(vk_ids)
    vk_ids.each_slice(100) do |ids_list|
      Oj.load(Typhoeus.post("https://api.vk.com/method/getProfiles?fields=city,sex&access_token=794e9fcb0d26fe28c2010a8b87a802c3b82304fd644154d8daf0f676f7662291a3f30835259b81ced0e67", body:{uids: ids_list.join(","), "Content-Type" => 'application/x-www-form-urlencoded'}).body)["response"].each do |account|
        a = VkAccount.find_by_vk_id(account["uid"])
        a.vk_city_id = account["city"]
        a.sex = account["sex"]
        a.save(validate:false)
      end
    end
  end

  def self.pretty_sex(sex)
    {1 => "Женский", 2 => "Мужской"}[sex]
  end

  def self.pretty_relation(relation)
     {1 => "Не женат", 2 => "Встречается", 3 => "Помолвлен", 4 => "Женат", 7 => "Влюблён", 5 => "Всё сложно", 6 => "В активном поиске."}[relation]
  end
end
