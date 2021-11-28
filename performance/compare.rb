require 'benchmark/ips'
require 'ox'

require_relative 'lib/build_json'
require_relative 'lib/build_nokogiri_css'
require_relative 'lib/build_nokogiri_xpath'
require_relative 'lib/build_ox'
require_relative 'lib/build_rexml'

json = File.read('./data/report.json')
yaml = File.read('./data/report.yml')
xml = File.read('./data/report.xml')

puts "JSON: building object model by hand vs using Shale.from_json\n\n"

Benchmark.ips do |x|
  x.report('build JSON') do
    BuildJson.build_report(JSON.parse(json))
  end

  x.report('Shale from_json') do
    Report.from_json(json)
  end

  x.compare!
end

puts "\n\nYAML: building object model by hand vs using Shale.from_yaml\n\n"

Benchmark.ips do |x|
  x.report('build YAML') do
    BuildJson.build_report(YAML.load(yaml))
  end

  x.report('Shale from_yaml') do
    Report.from_yaml(yaml)
  end

  x.compare!
end

puts "\n\nREXML: building object model by hand vs using Shale.from_xml (REXML adapter)\n\n"

require 'shale/adapter/rexml'
Shale.xml_adapter = Shale::Adapter::REXML

Benchmark.ips do |x|
  x.report('build XML (REXML)') do
    doc = ::REXML::Document.new(xml, ignore_whitespace_nodes: :all)
    BuildRexml.build_report(doc)
  end

  x.report('Shale from_xml') do
    Report.from_xml(xml)
  end

  x.compare!
end

puts "\n\nNokogiri (CSS selectors): building object model by hand vs using Shale.from_xml (Nokogiri adapter)\n\n"

require 'shale/adapter/nokogiri'
Shale.xml_adapter = Shale::Adapter::Nokogiri

Benchmark.ips do |x|
  x.report('build XML (Nokogiri CSS selectors)') do
    doc = ::Nokogiri::XML::Document.parse(xml) do |config|
      config.noblanks
    end
    BuildNokogiriCss.build_report(doc)
  end

  x.report('Shale from_xml') do
    Report.from_xml(xml)
  end

  x.compare!
end

puts "\n\nNokogiri (xpath): building object model by hand vs using Shale.from_xml (Nokogiri adapter)\n"

Benchmark.ips do |x|
  x.report('build XML (Nokogiri xpath)') do
    doc = ::Nokogiri::XML::Document.parse(xml) do |config|
      config.noblanks
    end
    BuildNokogiriXpath.build_report(doc)
  end

  x.report('Shale from_xml') do
    Report.from_xml(xml)
  end

  x.compare!
end

puts "\n\nOx: building object model by hand vs using Shale.from_xml (Ox adapter)\n\n"

require 'shale/adapter/ox'
Shale.xml_adapter = Shale::Adapter::Ox

Benchmark.ips do |x|
  x.report('build XML (Ox)') do
    doc = Ox.parse(xml)
    BuildOx.build_report(doc)
  end

  x.report('Shale from_xml') do
    Report.from_xml(xml)
  end

  x.compare!
end
