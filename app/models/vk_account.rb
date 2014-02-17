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
end
