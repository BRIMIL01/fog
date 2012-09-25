module Fog
  module Compute
    class Eucalyptus
      class Real

        require 'fog/eucalyptus/parsers/compute/describe_instance_status'

        # http://docs.amazonwebservices.com/EucalyptusEC2/latest/APIReference/ApiReference-query-DescribeInstanceStatus.html
        #
        def describe_instance_status(filters = {})
          raise ArgumentError.new("Filters must be a hash, but is a #{filters.class}.") unless filters.is_a?(Hash)
          next_token = filters.delete('nextToken') || filters.delete('NextToken')
          max_results = filters.delete('maxResults') || filters.delete('MaxResults')
          all_instances = filters.delete('includeAllInstances') || filters.delete('IncludeAllInstances')

          params = Fog::Eucalyptus.indexed_request_param('InstanceId', filters.delete('InstanceId'))

          params.merge!(Fog::Eucalyptus.indexed_filters(filters))

          params['NextToken'] = next_token if next_token
          params['MaxResults'] = max_results if max_results
          params['IncludeAllInstances'] = all_instances if all_instances

          request({
            'Action'    => 'DescribeInstanceStatus',
            :idempotent => true,
            :parser     => Fog::Parsers::Compute::Eucalyptus::DescribeInstanceStatus.new
          }.merge!(params))
        end
      end

      class Mock
        def describe_instance_status(filters = {})
          response = Excon::Response.new
          response.status = 200

          response.body = {
            'instanceStatusSet' => [],
            'requestId' => Fog::Eucalyptus::Mock.request_id
          }

          response

        end
      end
    end
  end
end
