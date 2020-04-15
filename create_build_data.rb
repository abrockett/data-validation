#! /usr/bin/env ruby

require 'rally_api'
require 'pp'

@config = {:base_url => "https://abrockett.testn.f4tech.com/slm"}
@config[:username]   = "abrockett@rallydev.com"
@config[:password]   = "Password"
@config[:workspace]  = "Rally"
@config[:project]    = "Hellfish"

def show_some_values(title, builddef)
  values = ["Name", "Description", "Project", "CreationDate"]
  format = "%-12s : %s"

  puts "-" * 80
  puts title
  values.each do |field_name|
    puts format % [field_name, builddef[field_name]]
  end
end

def find_build_defs(rally)
  query = RallyAPI::RallyQuery.new()
  query.type = "builddefinition"
  query.fetch = "Name,CreationDate,Description,Project"
  query.limit      = 10 
  query.page_size  = 10
  query.project_scope_up = false
  query.project_scope_down = false
  query.order = "CreationDate Desc"
  query.query_string = "(Name = \"Hellfish\")"

  results = rally.find(query)
  results.each do |result|
    show_some_values("Result", result)
    puts result.ObjectID
  end
end

begin
  rally = RallyAPI::RallyRestJson.new(@config)

  fields = {}
  fields["Name"] = "Tally Builds"
  fields["Description"] = "Builds for Tally"

  new_builddef = rally.create("builddefinition", fields)
  show_some_values("Created new build definition", new_builddef)

  find_build_defs(rally)

rescue Exception => boom
  puts "Rescued #{boom.class}"
  puts "Error Message: #{boom}"
end
