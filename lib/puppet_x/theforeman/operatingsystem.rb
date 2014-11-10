require 'oauth'
require 'json'
require 'puppet_x/theforeman/resource'

module PuppetX
module TheForeman
module Resources

  class OperatingSystems < Resource

    def initialize(resource)
      super(resource)
    end

    def create(os_hash)
      post_data = os_hash.to_json
      request(:post, "#{resource[:base_url]}/api/v2/operatingsystems", token, {}, post_data, headers)
    end

    def read(id=nil)
      if id
        os = request(:get, "#{resource[:base_url]}/api/v2/operatingsystems/#{id}", token, {})
      else
        os = request(:get, "#{resource[:base_url]}/api/v2/operatingsystems", token, {})
      end

      JSON.parse(os.read_body)
    end

    def update(id, os_hash)
      post_data = os_hash.to_json
      request(:put, "#{resource[:base_url]}/api/v2/operatingsystems/#{id}", token, {}, post_data, headers)
    end

    def delete(id)
      request(:delete, "#{resource[:base_url]}/api/v2/operatingsystems/#{id}", token, {})
    end
  end

end
end
end