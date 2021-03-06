node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'nodejs'
    Chef::Log.debug("Skipping deploy::nodejs application #{application} as it is not a node.js app")
    next
  end

  template "#{deploy[:deploy_to]}/shared/config/newrelic.js" do
    cookbook 'newrelic'
    source 'newrelic.js.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :application => deploy[:application].gsub('_', '-'),
      :license_key => node[:newrelic][:license],
      :environment => node[:newrelic][:environment],
      :application_type => deploy[:application_type]
    )
  end

  link "#{deploy[:deploy_to]}/current/newrelic.js" do
    action :create
    link_type :symbolic
    to "#{deploy[:deploy_to]}/shared/config/newrelic.js"
  end

end
