module Fog
  module Eucalyptus
    class IAM
      class Real

        require 'fog/eucalyptus/parsers/iam/list_policies'

        # List policies for a group
        # 
        # ==== Parameters
        # * group_name<~String> - Name of group to list policies for
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
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_ListGroupPolicies.html
        #
        def list_group_policies(group_name, options = {})
          request({
            'Action'    => 'ListGroupPolicies',
            'GroupName' => group_name,
            :parser     => Fog::Parsers::Eucalyptus::IAM::ListPolicies.new
          }.merge!(options))
        end

      end
    end
  end
end
