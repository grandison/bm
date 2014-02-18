namespace :update do
  desc "Update contacts"
  task :contacts => :environment do
    i = 1537000
    while (vk_accounts = VkAccount.offset(i).first(10000)).present?
      p i
      hash = vk_accounts.group_by(&:vk_id)
      vk_ids = hash.keys
      vk_ids.each_slice(1000) do |ids_list|
        Oj.load(Typhoeus.post("https://api.vk.com/method/getProfiles?fields=city,sex&access_token=794e9fcb0d26fe28c2010a8b87a802c3b82304fd644154d8daf0f676f7662291a3f30835259b81ced0e67", body:{uids: ids_list.join(",")}).body)["response"].each do |account|
          a = hash[account["uid"].to_i].first
          a.vk_city_id = account["city"]
          a.sex = account["sex"]
          a.save(validate:false)
        end
      end
      i += 10000
    end
  end

end