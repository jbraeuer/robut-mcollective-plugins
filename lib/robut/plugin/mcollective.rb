module Robut::Plugin::Mcollective
  def mc_status(r)
    r[:body][:statuscode]
  end

  def mc_ok?(r)
    mc_status(r) == 0
  end
end

module Robut::Plugin::Mcollective::Packages
  def packages_build_args(pkg)
    { :packages => [{"name" => pkg, "version" => nil, "release" => nil}] }
  end

  def packages_status(r)
    r[:body][:data]["status"]
  end

  def packages_packages(r)
    r[:body][:data][:packages]
  end

  def packages_ok?(r)
    packages_status(r) == 0
  end
end

module Robut::Plugin::Mcollective::Service
  def service_build_args(pkg)
    { :service => pkg }
  end
end

