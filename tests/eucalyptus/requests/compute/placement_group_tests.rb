Shindo.tests('Fog::Compute[:eucalyptus] | placement group requests', ['eucalyptus']) do
  @placement_group_format = {
    'requestId'         => String,
    'placementGroupSet' => [{
      'groupName' => String,
      'state'     => String,
      'strategy'  => String
    }]
  }

  tests('success') do
    tests("#create_placement_group('fog_placement_group', 'cluster')").formats(Eucalyptus::Compute::Formats::BASIC) do
      pending if Fog.mocking?
      Fog::Compute[:eucalyptus].create_placement_group('fog_placement_group', 'cluster').body
    end

    tests("#describe_placement_groups").formats(@placement_group_format) do
      pending if Fog.mocking?
      Fog::Compute[:eucalyptus].describe_placement_groups.body
    end

    tests("#describe_placement_groups('group-name' => 'fog_placement_group)").formats(@placement_group_format) do
      pending if Fog.mocking?
      Fog::Compute[:eucalyptus].describe_placement_groups('group-name' => 'fog_security_group').body
    end

    tests("#delete_placement_group('fog_placement_group')").formats(Eucalyptus::Compute::Formats::BASIC) do
      pending if Fog.mocking?
      Fog::Compute[:eucalyptus].delete_placement_group('fog_placement_group').body
    end
  end

  tests('failure') do
    pending if Fog.mocking?

    Fog::Compute[:eucalyptus].create_placement_group('fog_placement_group', 'cluster')

    tests("duplicate #create_placement_group('fog_placement_group', 'cluster')").raises(Fog::Compute::Eucalyptus::Error) do
      Fog::Compute[:eucalyptus].create_placement_group('fog_placement_group', 'cluster')
    end

    tests("#delete_placement_group('not_a_group_name')").raises(Fog::Compute::Eucalyptus::NotFound) do
      Fog::Compute[:eucalyptus].delete_placement_group('not_a_group_name')
    end

    Fog::Compute[:eucalyptus].delete_placement_group('fog_placement_group')
  end
end
