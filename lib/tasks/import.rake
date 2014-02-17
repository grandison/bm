namespace :import do
  desc "Import contacts"
  task :contacts => :environment do
    skip_count = 43000
    f = File.open(Rails.root.join("contacts.txt"))
    # VkAccount.destroy_all
    skip_count.times do
      f.gets
    end
    loop do
      emails = []
      vk_ids = []
      while (line = f.gets) && (emails.count < 1000)
        email,vk_id = line.rstrip.split(",")
        emails << email
        vk_ids << vk_id
      end
      skip_count += emails.count
      index = -1
      accs = Oj.load(Typhoeus.post("https://api.vk.com/method/getProfiles?fields=city,sex&access_token=794e9fcb0d26fe28c2010a8b87a802c3b82304fd644154d8daf0f676f7662291a3f30835259b81ced0e67", body:{uids: vk_ids.join(",")}).body)["response"].map do |account|
        index += 1
        VkAccount.new(email: emails[index], vk_id: vk_ids[index], vk_city_id: account["city"], sex: account["sex"])
      end
      VkAccount.import(accs)
      p skip_count
      if emails.count < 1000
        exit
      end
    end
  end
end