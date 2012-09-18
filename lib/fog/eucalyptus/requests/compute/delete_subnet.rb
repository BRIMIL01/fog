module Fog
  module Compute
    class Eucalyptus
      class Real

        require 'fog/aws/parsers/compute/delete_subnet'
        # Deletes a subnet from a VPC. You must terminate all running instances in the subnet before deleting it, otherwise Amazon 
        # VPC returns an error
        #
        # ==== Parameters
        # * subnet_id<~String> - The ID of the Subnet you want to delete.
        #
        # === Returns
        # * response<~Excon::Response>:
        # * body<~Hash>:
        # * 'requestId'<~String> - Id of request
        # * 'return'<~Boolean> - Returns true if the request succeeds.
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/EucalyptusEC2/2011-07-15/APIReference/ApiReference-query-DeleteSubnet.html]
        def delete_subnet(subnet_id)
          request(
            'Action' => 'DeleteSubnet',
            'SubnetId' => subnet_id,
            :parser => Fog::Parsers::Compute::Eucalyptus::DeleteSubnet.new
          )
        end
      end
      
      class Mock
        def delete_subnet(subnet_id)
          Excon::Response.new.tap do |response|
            if subnet_id
              self.data[:subnets].reject! { |v| v['subnetId'] == subnet_id }
              response.status = 200
            
              response.body = {
                'requestId' => Fog::Eucalyptus::Mock.request_id,
                'return' => true
              }
            else
              message = 'MissingParameter => '
              message << 'The request must contain the parameter subnet_id'
              raise Fog::Compute::Eucalyptus::Error.new(message)
            end
          end
        end
      end
    end
  end
end
