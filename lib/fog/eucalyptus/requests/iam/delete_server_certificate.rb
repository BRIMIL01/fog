module Fog
  module Eucalyptus
    class IAM
      class Real

        require 'fog/eucalyptus/parsers/iam/basic'

        # Deletes the specified server certificate.
        #
        # ==== Parameters
        # * server_certificate_name<~String>: The name of the server certificate you want to delete.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_DeleteServerCertificate.html
        #
        def delete_server_certificate(server_certificate_name)
          request({
            'Action'                => 'DeleteServerCertificate',
            'ServerCertificateName' => server_certificate_name,
            :parser                 => Fog::Parsers::Eucalyptus::IAM::Basic.new
          })
        end

      end

      class Mock
        def delete_server_certificate(server_certificate_name)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'RequestId' => Fog::Eucalyptus::Mock.request_id
          }

          self.data[:server_certificates].delete(server_certificate_name)

          response
        end
      end
    end
  end
end
