module Fog
  module Parsers
    module Compute
      module Eucalyptus

        class DeregisterImage < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'return', 'requestId', 'imageId'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
