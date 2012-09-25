module Fog
  module Eucalyptus
    class IAM
      class Real

        require 'fog/eucalyptus/parsers/iam/basic'

        # Updates a login profile for a user
        # 
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_UpdateLoginProfile.html
        # ==== Parameters
        # * user_name<~String> - Name of user to change the login profile for
        # * password<~String> - The new password for this user
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'RequestId'<~String> - Id of the request
        #
        #
        def update_login_profile(user_name, password)
          request({
            'Action'    => 'UpdateLoginProfile',
            'UserName'  => user_name,
            'Password'  => password,
            :parser     => Fog::Parsers::Eucalyptus::IAM::Basic.new
          })
        end

      end
    end
  end
end
