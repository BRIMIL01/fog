module Fog
  module Parsers
    module Eucalyptus
      module IAM

        require 'fog/eucalyptus/parsers/iam/role_parser'
        class SingleRole < Fog::Parsers::Eucalyptus::IAM::RoleParser

          def reset
            super
            @response = { 'Role' => {} }
          end

          def finished_role(role)
            @response['Role'] = role
          end

          def end_element(name)
            case name
            when 'RequestId'
              @response[name] = value
            end
            super
          end
        end
      end
    end
  end
end
