module Robut::Plugin::Mcollective
  def mc_status(r)
    r[:body][:statuscode]
  end

  def mc_ok?(r)
    mc_status(r) == 0
  end

  def mc_sender(r)
    r[:senderid]
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

module Robut::Plugin::Mcollective::Puppetd
  def puppetd_status(r)
    r[:body][:data][:status]
  end

  def puppetd_status_inactive(r)
    ["disabled", "idling", "stopped"].include? puppetd_status(r)
  end

  def puppetd_status_active(r)
    not puppetd_status_inactive(r)
  end

  def puppetd_lastrun(r)
    r[:body][:data][:lastrun]
  end
end

module Robut::Plugin::Mcollective::Package
  def package_name(r)
    r[:body][:data][:name]
  end

  def package_version(r)
    r[:body][:data][:ensure]
  end
end

module Robut::Plugin::Mcollective::Git
  def git_ok?(r)
    r[:body][:data][:status] == 0
  end

  def git_output(r)
    r[:body][:data][:output]
  end
end

module Robut::Plugin::Mcollective::SphereTools
  def spheretools_ok?(r)
    r[:body][:data][:status] == 0
  end

  def spheretools_output(r)
    r[:body][:data][:output]
  end
end

module Robut::Plugin::Mcollective::Monitoring
  def mon_ok?(r)
    r[:body][:data][:status] == 0
  end
end
