actions :ensure

attribute :username, :kind_of => String, :name_attribute => true
attribute :shell, :kind_of => String, :default => nil
attribute :full_name, :kind_of => String, :default => nil
attribute :home, :kind_of => String, :default => nil
attribute :uid, :kind_of => Integer, :default => nil
attribute :system, :kind_of => [ TrueClass, FalseClass ], :default => false
attribute :disabled, :kind_of => [ TrueClass, FalseClass ], :default => false
attribute :key, :kind_of => String, :default => nil
attribute :pubkey, :kind_of => String, :default => nil
attribute :email, :kind_of => String, :default => nil
attribute :ssh_agent, :kind_of => [ TrueClass, FalseClass ], :default => false

# Password can be plain-text or shadow
attribute :password, :kind_of => String, :default => ""

attribute :userinfo, :kind_of => Hash, :default => nil

def initialize(*args)
    super
    @action = :ensure
end