actions :ensure

attribute :groupname, :kind_of => String, :name_attribute => true
attribute :gid, :kind_of => Integer, :default => nil
attribute :members, :kind_of => Array, :default => nil

attribute :groupinfo, :kind_of => Hash, :default => nil

def initialize(*args)
    super
    @action = :ensure
end