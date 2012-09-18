module Fog
  module Parsers
    module Compute
      module Eucalyptus

        class RegisterImage < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'requestId', 'imageId'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
