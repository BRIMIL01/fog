module Fog
  module Eucalyptus
    class IAM
      class Real

        require 'fog/eucalyptus/parsers/iam/list_account_aliases'
    
        def list_account_aliases(options = {})
          request({
            'Action'  => 'ListAccountAliases',
            :parser   => Fog::Parsers::Eucalyptus::IAM::ListAccountAliases.new
          }.merge!(options))
        end

      end
    end
  end
end
