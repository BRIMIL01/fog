module Fog
  module Eucalyptus
    class IAM
      class Real

        require 'fog/eucalyptus/parsers/iam/upload_server_certificate'

        # Uploads a server certificate entity for the Eucalyptus Account.
        # Includes a public key certificate, a private key, and an optional certificate chain, which should all be PEM-encoded.
        #
        # ==== Parameters
        # * certificate<~Hash>: The contents of the public key certificate in PEM-encoded format.
        # * private_key<~Hash>: The contents of the private key in PEM-encoded format.
        # * name<~Hash>: The name for the server certificate. Do not include the path in this value.
        # * options<~Hash>:
        #   * 'CertificateChain'<~String> - The contents of the certificate chain. Typically a concatenation of the PEM-encoded public key certificates of the chain.
        #   * 'Path'<~String> - The path for the server certificate.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'Certificate'<~Hash>:
        #       * 'Arn'<~String> -
        #       * 'Path'<~String> -
        #       * 'ServerCertificateId'<~String> -
        #       * 'ServerCertificateName'<~String> -
        #       * 'UploadDate'<~Time>
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/index.html?API_UploadServerCertificate.html
        #
        def upload_server_certificate(certificate, private_key, name, options = {})
          request({
            'Action'                => 'UploadServerCertificate',
            'CertificateBody'       => certificate,
            'PrivateKey'            => private_key,
            'ServerCertificateName' => name,
            :parser                 => Fog::Parsers::Eucalyptus::IAM::UploadServerCertificate.new
          }.merge!(options))
        end

      end

      class Mock
        def upload_server_certificate(certificate, private_key, name, options = {})
          if certificate.nil? || certificate.empty? || private_key.nil? || private_key.empty?
            raise Fog::Eucalyptus::IAM::ValidationError.new
          end
          response = Excon::Response.new

          # Validate cert and key
          begin
            # must be an RSA private key
            raise OpenSSL::PKey::RSAError unless private_key =~ /BEGIN RSA PRIVATE KEY/

            cert = OpenSSL::X509::Certificate.new(certificate)
            chain = OpenSSL::X509::Certificate.new(options['CertificateChain']) if options['CertificateChain']
            key = OpenSSL::PKey::RSA.new(private_key)
          rescue OpenSSL::X509::CertificateError, OpenSSL::PKey::RSAError => e
            message = if e.is_a?(OpenSSL::X509::CertificateError)
                        "Invalid Public Key Certificate."
                      else
                        "Invalid Private Key."
                      end
            raise Fog::Eucalyptus::IAM::MalformedCertificate.new(message)
          end

          unless cert.check_private_key(key)
            raise Fog::Eucalyptus::IAM::KeyPairMismatch.new
          end

          if self.data[:server_certificates][name]
            raise Fog::Eucalyptus::IAM::EntityAlreadyExists.new
          else
            response.status = 200
            path = options['Path'] || "/"
            data = {
              'Arn' => Fog::Eucalyptus::Mock.arn('iam', self.data[:owner_id], "server-certificate/#{name}"),
              'Path' => path,
              'ServerCertificateId' => Fog::Eucalyptus::IAM::Mock.server_certificate_id,
              'ServerCertificateName' => name,
              'UploadDate' => Time.now
            }
            self.data[:server_certificates][name] = data
            response.body = {
              'Certificate' => data,
              'RequestId' => Fog::Eucalyptus::Mock.request_id
            }
          end

          response
        end
      end
    end
  end
end
