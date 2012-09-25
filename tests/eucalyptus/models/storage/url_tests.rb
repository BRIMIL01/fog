# encoding: utf-8

Shindo.tests('Eucalyptus | url', ["eucalyptus"]) do

  @expires = Time.utc(2013,1,1).utc.to_i

  @storage = Fog::Storage.new(
    :provider => 'Eucalyptus',
    :eucalyptus_access_key_id => '123',
    :eucalyptus_secret_access_key => 'abc',
    :region => 'eucalyptus'
  )
  
  @file = @storage.directories.new(:key => 'fognonbucket').files.new(:key => 'test.txt')

  if Fog.mock?
    signature = Fog::Storage::Eucalyptus.new.signature(nil)
  else
    signature = 'tajHIhKHAdFYsigmzybCpaq8N0Q%3D'
  end

  tests('#url w/ response-cache-control').returns(
    "https://fognonbucket.s3.amazoneucalyptus.com/test.txt?response-cache-control=No-cache&AWSAccessKeyId=123&Signature=#{signature}&Expires=1356998400"
  ) do
    @file.url(@expires, :query => { 'response-cache-control' => 'No-cache' })
  end

end
