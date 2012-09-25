Shindo.tests('Eucalyptus::IAM | access key requests', ['eucalyptus']) do

  Fog::Eucalyptus[:iam].create_user('fog_access_key_tests')

  tests('success') do

    @access_key_format = {
      'AccessKey' => {
        'AccessKeyId'     => String,
        'UserName'        => String,
        'SecretAccessKey' => String,
        'Status'          => String
      },
      'RequestId' => String
    }

    tests("#create_access_key('UserName' => 'fog_access_key_tests')").formats(@access_key_format) do
      data = Fog::Eucalyptus[:iam].create_access_key('UserName' => 'fog_access_key_tests').body
      @access_key_id = data['AccessKey']['AccessKeyId']
      data
    end

    @access_keys_format = {
      'AccessKeys' => [{
        'AccessKeyId' => String,
        'Status'      => String
      }],
      'IsTruncated' => Fog::Boolean,
      'RequestId'   => String
    }

    tests("#list_access_keys('Username' => 'fog_access_key_tests')").formats(@access_keys_format) do
      Fog::Eucalyptus[:iam].list_access_keys('UserName' => 'fog_access_key_tests').body
    end

    tests("#update_access_key('#{@access_key_id}', 'Inactive', 'UserName' => 'fog_access_key_tests')").formats(Eucalyptus::IAM::Formats::BASIC) do
      pending if Fog.mocking?
      Fog::Eucalyptus[:iam].update_access_key(@access_key_id, 'Inactive', 'UserName' => 'fog_access_key_tests').body
    end

    tests("#delete_access_key('#{@access_key_id}', 'UserName' => 'fog_access_key_tests)").formats(Eucalyptus::IAM::Formats::BASIC) do
      Fog::Eucalyptus[:iam].delete_access_key(@access_key_id, 'UserName' => 'fog_access_key_tests').body
    end

  end

  tests('failure') do
    test('failing conditions')
  end

  Fog::Eucalyptus[:iam].delete_user('fog_access_key_tests')

end
