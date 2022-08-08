require 'bundler/setup'
require 'benchmark/ips'

require_relative 'lib/from_hash'
require_relative 'lib/to_hash'
require_relative 'lib/build_nokogiri_css'
require_relative 'lib/build_nokogiri_xpath'
require_relative 'lib/build_ox'
require_relative 'lib/build_rexml'
require_relative 'lib/validator'
require_relative 'lib/mappers'
require_relative 'lib/representers'

json = File.read('./data/report.json')
xml = File.read('./data/report.xml')

json_hash = JSON.parse(json)

Validator.validate!(
  FromHash.build_report(json_hash),
  ReportMapper.of_json(json_hash)
)
Validator.validate!(
  FromHash.build_report(json_hash),
  ReportRepresenterJSON.new(Report.new).from_json(json)
)

puts "from_json\n\n"

Benchmark.ips do |x|
  x.report('By hand') do
    FromHash.build_report(JSON.parse(json))
  end

  x.report('Shale') do
    ReportMapper.from_json(json)
  end

  x.report('Representable') do
    ReportRepresenterJSON.new(Report.new).from_json(json)
  end

  x.compare!
end

puts "\n\nto_json\n\n"

report = ReportMapper.of_json(json_hash)

Benchmark.ips do |x|
  x.report('By hand') do
    ToHash.build_report(report)
  end

  x.report('Shale') do
    ReportMapper.to_json(report)
  end

  x.report('Representable') do
    ReportRepresenterJSON.new(report).to_json
  end

  x.compare!
end

puts "\n\nof_json\n\n"

Benchmark.ips do |x|
  x.report('By hand') do
    FromHash.build_report(json_hash)
  end

  x.report('Shale') do
    ReportMapper.of_json(json_hash)
  end

  x.report('Representable') do
    ReportRepresenterJSON.new(Report.new).from_hash(json_hash)
  end

  x.compare!
end

puts "\n\nas_json\n\n"

report = ReportMapper.of_json(json_hash)

Benchmark.ips do |x|
  x.report('By hand') do
    ToHash.build_report(report)
  end

  x.report('Shale') do
    ReportMapper.as_json(report)
  end

  x.report('Representable') do
    ReportRepresenterJSON.new(report).to_hash
  end

  x.compare!
end

puts "\n\nfrom_xml (Nokogiri adapter)\n\n"

require 'shale/adapter/nokogiri'
Shale.xml_adapter = Shale::Adapter::Nokogiri

Benchmark.ips do |x|
  x.report('By hand (CSS)') do
    doc = ::Nokogiri::XML::Document.parse(xml) do |config|
      config.noblanks
    end
    BuildNokogiriCss.build_report(doc)
  end

  x.report('By hand (xpath)') do
    doc = ::Nokogiri::XML::Document.parse(xml) do |config|
      config.noblanks
    end
    BuildNokogiriXpath.build_report(doc)
  end

  x.report('Shale') do
    ReportMapper.from_xml(xml)
  end

  x.report('Representable') do
    ReportRepresenterXML.new(Report.new).from_xml(xml)
  end

  x.compare!
end

puts "\n\nfrom_xml (Ox adapter)\n\n"

require 'shale/adapter/ox'
Shale.xml_adapter = Shale::Adapter::Ox

Benchmark.ips do |x|
  x.report('By hand') do
    doc = Ox.parse(xml)
    BuildOx.build_report(doc)
  end

  x.report('Shale') do
    ReportMapper.from_xml(xml)
  end

  x.compare!
end

puts "\n\nfrom_xml (REXML adapter)\n\n"

require 'shale/adapter/rexml'
Shale.xml_adapter = Shale::Adapter::REXML

Benchmark.ips do |x|
  x.report('By hand') do
    doc = ::REXML::Document.new(xml, ignore_whitespace_nodes: :all)
    BuildRexml.build_report(doc)
  end

  x.report('Shale') do
    ReportMapper.from_xml(xml)
  end

  x.compare!
end
