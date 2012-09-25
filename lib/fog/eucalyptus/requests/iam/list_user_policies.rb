module Fog
  module Eucalyptus
    class IAM
      class Real

        require 'fog/eucalyptus/parsers/iam/list_policies'

        # List policies for a user
        # 
        # ==== Parameters
        # * user_name<~String> - Name of user to list policies for
        # * options<~Hash>: Optional
        #   * 'Marker'<~String>: used to paginate subsequent requests
        #   * 'MaxItems'<~Integer>: limit results to this number per page
        #   * 'PathPrefix'<~String>: prefix for filtering results
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'PolicyNames'<~Array> - Matching policy names
        #     * 'IsTruncated<~Boolean> - Whether or not results were truncated
        #     * 'Marker'<~String> - appears when IsTruncated is true as the next marker to use
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_ListUserPolicies.html
        #
        def list_user_policies(user_name, options = {})
          request({
            'Action'    => 'ListUserPolicies',
            'UserName'  => user_name,
            :parser     => Fog::Parsers::Eucalyptus::IAM::ListPolicies.new
          }.merge!(options))
        end

      end

      class Mock

        def list_user_policies(user_name, options = {})
          #FIXME: doesn't use options atm
          if data[:users].has_key? user_name
            Excon::Response.new.tap do |response|
              response.body = { 'PolicyNames' => data[:users][user_name][:policies].keys,
                                'IsTruncated' => false,
                                'RequestId'   => Fog::Eucalyptus::Mock.request_id }
              response.status = 200
            end
          else
            raise Fog::Eucalyptus::IAM::NotFound.new("The user with name #{user_name} cannot be found.")
          end
        end

      end
    end
  end
end
