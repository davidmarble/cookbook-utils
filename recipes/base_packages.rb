# A simple way to add additional base packages.

node[:base_packages].each do |pkg|
    package pkg do
        :upgrade
    end
end
