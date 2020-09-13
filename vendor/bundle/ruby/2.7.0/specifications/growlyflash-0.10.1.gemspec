# -*- encoding: utf-8 -*-
# stub: growlyflash 0.10.1 ruby lib

Gem::Specification.new do |s|
  s.name = "growlyflash".freeze
  s.version = "0.10.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["T\u00F5nis Simo".freeze]
  s.date = "2019-05-07"
  s.description = "This gem popups Rails' ActionDispatch::Flash within Bootstrap alert like a growl notification. It serves messages with both of AJAX (XHR) and regular requests inside HTTP headers.".freeze
  s.email = ["anton.estum@gmail.com".freeze]
  s.homepage = "https://github.com/estum/growlyflash".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Popup ActionDispatch::Flash within Bootstrap alert in Rails app like a growl notification.".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<railties>.freeze, [">= 3.2"])
    s.add_runtime_dependency(%q<coffee-rails>.freeze, [">= 3.2.1"])
    s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  else
    s.add_dependency(%q<railties>.freeze, [">= 3.2"])
    s.add_dependency(%q<coffee-rails>.freeze, [">= 3.2.1"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
