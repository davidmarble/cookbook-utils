actions :enable

attribute :directory, :kind_of => String, :name_attribute => true

def initialize(*args)
    super
    @action = :enable
end