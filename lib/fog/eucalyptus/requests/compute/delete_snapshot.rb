module Fog
  module Compute
    class Eucalyptus
      class Real

        require 'fog/eucalyptus/parsers/compute/basic'

        # Delete a snapshot of an EBS volume that you own
        #
        # ==== Parameters
        # * snapshot_id<~String> - ID of snapshot to delete
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/EucalyptusEC2/latest/APIReference/ApiReference-query-DeleteSnapshot.html]
        def delete_snapshot(snapshot_id)
          request(
            'Action'      => 'DeleteSnapshot',
            'SnapshotId'  => snapshot_id,
            :idempotent   => true,
            :parser       => Fog::Parsers::Compute::Eucalyptus::Basic.new
          )
        end

      end

      class Mock

        def delete_snapshot(snapshot_id)
          response = Excon::Response.new
          if snapshot = self.data[:snapshots].delete(snapshot_id)
            response.status = true
            response.body = {
              'requestId' => Fog::Eucalyptus::Mock.request_id,
              'return'    => true
            }
            response
          else
            raise Fog::Compute::Eucalyptus::NotFound.new("The snapshot '#{snapshot_id}' does not exist.")
          end
        end

      end
    end
  end
end
