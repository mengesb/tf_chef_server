describe port(443) do
  it { should be_listening }
  its('protocols') { should include 'tcp' }
end

describe port(80) do
  it { should be_listening }
  its('protocols') { should include 'tcp' }
end

describe port(4321) do
  it { should be_listening }
  its('protocols') { should include 'tcp' }
end

describe port(9683) do
  it { should be_listening }
  its('protocols') { should include 'tcp' }
end

describe port(9463) do
  it { should be_listening }
  its('protocols') { should include 'tcp' }
end

describe port(9090) do
  it { should be_listening }
  its('protocols') { should include 'tcp' }
end

describe port(8000)  do
  it { should be_listening }
  its('protocols') { should include 'tcp' }
end

describe port(5432)  do
  it { should be_listening }
  its('protocols') { should include 'tcp' }
end

describe port(5672)  do
  it { should be_listening }
  its('protocols') { should include 'tcp' }
end

describe port(16379)  do
  it { should be_listening }
  its('protocols') { should include 'tcp' }
end

describe package('chef-server-core') do
  it { should be_installed }
  its('version') { should eq '12.11.1-1' }
end

describe package('chef') do
  it { should be_installed }
  its('version') { should eq '12.16.42-1' }
end

describe package('chef-manage') do
  it { should be_installed }
  its('version') { should eq '2.4.4-1' }
end

describe file('/etc/opscode/chef-server.rb') do
  it { should be_file }
  it { should be_owned_by 'root' }
  its('content') { should match(%r{^topology "standalone"$}) }
end

describe file('/var/opt/chef-manage/.license.accepted') do
  it { should exist }
  its('size') { should be 0 }
end

describe file('/var/opt/opscode-reporting/.license.accepted') do
  it { should exist }
  its('size') { should be 0 }
end
