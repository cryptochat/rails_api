class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::ImageOptimizer
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.uuid}/#{mounted_as}"
  end

  process :optimize

  version :small do
    process resize_to_fill: [100, 100]
  end

  version :medium do
    process resize_to_fill: [200, 200]
  end

  version :big do
    process resize_to_fill: [300, 300]
  end

  def filename
    if original_filename
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension}"
    end
  end

  # TODO: перенести домен в ENV переменную
  def asset_host
    Rails.env.production? ? 'http://wishbyte.org' : 'http://localhost:3000'
  end
end
