# -*- encoding : utf-8 -*-
class VkGroup
  def self.prepare(vk_group_id)
    connection = ActiveRecord::Base.connection
    return if connection.execute("show tables like 'vk_group_#{vk_group_id}'").first
    requests = []
    connection.execute("CREATE TABLE vk_group_#{vk_group_id} (vk_user_id INT)")
    hydra = Typhoeus::Hydra.new(max_concurrency: 30)
    resp = JSON.parse(Typhoeus.get("http://api.vk.com/method/groups.getMembers?group_id=#{vk_group_id}&count=0").body)["response"]
    count = resp["count"]
    (count / 1000 + 1).times do |i|
      request = Typhoeus::Request.new("http://api.vk.com/method/groups.getMembers?sort=time_desc&group_id=#{vk_group_id}&count=1000&offset=#{i*1000}")
      hydra.queue(request)
      requests << request
    end
    hydra.run
    result = []
    requests.each do |request|
      users = JSON.parse(request.response.body)["response"]["users"]
      connection.execute("INSERT INTO vk_group_#{vk_group_id} (vk_user_id) VALUES #{users.map{|u| '(' + u.to_s + ')'}.join(',')}")
    end
    connection.execute("ALTER TABLE `vk_group_#{vk_group_id}` ADD INDEX `vk_user_id` (`vk_user_id`)")
  end
end
