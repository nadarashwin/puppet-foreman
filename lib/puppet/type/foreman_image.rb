require 'uri'

Puppet::Type.newtype(:foreman_image) do

  ensurable

  newparam(:name, :namevar => true) do
    desc ''
  end

  newparam(:base_url) do
    desc ''
    defaultto 'http://localhost'

    validate do |value|
      unless URI.parse(value).is_a?(URI::HTTP)
        fail("Invalid base_url #{value}")
      end
    end
  end

  newparam(:consumer_key) do
    desc ''
    defaultto ''
  end

  newparam(:consumer_secret) do
    desc ''
    defaultto ''
  end

  newparam(:effective_user) do
    desc ''
    defaultto 'admin'
  end

  newparam(:username) do
    desc ''
    defaultto ''
  end

  newparam(:password) do
    desc ''
    defaultto ''
  end


  newparam(:compute_resource) do
    desc ''
    defaultto ''
  end

  newparam(:architecture) do
    desc ''
    defaultto ''
  end

  newparam(:operatingsystem) do
    desc ''
    defaultto ''
  end
end
