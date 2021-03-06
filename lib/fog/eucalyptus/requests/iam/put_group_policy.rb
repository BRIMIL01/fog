module Fog
  module Eucalyptus
    class IAM
      class Real

        require 'fog/eucalyptus/parsers/iam/basic'

        # Add or update a policy for a group
        # 
        # ==== Parameters
        # * group_name<~String>: name of the group
        # * policy_name<~String>: name of policy document
        # * policy_document<~Hash>: policy document, see: http://docs.amazonwebservices.com/IAM/latest/UserGuide/PoliciesOverview.html
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_PutGroupPolicy.html
        #
        def put_group_policy(group_name, policy_name, policy_document)
          request(
            'Action'          => 'PutGroupPolicy',
            'GroupName'       => group_name,
            'PolicyName'      => policy_name,
            'PolicyDocument'  => Fog::JSON.encode(policy_document),
            :parser           => Fog::Parsers::Eucalyptus::IAM::Basic.new
          )
        end

      end
    end
  end
end
