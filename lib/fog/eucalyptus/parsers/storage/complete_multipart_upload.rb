module Fog
  module Parsers
    module Storage
      module Eucalyptus

        class CompleteMultipartUpload < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'Bucket', 'ETag', 'Key', 'Location'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
