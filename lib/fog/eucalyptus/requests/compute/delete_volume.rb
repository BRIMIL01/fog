module Fog
  module Compute
    class Eucalyptus
      class Real

        require 'fog/eucalyptus/parsers/compute/basic'

        # Delete an EBS volume
        #
        # ==== Parameters
        # * volume_id<~String> - Id of volume to delete.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/EucalyptusEC2/latest/APIReference/ApiReference-query-DeleteVolume.html]
        def delete_volume(volume_id)
          request(
            'Action'    => 'DeleteVolume',
            'VolumeId'  => volume_id,
            :idempotent => true,
            :parser     => Fog::Parsers::Compute::Eucalyptus::Basic.new
          )
        end

      end

      class Mock

        def delete_volume(volume_id)
          response = Excon::Response.new
          if volume = self.data[:volumes][volume_id]
            if volume["attachmentSet"].any?
              attach = volume["attachmentSet"].first
              raise Fog::Compute::Eucalyptus::Error.new("Client.VolumeInUse => Volume #{volume_id} is currently attached to #{attach["instanceId"]}")
            end
            self.data[:deleted_at][volume_id] = Time.now
            volume['status'] = 'deleting'
            response.status = 200
            response.body = {
              'requestId' => Fog::Eucalyptus::Mock.request_id,
              'return'    => true
            }
            response
          else
            raise Fog::Compute::Eucalyptus::NotFound.new("The volume '#{volume_id}' does not exist.")
          end
        end

      end
    end
  end
end
