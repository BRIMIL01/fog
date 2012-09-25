Shindo.tests('Eucalyptus::IAM | server certificate requests', ['eucalyptus']) do
  @key_name = 'fog-test'
  @key_name_chained = 'fog-test-chained'

  @certificate_format = {
    'Arn' => String,
    'Path' => String,
    'ServerCertificateId' => String,
    'ServerCertificateName' => String,
    'UploadDate' => Time
  }
  @upload_format = {
    'Certificate' => @certificate_format,
    'RequestId' => String
  }
  @get_server_certificate_format = {
    'Certificate' => @certificate_format,
    'RequestId' => String
  }
  @list_format = {
    'Certificates' => [@certificate_format]
  }

  tests('#upload_server_certificate') do
    public_key  = Eucalyptus::IAM::SERVER_CERT_PUBLIC_KEY
    private_key = Eucalyptus::IAM::SERVER_CERT_PRIVATE_KEY
    private_key_pkcs8 = Eucalyptus::IAM::SERVER_CERT_PRIVATE_KEY_PKCS8
    private_key_mismatch = Eucalyptus::IAM::SERVER_CERT_PRIVATE_KEY_MISMATCHED

    tests('empty public key').raises(Fog::Eucalyptus::IAM::ValidationError) do
      Fog::Eucalyptus::IAM.new.upload_server_certificate('', private_key, @key_name)
    end

    tests('empty private key').raises(Fog::Eucalyptus::IAM::ValidationError) do
      Fog::Eucalyptus::IAM.new.upload_server_certificate(public_key, '', @key_name)
    end

    tests('invalid public key').raises(Fog::Eucalyptus::IAM::MalformedCertificate) do
      Fog::Eucalyptus::IAM.new.upload_server_certificate('abcde', private_key, @key_name)
    end

    tests('invalid private key').raises(Fog::Eucalyptus::IAM::MalformedCertificate) do
      Fog::Eucalyptus::IAM.new.upload_server_certificate(public_key, 'abcde', @key_name)
    end

    tests('non-RSA private key').raises(Fog::Eucalyptus::IAM::MalformedCertificate) do
      Fog::Eucalyptus::IAM.new.upload_server_certificate(public_key, private_key_pkcs8, @key_name)
    end

    tests('mismatched private key').raises(Fog::Eucalyptus::IAM::KeyPairMismatch) do
      Fog::Eucalyptus::IAM.new.upload_server_certificate(public_key, private_key_mismatch, @key_name)
    end

    tests('format').formats(@upload_format) do
      Fog::Eucalyptus::IAM.new.upload_server_certificate(public_key, private_key, @key_name).body
    end

    tests('format with chain').formats(@upload_format) do
      Fog::Eucalyptus::IAM.new.upload_server_certificate(public_key, private_key, @key_name_chained, { 'CertificateChain' => public_key }).body
    end

    tests('duplicate name').raises(Fog::Eucalyptus::IAM::EntityAlreadyExists) do
      Fog::Eucalyptus::IAM.new.upload_server_certificate(public_key, private_key, @key_name)
    end
  end

  tests('#get_server_certificate').formats(@get_server_certificate_format) do
    tests('raises NotFound').raises(Fog::Eucalyptus::IAM::NotFound) do
      Fog::Eucalyptus::IAM.new.get_server_certificate("#{@key_name}fake")
    end
    Fog::Eucalyptus::IAM.new.get_server_certificate(@key_name).body
  end

  tests('#list_server_certificates').formats(@list_format) do
    result = Fog::Eucalyptus::IAM.new.list_server_certificates.body
    tests('includes key name') do
      returns(true) { result['Certificates'].any?{|c| c['ServerCertificateName'] == @key_name} }
    end
    result
  end

  tests("#list_server_certificates('path-prefix' => '/'").formats(@list_format) do
    result = Fog::Eucalyptus::IAM.new.list_server_certificates('PathPrefix' => '/').body
    tests('includes key name') do
      returns(true) { result['Certificates'].any?{|c| c['ServerCertificateName'] == @key_name} }
    end
    result
  end

  tests('#delete_server_certificate').formats(Eucalyptus::IAM::Formats::BASIC) do
    Fog::Eucalyptus::IAM.new.delete_server_certificate(@key_name).body
  end

  Fog::Eucalyptus::IAM.new.delete_server_certificate(@key_name_chained)
end
