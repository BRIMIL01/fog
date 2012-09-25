module Fog
  module Eucalyptus
    class IAM
      class Real

        require 'fog/eucalyptus/parsers/iam/get_user'

        # Get User
        # 
        # ==== Parameters
        # * username<String>
        # * options<~Hash>:
        #   * 'UserName'<~String>: Name of the User. Defaults to current user
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'User'<~Hash> - User
        #       * Arn<~String> -
        #       * UserId<~String> -
        #       * UserName<~String> -
        #       * Path<~String> -
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_Getuser.html
        #
        def get_user(username, options = {})
          request({
            'Action'    => 'GetUser',
            'UserName'  => username,
            :parser     => Fog::Parsers::Eucalyptus::IAM::GetUser.new
          }.merge!(options))
        end

      end
      
      class Mock
        def get_user(user, options = {})
          raise Fog::Eucalyptus::IAM::NotFound.new(
            "The user with name #{user} cannot be found."
          ) unless self.data[:users].key?(user)
          Excon::Response.new.tap do |response|
            response.body = {'User' =>  { 
                                          'UserId'   => data[:users][user][:user_id],
                                          'Path'     => data[:users][user][:path],
                                          'UserName' => user,
                                          'Arn'      => (data[:users][user][:arn]).strip 
                                        },
                             'RequestId'   => Fog::Eucalyptus::Mock.request_id }
            response.status = 200
          end
        end
      end
    end
  end
end
