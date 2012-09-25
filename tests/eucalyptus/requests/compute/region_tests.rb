Shindo.tests('Fog::Compute[:eucalyptus] | region requests', ['eucalyptus']) do

  @regions_format = {
    'regionInfo'  => [{
      'regionEndpoint'  => String,
      'regionName'      => String
    }],
    'requestId'   => String
  }

  tests('success') do

    tests("#describe_regions").formats(@regions_format) do
      Fog::Compute[:eucalyptus].describe_regions.body
    end

    tests("#describe_regions('region-name' => 'eucalyptus')").formats(@regions_format) do
      Fog::Compute[:eucalyptus].describe_regions('region-name' => 'eucalyptus').body
    end

  end

end
