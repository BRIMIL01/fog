Shindo.tests('Eucalyptus::Storage | object requests', ['eucalyptus']) do
  @directory = Fog::Storage[:eucalyptus].directories.create(:key => 'fogobjecttests-' + Time.now.to_i.to_s(32))
  @eucalyptus_owner = Fog::Storage[:eucalyptus].get_bucket_acl(@directory.key).body['Owner']

  tests('success') do

    tests("#put_object('#{@directory.identity}', 'fog_object', lorem_file)").succeeds do
      Fog::Storage[:eucalyptus].put_object(@directory.identity, 'fog_object', lorem_file)
    end

    tests("#copy_object('#{@directory.identity}', 'fog_object', '#{@directory.identity}', 'fog_other_object')").succeeds do
      Fog::Storage[:eucalyptus].copy_object(@directory.identity, 'fog_object', @directory.identity, 'fog_other_object')
    end

    @directory.files.get('fog_other_object').destroy

    tests("#get_object('#{@directory.identity}', 'fog_object')").returns(lorem_file.read) do
      Fog::Storage[:eucalyptus].get_object(@directory.identity, 'fog_object').body
    end

    tests("#get_object('#{@directory.identity}', 'fog_object', &block)").returns(lorem_file.read) do
      data = ''
      Fog::Storage[:eucalyptus].get_object(@directory.identity, 'fog_object') do |chunk, remaining_bytes, total_bytes|
        data << chunk
      end
      data
    end

    tests("#get_object('#{@directory.identity}', 'fog_object', {'Range' => 'bytes=0-20'})").returns(lorem_file.read[0..20]) do
      Fog::Storage[:eucalyptus].get_object(@directory.identity, 'fog_object', {'Range' => 'bytes=0-20'}).body
    end

    tests("#get_object('#{@directory.identity}', 'fog_object', {'Range' => 'bytes=0-0'})").returns(lorem_file.read[0..0]) do
      Fog::Storage[:eucalyptus].get_object(@directory.identity, 'fog_object', {'Range' => 'bytes=0-0'}).body
    end

    tests("#head_object('#{@directory.identity}', 'fog_object')").succeeds do
      Fog::Storage[:eucalyptus].head_object(@directory.identity, 'fog_object')
    end

    tests("#put_object_acl('#{@directory.identity}', 'fog_object', 'private')").succeeds do
      Fog::Storage[:eucalyptus].put_object_acl(@directory.identity, 'fog_object', 'private')
    end

    acl = {
      'Owner' => @eucalyptus_owner,
      'AccessControlList' => [
        {
          'Grantee' => @eucalyptus_owner,
          'Permission' => "FULL_CONTROL"
        }
      ]}
    tests("#put_object_acl('#{@directory.identity}', 'fog_object', hash with id)").returns(acl) do
      Fog::Storage[:eucalyptus].put_object_acl(@directory.identity, 'fog_object', acl)
      Fog::Storage[:eucalyptus].get_object_acl(@directory.identity, 'fog_object').body
    end

    tests("#put_object_acl('#{@directory.identity}', 'fog_object', hash with email)").returns({
        'Owner' => @eucalyptus_owner,
        'AccessControlList' => [
          {
            'Grantee' => { 'ID' => 'f62f0218873cfa5d56ae9429ae75a592fec4fd22a5f24a20b1038a7db9a8f150', 'DisplayName' => 'mtd' },
            'Permission' => "FULL_CONTROL"
          }
        ]}) do
      pending if Fog.mocking?
      Fog::Storage[:eucalyptus].put_object_acl(@directory.identity, 'fog_object', {
        'Owner' => @eucalyptus_owner,
        'AccessControlList' => [
          {
            'Grantee' => { 'EmailAddress' => 'mtd@amazon.com' },
            'Permission' => "FULL_CONTROL"
          }
        ]})
      Fog::Storage[:eucalyptus].get_object_acl(@directory.identity, 'fog_object').body
    end

    acl = {
      'Owner' => @eucalyptus_owner,
      'AccessControlList' => [
        {
          'Grantee' => { 'URI' => 'http://acs.amazoneucalyptus.com/groups/global/AllUsers' },
          'Permission' => "FULL_CONTROL"
        }
      ]}
    tests("#put_object_acl('#{@directory.identity}', 'fog_object', hash with uri)").returns(acl) do
      Fog::Storage[:eucalyptus].put_object_acl(@directory.identity, 'fog_object', acl)
      Fog::Storage[:eucalyptus].get_object_acl(@directory.identity, 'fog_object').body
    end

    tests("#delete_object('#{@directory.identity}', 'fog_object')").succeeds do
      Fog::Storage[:eucalyptus].delete_object(@directory.identity, 'fog_object')
    end
    
    tests("#get_object_http_url('#{@directory.identity}', 'fog_object', expiration timestamp)").returns(true) do
      object_url = Fog::Storage[:eucalyptus].get_object_http_url(@directory.identity, 'fog_object', (Time.now + 60))
      (object_url =~ /http:\/\/#{Regexp.quote(@directory.identity)}\.s3\.amazoneucalyptus\.com\/fog_object/) != nil
    end

  end

  tests('failure') do

    tests("#put_object('fognonbucket', 'fog_non_object', lorem_file)").raises(Excon::Errors::NotFound) do
      Fog::Storage[:eucalyptus].put_object('fognonbucket', 'fog_non_object', lorem_file)
    end

    tests("#copy_object('fognonbucket', 'fog_object', '#{@directory.identity}', 'fog_other_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:eucalyptus].copy_object('fognonbucket', 'fog_object', @directory.identity, 'fog_other_object')
    end

    tests("#copy_object('#{@directory.identity}', 'fog_non_object', '#{@directory.identity}', 'fog_other_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:eucalyptus].copy_object(@directory.identity, 'fog_non_object', @directory.identity, 'fog_other_object')
    end

    tests("#copy_object('#{@directory.identity}', 'fog_object', 'fognonbucket', 'fog_other_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:eucalyptus].copy_object(@directory.identity, 'fog_object', 'fognonbucket', 'fog_other_object')
    end

    tests("#get_object('fognonbucket', 'fog_non_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:eucalyptus].get_object('fognonbucket', 'fog_non_object')
    end

    tests("#get_object('#{@directory.identity}', 'fog_non_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:eucalyptus].get_object(@directory.identity, 'fog_non_object')
    end

    tests("#head_object('fognonbucket', 'fog_non_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:eucalyptus].head_object('fognonbucket', 'fog_non_object')
    end

    tests("#head_object('#{@directory.identity}', 'fog_non_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:eucalyptus].head_object(@directory.identity, 'fog_non_object')
    end

    tests("#delete_object('fognonbucket', 'fog_non_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:eucalyptus].delete_object('fognonbucket', 'fog_non_object')
    end

    tests("#put_object_acl('#{@directory.identity}', 'fog_object', 'invalid')").raises(Excon::Errors::BadRequest) do
      Fog::Storage[:eucalyptus].put_object_acl('#{@directory.identity}', 'fog_object', 'invalid')
    end

  end

  @directory.destroy

end
