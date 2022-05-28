require 'benchmark/ips'
require 'ox'

require_relative 'lib/from_hash'
require_relative 'lib/to_hash'
require_relative 'lib/build_nokogiri_css'
require_relative 'lib/build_nokogiri_xpath'
require_relative 'lib/build_ox'
require_relative 'lib/build_rexml'
require_relative 'lib/validator'

json = File.read('./data/report.json')
yaml = File.read('./data/report.yml')
xml = File.read('./data/report.xml')

json_hash = JSON.parse(json)
yaml_hash = YAML.load(yaml)

puts "JSON: building object model by hand vs using Shale.of_json\n\n"

Validator.validate!(FromHash.build_report(json_hash), Report.of_json(json_hash))

Benchmark.ips do |x|
  x.report('build JSON') do
    FromHash.build_report(json_hash)
  end

  x.report('Shale of_json') do
    Report.of_json(json_hash)
  end

  x.compare!
end

puts "JSON: building Hash by hand vs using Shale.as_json\n\n"

report = Report.of_json(json_hash)

Benchmark.ips do |x|
  x.report('build JSON') do
    ToHash.build_report(report)
  end

  x.report('Shale as_json') do
    Report.as_json(report)
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
