Puppet::Type.type(:foreman_config_template).provide(:rest) do

  confine :true => begin
    begin
      require 'oauth'
      require 'json'
      require 'puppet_x/theforeman/operatingsystem'
      require 'puppet_x/theforeman/config_template'
      true
    rescue LoadError
      false
    end
  end
  
  mk_resource_methods

  def initialize(value={})
    super(value)
  end

  def self.config_templates
   PuppetX::TheForeman::Resources::ConfigTemplates.new(nil)
  end

  def self.operating_systems
    PuppetX::TheForeman::Resources::OperatingSystems.new(nil)
  end

  def self.instances
    config = config_templates.read
    config.collect do |s|
      template_hash = {
        :name             => s['name'],
        :ensure           => :present,
        :id               => s['id'],
        :template         => s['template'],
        :snippet          => s['snippet'],
        :type             => (s['template_kind_name'] ? s['template_kind_name'] : ''),
        :operatingsystems => (s['operatingsystems'] ? os_descriptions(s['operatingsystems']) : [])
      }
      new(template_hash)
    end
  end

  def self.prefetch(resources)
    templates = instances
    resources.keys.each do |template|
      if provider = templates.find {|t| t.name == template }
        resources[template].provider = provider
      end
    end
  end

  def self.os_descriptions(os_array)
    names = []
    os_list = operating_systems.read
    os_array.each do |os|
      os_list.each do |fos|
        if os['id'].eql?(fos['id'])
          names.push(fos['description'])
        end
      end
    end
    return names.sort!
  end

  def os_lookup(os_array)
    os_values = []
    os_list = self.class.operating_systems.read
    os_array.each do |os|
      os_list.each do |fos|
        if os.eql?(fos['description'])
          os_values.push(fos)
        end
      end
    end
 
    return os_values
  end

  def template_id(name)
    templates = [
      { :id => 1, :name => 'PXELinux'},
      { :id => 2, :name => 'PXEGrub'},
      { :id => 3, :name => 'iPXE'},
      { :id => 4, :name => 'provision'},
      { :id => 5, :name => 'finish'},
      { :id => 6, :name => 'script'},
      { :id => 7, :name => 'user_data'},
      { :id => 8, :name => 'ZTP'}
    ]
    
    if !name.eql?('')
      id = templates.find { |t| t[:name] == name.to_s }[:id]
    else
      id = ''
    end
    return id
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    config_hash = {
      'name'               => resource[:name],
      'template'           => resource[:template],
      'snippet'            => resource[:snippet],
      'template_kind_id'   => template_id(resource[:type]),
      'template_kind_name' => resource[:type],
      'operatingsystems'   => os_lookup(resource[:operatingsystems])
    }

    self.class.config_templates.create(config_hash)
  end

  def destroy
    self.class.config_templates.delete(id)
  end
  
  def id
    @property_hash[:id]
  end

  def name=(value)
    self.class.config_templates.update(id, { :name => value })
  end

  def template=(value)
    self.class.config_templates.update(id, { :template => value })
  end

  def snippet=(value)
    self.class.config_templates.update(id, { :snippet => value })
  end

  def type=(value)
    self.class.config_templates.update(id, { :template_kind_id => template_id(value), :template_kind_name => value })
  end

  def operatingsystems=(value)
    self.class.config_templates.update(id, { :operatingsystems => os_lookup(value) })
  end
end
