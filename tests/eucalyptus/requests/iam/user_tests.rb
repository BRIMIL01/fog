Shindo.tests('Eucalyptus::IAM | user requests', ['eucalyptus']) do

  Fog::Eucalyptus[:iam].create_group('fog_user_tests')

  tests('success') do

    @user_format = {
      'User' => {
        'Arn'       => String,
        'Path'      => String,
        'UserId'    => String,
        'UserName'  => String
      },
      'RequestId' => String
    }

    tests("#create_user('fog_user')").formats(@user_format) do
      Fog::Eucalyptus[:iam].create_user('fog_user').body
    end

    @users_format = {
      'Users' => [{
        'Arn'       => String,
        'Path'      => String,
        'UserId'    => String,
        'UserName'  => String
      }],
      'IsTruncated' => Fog::Boolean,
      'RequestId'   => String
    }

    tests("#list_users").formats(@users_format) do
      Fog::Eucalyptus[:iam].list_users.body
    end

    tests("#get_user").formats(@user_format) do
      Fog::Eucalyptus[:iam].get_user('fog_user').body
    end

    tests("#add_user_to_group('fog_user_tests', 'fog_user')").formats(Eucalyptus::IAM::Formats::BASIC) do
      Fog::Eucalyptus[:iam].add_user_to_group('fog_user_tests', 'fog_user').body
    end

    @groups_format = {
      'GroupsForUser' => [{
        'Arn'       => String,
        'GroupId'   => String,
        'GroupName' => String,
        'Path'      => String
      }],
      'IsTruncated' => Fog::Boolean,
      'RequestId'   => String
    }

    tests("#list_groups_for_user('fog_user')").formats(@groups_format) do
      Fog::Eucalyptus[:iam].list_groups_for_user('fog_user').body
    end

    tests("#remove_user_from_group('fog_user_tests', 'fog_user')").formats(Eucalyptus::IAM::Formats::BASIC) do
      Fog::Eucalyptus[:iam].remove_user_from_group('fog_user_tests', 'fog_user').body
    end

    tests("#delete_user('fog_user')").formats(Eucalyptus::IAM::Formats::BASIC) do
      Fog::Eucalyptus[:iam].delete_user('fog_user').body
    end


  end

  tests('failure') do
    test('failing conditions')
  end

  Fog::Eucalyptus[:iam].delete_group('fog_user_tests')

end
