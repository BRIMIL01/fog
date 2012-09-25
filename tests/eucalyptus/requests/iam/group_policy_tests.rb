Shindo.tests('Eucalyptus::IAM | group policy requests', ['eucalyptus']) do

  unless Fog.mocking?
    Fog::Eucalyptus[:iam].create_group('fog_group_policy_tests')
  end

  tests('success') do

    @policy = {"Statement" => [{"Effect" => "Allow", "Action" => "*", "Resource" => "*"}]}

    tests("#put_group_policy('fog_group_policy_tests', 'fog_policy', #{@policy.inspect})").formats(Eucalyptus::IAM::Formats::BASIC) do
      pending if Fog.mocking?
      Fog::Eucalyptus[:iam].put_group_policy('fog_group_policy_tests', 'fog_policy', @policy).body
    end

    @group_policies_format = {
      'IsTruncated' => Fog::Boolean,
      'PolicyNames' => [String],
      'RequestId'   => String
    }

    tests("list_group_policies('fog_group_policy_tests')").formats(@group_policies_format) do
      pending if Fog.mocking?
      Fog::Eucalyptus[:iam].list_group_policies('fog_group_policy_tests').body
    end

    tests("#delete_group_policy('fog_group_policy_tests', 'fog_policy')").formats(Eucalyptus::IAM::Formats::BASIC) do
      pending if Fog.mocking?
      Fog::Eucalyptus[:iam].delete_group_policy('fog_group_policy_tests', 'fog_policy').body
    end

  end

  tests('failure') do
    test('failing conditions')
  end

  unless Fog.mocking?
    Fog::Eucalyptus[:iam].delete_group('fog_group_policy_tests')
  end

end
