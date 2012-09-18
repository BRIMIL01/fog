module Fog
  module Compute
    class Eucalyptus
      class Real

        require 'fog/aws/parsers/compute/get_console_output'

        # Retrieve console output for specified instance
        #
        # ==== Parameters
        # * instance_id<~String> - Id of instance to get console output from
        #
        # ==== Returns
        # # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'instanceId'<~String> - Id of instance
        #     * 'output'<~String> - Console output
        #     * 'requestId'<~String> - Id of request
        #     * 'timestamp'<~Time> - Timestamp of last update to output
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/EucalyptusEC2/latest/APIReference/ApiReference-query-GetConsoleOutput.html]
        def get_console_output(instance_id)
          request(
            'Action'      => 'GetConsoleOutput',
            'InstanceId'  => instance_id,
            :idempotent   => true,
            :parser       => Fog::Parsers::Compute::Eucalyptus::GetConsoleOutput.new
          )
        end

      end

      class Mock

        def get_console_output(instance_id)
          response = Excon::Response.new
          if instance = self.data[:instances][instance_id]
            response.status = 200
            response.body = {
              'instanceId'    => instance_id,
              'output'        => (Time.now - instance['launchTime'] >= Fog::Mock.delay) ? nil : Fog::Eucalyptus::Mock.console_output,
              'requestId'     => Fog::Eucalyptus::Mock.request_id,
              'timestamp'     => Time.now
            }
            response
          else;
            raise Fog::Compute::Eucalyptus::NotFound.new("The instance ID '#{instance_id}' does not exist")
          end
        end

      end
    end
  end
end
