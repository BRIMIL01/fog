module Fog
  module Compute
    class Eucalyptus
      class Real

        require 'fog/eucalyptus/parsers/compute/create_image'

        # Create a bootable EBS volume AMI
        #
        # ==== Parameters
        # * instance_id<~String> - Instance used to create image.
        # * name<~Name> - Name to give image.
        # * description<~Name> - Description of image.
        # * no_reboot<~Boolean> - Optional, whether or not to reboot the image when making the snapshot
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'imageId'<~String> - The ID of the created AMI.
        #     * 'requestId'<~String> - Id of request.
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/EucalyptusEC2/latest/APIReference/ApiReference-query-CreateImage.html]
        def create_image(instance_id, name, description, no_reboot = false)
          request(
            'Action'            => 'CreateImage',
            'InstanceId'        => instance_id,
            'Name'              => name,
            'Description'       => description,
            'NoReboot'          => no_reboot.to_s,
            :parser             => Fog::Parsers::Compute::Eucalyptus::CreateImage.new
          )
        end
      end

      class Mock
        
        # Usage
        # 
        # Eucalyptus[:compute].create_image("i-ac65ee8c", "test", "something")
        #
        
        def create_image(instance_id, name, description, no_reboot = false)
          response = Excon::Response.new
          if instance_id && !name.empty?
            response.status = 200
            response.body = {
              'requestId' => Fog::Eucalyptus::Mock.request_id,
              'imageId' => Fog::Eucalyptus::Mock.image_id
            }
          else
            response.status = 400
            response.body = {
              'Code' => 'InvalidParameterValue'
            }
            if name.empty?
              response.body['Message'] = "Invalid value '' for name. Must be specified."
            end
          end
          response
        end

      end
    end
  end
end
