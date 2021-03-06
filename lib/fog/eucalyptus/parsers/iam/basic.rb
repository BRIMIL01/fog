module Fog
  module Parsers
    module Eucalyptus
      module IAM

        class Basic < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'RequestId'
              @response[name] = value
            end
          end

        end
      end
    end
  end
end
