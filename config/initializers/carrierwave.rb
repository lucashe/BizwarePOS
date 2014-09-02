CarrierWave.configure do |config|
  
  config.fog_credentials = {
    :provider               => 'AWS',                                      # required
    :aws_access_key_id      => 'AKIAIR6W4FG6Z3XSZJ4A',                     # required
    :aws_secret_access_key  => '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',  # required
    #,                       
    :region                 => 'ap-southeast-1'                  # optional, defaults to 'us-east-1'
    #:host                   => 's3.example.com',             # optional, defaults to nil
    #:endpoint               => 'https://s3.example.com:8080' # optional, defaults to nil
  }
  config.fog_directory  = 'lucas.me.pos'                     # required
  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  
end