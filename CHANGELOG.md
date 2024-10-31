## [1.2.0] - 2024-10-31

### Added
- Allow to pass adapter specific options
- Allow to pass `additional_properties` option to JSON Schema generator
- Allow to pass `description` option to JSON Schema generator
- Support for symbol type aliases in attribute mappings

## [1.1.0] - 2024-02-17

### Added
- [bkjohnson] Add support for JSON Schema validation keywords (#29)
- Add support for Ruby 3.3

### Changed
- Drop support for Ruby 2.6 and Ruby 2.7

### Fixed
- Fix Ox adapter incorrectly handling documents with XML declaration

## [1.0.0] - 2023-07-15

### Added
- Support for Ruby 3.2
- Support for delegating fields to nested attributes
- JSON and XML schema namespace mapping support
- Allow to set render_nil defaults

### Changed
- Use `ShaleError` as a base class for exceptions
- Use model instead of mapper names for schema types

### Fixed
- Fix compilation error for bundled JSON schemas
- Fix type inference for XML schema when default namespace is used
- Fix XML schema handling with a period in the element name

## [0.9.0] - 2022-10-31

### Added
- Support for CSV
- Allow to specify version and add encoding to XML declaration
- Support for mapping/generating collections

## [0.8.0] - 2022-08-30

### Added
- Allow to group mappings using `group` block
- Bring back Ruby 2.6 support

### Changed
- Use anonymous module for attributes definition.
  It allows to override accessors and `super` works as expected.

## [0.7.1] - 2022-08-12

### Fixed
- Fix broken handling of Date and Time types

## [0.7.0] - 2022-08-09

### Added
- `only: []` and `except: []` options that allow to controll what attributes are rendered/parsed
- `render_nil: true` option that allows to render nil values
- Allow to pass a context object to extractor/generator methods

### Changed
- Pass whole document to methods for JSON/YAML/TOML so its behavior is consistent with XML mapping
- Convert splat arguments to keyword arguments
- RSpec: enable random spec execution and warnings

## [0.6.0] - 2022-07-05

### Added
- Support for TOML
- Support for CDATA nodes in XML documents
- Support for using custom models

### Fixed
- Allow to map XML content using methods
- Prevent adding default mapping after mapping block was declared

## [0.5.0] - 2022-06-28

### Added
- Allow to generate Shale model from XML Schema

### Changed
- Shale doesn't defaults to REXML anymore - XML adapter needs to be set explicitly
- Rename "JSONSchemaError" to "SchemaError"
- Rename "Composite" type to "Complex"
- Drop support for Ruby 2.6

## [0.4.0] - 2022-05-30

### Added
- Allow to add title to JSON Schema
- Map Shale::Type::Value to "anyType" XML Schema type
- Map Shale::Type::Value to "any" JSON Schema type
- Allow to generate Shale model from JSON Schema

### Changed
- Performance improvements
- Reformat README a little bit and fix typos

### Fixed
- Fix stack overflow caused by circular dependency when generating JSON and XML schemas

## [0.3.1] - 2022-04-29

### Changed
- Rename `id` -> `$id` and add info about supported JSON Schema dialect

## [0.3.0] - 2022-04-29

### Added
- Support for XML namespaces
- Add option to pretty print JSON and XML and to include XML declaration
- Add support for generating JSON and XML Schema

### Changed
- Various fixes to documentation
- Rename `hash` -> `hsh` (`hash` is used internally by Ruby)
- Rename `Shale::Type::Base` -> `Shale::Type::Value`
- Use ISO 8601 format for date and time in JSON, YAML and XML

## [0.2.2] - 2022-03-06

### Fixed
- Fix handling of blank attributes in XML format
- Fix incorrect types in README examples

## [0.2.1] - 2022-02-06

### Fixed
- Fix attribute declaration causing problems in some runtimes (e.g Opal)

## [0.2.0] - 2022-01-20

### Added
- Support for using methods to extract/generate data from/to document

### Changed
- deduplicate code
- Rename `Shale::Type::Complex` -> `Shale::Type::Composite`

## [0.1.0] - 2021-11-30

First public release
