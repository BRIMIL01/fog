module Fog
  module Compute
    class Eucalyptus
      class Real

        require 'fog/aws/parsers/compute/basic'

        # Delete a spot datafeed subscription
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> id of request
        #     * 'return'<~Boolean> - success?
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/EucalyptusEC2/latest/APIReference/ApiReference-query-DeleteSpotDatafeedSubscription.html]
        def delete_spot_datafeed_subscription
          request(
            'Action'    => 'DeleteSpotDatafeedSubscription',
            :idempotent => true,
            :parser     => Fog::Parsers::Compute::Eucalyptus::Basic.new
          )
        end

      end
    end
  end
end
