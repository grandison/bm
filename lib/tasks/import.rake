namespace :import do
  desc "Import contacts"
  task :contacts => :environment do
    f = File.open(Rails.root.join("contacts.txt"))
    # VkAccount.destroy_all
    loop do
      emails = []
      vk_ids = []
      while (line = f.gets) && (emails.count < 1000)
        email,vk_id = line.rstrip.split(",")
        emails << email
        vk_ids << vk_id
      end
      index = -1
      accs = Oj.load(Typhoeus.post("https://api.vk.com/method/getProfiles?fields=city,sex&access_token=9a01834553da900ab575b7bd3a2c436289f6a7a1d8cb3255f8b4b79c598948b5dfe49ab93c4b0dbb8f5cc", body:{uids: vk_ids.join(",")}).body)["response"].map do |account|
        index += 1
        VkAccount.new(email: emails[index], vk_id: vk_ids[index], vk_city_id: account["city"], sex: account["sex"])
      end
      VkAccount.import(accs)
      if emails.count < 1000
        exit
      end
    end
  end

end