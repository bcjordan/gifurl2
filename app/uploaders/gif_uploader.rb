# encoding: utf-8

class GifUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  #storage :file
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    nil
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  #def scale(width, height)
  #   # do something
  #end

  # Create different versions of your uploaded files:
  version :micro do
    process :resize_to_fill => [25, 25]

    def full_filename(for_file = model.url_hash)
      "#{for_file}_t.gif"
    end
  end

  version :thumb do
    process :resize_to_fill => [70, 70]

    def full_filename(for_file = model.url_hash)
      "#{for_file}_s.gif"
    end
  end

  version :box do
    process :resize_to_fit => [200, 200]

    def full_filename(for_file = model.url_hash)
      "#{for_file}_m.gif"
    end
  end


  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{model.url_hash}.gif" if original_filename
  end

  def md5
    @md5 ||= ::Digest::MD5.file(current_path).hexdigest
  end
  
  def checksum
    "#{md5}#{file.size}"
  end

end
