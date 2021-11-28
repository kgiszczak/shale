# Performance testing and comparison

### JSON: building object model by hand vs using Shale.from_json

```
Warming up --------------------------------------
          build JSON     2.000  i/100ms
    Shale from_json     2.000  i/100ms
Calculating -------------------------------------
          build JSON     27.075  (± 3.7%) i/s -    136.000  in   5.027236s
     Shale from_json     23.239  (± 4.3%) i/s -    118.000  in   5.081570s

Comparison:
          build JSON:       27.1 i/s
     Shale from_json:       23.2 i/s - 1.17x  (± 0.00) slower
```

### YAML: building object model by hand vs using Shale.from_yaml

```
Warming up --------------------------------------
          build YAML     1.000  i/100ms
     Shale from_yaml     1.000  i/100ms
Calculating -------------------------------------
          build YAML      7.606  (± 0.0%) i/s -     39.000  in   5.129801s
     Shale from_yaml      7.136  (± 0.0%) i/s -     36.000  in   5.049205s

Comparison:
          build YAML:        7.6 i/s
     Shale from_yaml:        7.1 i/s - 1.07x  (± 0.00) slower
```

### REXML: building object model by hand vs using Shale.from_xml (REXML adapter)

```
Warming up --------------------------------------
  build XML (REXML)     1.000  i/100ms
      Shale from_xml     1.000  i/100ms
Calculating -------------------------------------
  build XML (REXML)      0.242  (± 0.0%) i/s -      2.000  in   8.277295s
      Shale from_xml      1.340  (± 0.0%) i/s -      7.000  in   5.281743s

Comparison:
      Shale from_xml:        1.3 i/s
  build XML (REXML):        0.2 i/s - 5.54x  (± 0.00) slower
```

### Nokogiri (CSS selectors): building object model by hand vs using Shale.from_xml (Nokogiri adapter)

```
Warming up --------------------------------------
build XML (Nokogiri CSS selectors)
                         1.000  i/100ms
      Shale from_xml     1.000  i/100ms
Calculating -------------------------------------
build XML (Nokogiri CSS selectors)
                          2.103  (± 0.0%) i/s -     11.000  in   5.236344s
      Shale from_xml      9.222  (± 0.0%) i/s -     47.000  in   5.105769s

Comparison:
      Shale from_xml:        9.2 i/s
build XML (Nokogiri CSS selectors):        2.1 i/s - 4.38x  (± 0.00) slower
```

### Nokogiri (xpath): building object model by hand vs using Shale.from_xml (Nokogiri adapter)

```
Warming up --------------------------------------
build XML (Nokogiri xpath)
                         1.000  i/100ms
      Shale from_xml     1.000  i/100ms
Calculating -------------------------------------
build XML (Nokogiri xpath)
                          2.546  (± 0.0%) i/s -     13.000  in   5.110902s
      Shale from_xml      9.115  (±11.0%) i/s -     46.000  in   5.062700s

Comparison:
      Shale from_xml:        9.1 i/s
build XML (Nokogiri xpath):        2.5 i/s - 3.58x  (± 0.00) slower
```

### Ox: building object model by hand vs using Shale.from_xml (Ox adapter)

```
Warming up --------------------------------------
      build XML (Ox)     1.000  i/100ms
      Shale from_xml     2.000  i/100ms
Calculating -------------------------------------
      build XML (Ox)     11.767  (± 8.5%) i/s -     58.000  in   5.018461s
      Shale from_xml     20.396  (± 4.9%) i/s -    102.000  in   5.025036s

Comparison:
      Shale from_xml:       20.4 i/s
      build XML (Ox):       11.8 i/s - 1.73x  (± 0.00) slower
```
