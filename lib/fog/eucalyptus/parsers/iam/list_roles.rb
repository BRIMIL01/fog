module Fog
  module Parsers
    module Eucalyptus
      module IAM

        require 'fog/eucalyptus/parsers/iam/role_parser'
        class ListRoles < Fog::Parsers::Eucalyptus::IAM::RoleParser

          def reset
            super
            @response = { 'Roles' => [] }
          end

          def finished_role(role)
            @response['Roles'] << role
          end
          
          def end_element(name)
            case name
            when 'RequestId', 'Marker'
              @response[name] = value
            when 'IsTruncated'
              @response[name] = (value == 'true')
            end
            super
          end
        end
      end
    end
  end
end
