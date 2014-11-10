require 'oauth'
require 'json'
require 'puppet_x/theforeman/resource'

module PuppetX
module TheForeman
module Resources

  class PartitionTables < Resource

    def initialize(resource)
      super(resource)
    end

    def create(ptable_hash)
      post_data = ptable_hash.to_json
      request(:post, "#{resource[:base_url]}/api/v2/ptables", token, {}, post_data, headers)
    end

    def read(id=nil)
      if id
        ptable = request(:get, "#{resource[:base_url]}/api/v2/ptables/#{id}", token, {})
      else
        ptable = request(:get, "#{resource[:base_url]}/api/v2/ptables", token, {})
      end

      JSON.parse(ptable.read_body)
    end

    def update(id, ptable_hash)
      post_data = ptable_hash.to_json
      request(:put, "#{resource[:base_url]}/api/v2/ptables/#{id}", token, {}, post_data, headers)
    end

    def delete(id)
      request(:delete, "#{resource[:base_url]}/api/v2/ptables/#{id}", token, {})
    end
  end

end
end
end