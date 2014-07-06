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
      accs = Oj.load(Typhoeus.post("https://api.vk.com/method/getProfiles?fields=city,sex&access_token=dcc9e68c2d5b8fb01a2a93daac744985475a4a8f0c0073fc57561b048817e9f27ee553c9f71bd7210ed47", body:{uids: vk_ids.join(",")}).body)["response"].map do |account|
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