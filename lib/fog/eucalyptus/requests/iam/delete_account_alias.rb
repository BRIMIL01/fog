module Fog
  module Eucalyptus
    class IAM
      class Real

        require 'fog/eucalyptus/parsers/iam/basic'

        def delete_account_alias(account_alias)
          request(
            'Action'    => 'DeleteAccountAlias',
            'AccountAlias' => account_alias,
            :parser     => Fog::Parsers::Eucalyptus::IAM::Basic.new
          )
        end

      end
    end
  end
end
