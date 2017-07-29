class Question < ApplicationRecord
  has_attached_file :image, styles: { square: '200x200#' },
                default_url: "/images/:style/missing.png",
                storage: :s3,
                s3_credentials: Proc.new{ |a| a.instance.s3_credentials }

  validates :clue_image, :presence => true
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  def s3_credentials
   {:bucket => ENV['S3_BUCKET_NAME'], :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
     :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'], :s3_region => ENV['AWS_REGION']}
  end


end
