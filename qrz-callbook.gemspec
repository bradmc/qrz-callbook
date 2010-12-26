# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{qrz-callbook}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brad McConahay"]
  s.date = %q{2010-12-26}
  s.description = %q{A front end for the QRZ.COM Amateur Radio callsign database API.}
  s.email = %q{brad @nospam@ mcconahay.com}
  s.extra_rdoc_files = ["LICENSE.txt", "README.rdoc", "lib/qrz-callbook.rb"]
  s.files = ["LICENSE.txt", "README.rdoc", "Rakefile", "lib/qrz-callbook.rb", "Manifest", "qrz-callbook.gemspec"]
  s.homepage = %q{http://github.com/bradmc/qrz-callbook}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Qrz-callbook", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{qrz-callbook}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A front end for the QRZ.COM Amateur Radio callsign database API.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<xml-simple>, [">= 0"])
    else
      s.add_dependency(%q<xml-simple>, [">= 0"])
    end
  else
    s.add_dependency(%q<xml-simple>, [">= 0"])
  end
end
