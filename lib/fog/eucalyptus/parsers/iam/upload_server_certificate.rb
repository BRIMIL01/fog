module Fog
  module Parsers
    module Eucalyptus
      module IAM

        class UploadServerCertificate < Fog::Parsers::Base

          def reset
            @response = { 'Certificate' => {} }
          end

          def end_element(name)
            case name
            when 'Arn', 'Path', 'ServerCertificateId', 'ServerCertificateName'
              @response['Certificate'][name] = value
            when 'UploadDate'
              @response['Certificate'][name] = Time.parse(value)
            when 'RequestId'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
