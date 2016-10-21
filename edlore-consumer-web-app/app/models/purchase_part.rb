class PurchasePart < ActiveRecord::Base
 belongs_to :job
 belongs_to :expert
 belongs_to :user

  def purchase_url
    if File.exist?("#{Rails.root}/app/assets/images/product_images/#{self.job_id}/#{self.id}")
    url = "#{Rails.root}/assets/product_images/#{self.job_id}/#{self.id}/#{self.id}.png"
    return (url != "/images/:style/missing.png") ? "#{url}" : ""
    puts"file present"
  else
    url = "#{Rails.root}/assets/default.png"
    return (url != "/images/:style/missing.png") ? "#{url}" : ""
  end
  end
end
