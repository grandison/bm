require 'oj'
require 'typhoeus'

namespace :update do
  desc "Update contacts"
  task :contacts => :environment do
    f = File.open(Rails.root.join("ids.txt"))
    skip_count = 0
    ids = Array.new(1000000){f.gets.strip}
    vk_ids.each_slice(100) do |ids_list|
      Oj.load(Typhoeus.post("https://api.vk.com/method/getProfiles?fields=city,sex&access_token=794e9fcb0d26fe28c2010a8b87a802c3b82304fd644154d8daf0f676f7662291a3f30835259b81ced0e67", body:{uids: ids_list.join(","), "Content-Type" => 'application/x-www-form-urlencoded'}).body)["response"].each do |account|
        a = VkAccount.find_by_vk_id(account["uid"])
        a.vk_city_id = account["city"]
        a.sex = account["sex"]
        a.save(validate:false)
      end
    end
  end

end