Shindo.tests("Fog::Compute[:eucalyptus] | key_pair", ['eucalyptus']) do

  model_tests(Fog::Compute[:eucalyptus].key_pairs, {:name => 'fogkeyname'}, true)

  after do
    @keypair.destroy
  end

  tests("new keypair") do
    @keypair = Fog::Compute[:eucalyptus].key_pairs.create(:name => 'testkey')

    test ("writable?") do
      @keypair.writable? == true
    end
  end

  tests("existing keypair") do
    Fog::Compute[:eucalyptus].key_pairs.create(:name => 'testkey')
    @keypair = Fog::Compute[:eucalyptus].key_pairs.get('testkey')

    test("writable?") do
      @keypair.writable? == false
    end
  end


end
