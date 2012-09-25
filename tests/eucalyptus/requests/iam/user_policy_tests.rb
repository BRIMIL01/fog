Shindo.tests('Eucalyptus::IAM | user policy requests', ['eucalyptus']) do

  Fog::Eucalyptus[:iam].create_user('fog_user_policy_tests')

  tests('success') do

    @policy = {"Statement" => [{"Effect" => "Allow", "Action" => "*", "Resource" => "*"}]}

    tests("#put_user_policy('fog_user_policy_tests', 'fog_policy', #{@policy.inspect})").formats(Eucalyptus::IAM::Formats::BASIC) do
      Fog::Eucalyptus[:iam].put_user_policy('fog_user_policy_tests', 'fog_policy', @policy).body
    end

    @user_policies_format = {
      'IsTruncated' => Fog::Boolean,
      'PolicyNames' => [String],
      'RequestId'   => String
    }

    tests("#list_user_policies('fog_user_policy_tests')").formats(@user_policies_format) do
      Fog::Eucalyptus[:iam].list_user_policies('fog_user_policy_tests').body
    end

    @user_policy_format = {
      'UserName' => String,
      'PolicyName' => String,
      'PolicyDocument' => Hash,
    }

    tests("#get_user_policy('fog_user_policy_tests', 'fog_policy'").formats(@user_policy_format) do
      Fog::Eucalyptus[:iam].get_user_policy('fog_policy', 'fog_user_policy_tests').body['Policy']
    end

    tests("#delete_user_policy('fog_user_policy_tests', 'fog_policy')").formats(Eucalyptus::IAM::Formats::BASIC) do
      Fog::Eucalyptus[:iam].delete_user_policy('fog_user_policy_tests', 'fog_policy').body
    end

  end

  tests('failure') do
    test('failing conditions')
  end

  Fog::Eucalyptus[:iam].delete_user('fog_user_policy_tests')

end
