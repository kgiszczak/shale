require 'benchmark/ips'
require 'json'
require 'oj'
require 'yaml'
require 'rexml/document'
require 'nokogiri'
require 'ox'

require_relative 'lib/data_model'
require 'shale/adapter/nokogiri'
require 'shale/adapter/ox'

json = File.read('./data/report.json')
yaml = File.read('./data/report.yml')
xml = File.read('./data/report.xml')
hash = Report.from_json(json).to_hash

report_xml = Report.from_xml(xml)

rexml_doc = REXML::Document.new(xml, ignore_whitespace_nodes: :all)
nokogiri_doc = Nokogiri::XML::Document.parse(xml) do |config|
  config.noblanks
end
ox_doc = Ox.parse(xml)

Benchmark.ips do |x|
  x.report('JSON parse') do
    JSON.parse(json)
  end

  x.report('JSON parse') do
    Oj.load(json)
  end

  x.report('YAML parse') do
    YAML.load(yaml)
  end

  x.report('REXML parse') do
    REXML::Document.new(xml, ignore_whitespace_nodes: :all)
  end

  x.report('Nokogiri parse') do
    Nokogiri::XML(xml)
  end

  x.report('Ox parse') do
    ::Ox.parse(xml)
  end

  x.report('Shale from_hash') do
    Report.from_hash(hash)
  end

  x.report('Shale from_json') do
    Report.from_json(json)
  end

  x.report('Shale from_yaml') do
    Report.from_yaml(yaml)
  end

  x.report('from_xml(REXML)') do
    Shale.xml_adapter = Shale::Adapter::REXML
    Report.from_xml(xml)
  end

  x.report('from_xml(Nokogiri)') do
    Shale.xml_adapter = Shale::Adapter::Nokogiri
    Report.from_xml(xml)
  end

  x.report('from_xml(Ox)') do
    Shale.xml_adapter = Shale::Adapter::Ox
    Report.from_xml(xml)
  end
end

Benchmark.ips do |x|
  x.report('REXML dump') do
    rexml_doc.to_s
  end

  x.report('Nokogiri dump') do
    nokogiri_doc.to_xml
  end

  x.report('Ox dump') do
    Ox.dump(ox_doc)
  end

  x.report('to_xml(REXML)') do
    Shale.xml_adapter = Shale::Adapter::REXML
    report_xml.to_xml
  end

  x.report('to_xml(Nokogiri)') do
    Shale.xml_adapter = Shale::Adapter::Nokogiri
    report_xml.to_xml
  end

  x.report('to_xml(Ox)') do
    Shale.xml_adapter = Shale::Adapter::Ox
    report_xml.to_xml
  end
end
