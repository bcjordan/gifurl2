CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                             # required
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],          # required
    :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],      # required
    :region                 => 'us-east-1'                        # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = ENV['FOG_DIRECTORY']                    # required (aka s3 bucket name)
  config.fog_host       = ENV['FOG_HOST']                         # optional, defaults to nil
 #config.fog_public     = false                                   # optional, defaults to true
 #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end