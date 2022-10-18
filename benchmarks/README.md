# Performance testing and comparison

### JSON: building object model by hand vs Shale.from_json vs Representable

```
Warming up --------------------------------------
             By hand    25.000  i/100ms
               Shale     8.000  i/100ms
       Representable     2.000  i/100ms
Calculating -------------------------------------
             By hand    254.748  (± 2.4%) i/s -      1.275k in   5.007437s
               Shale     83.587  (± 1.2%) i/s -    424.000  in   5.073456s
       Representable     23.777  (± 0.0%) i/s -    120.000  in   5.049212s

Comparison:
             By hand:      254.7 i/s
               Shale:       83.6 i/s - 3.05x  (± 0.00) slower
       Representable:       23.8 i/s - 10.71x  (± 0.00) slower
```

### JSON: Generating JSON by hand vs Shale.from_json vs Representable

```
Warming up --------------------------------------
             By hand   135.000  i/100ms
               Shale    10.000  i/100ms
       Representable     2.000  i/100ms
Calculating -------------------------------------
             By hand      1.354k (± 0.3%) i/s -      6.885k in   5.083284s
               Shale    107.941  (± 0.9%) i/s -    540.000  in   5.002882s
       Representable     28.491  (± 3.5%) i/s -    144.000  in   5.059841s

Comparison:
             By hand:     1354.4 i/s
               Shale:      107.9 i/s - 12.55x  (± 0.00) slower
       Representable:       28.5 i/s - 47.54x  (± 0.00) slower
```

### Hash: building object model by hand vs Shale.from_hash vs Representable

```
Warming up --------------------------------------
             By hand    77.000  i/100ms
               Shale    10.000  i/100ms
       Representable     2.000  i/100ms
Calculating -------------------------------------
             By hand    770.255  (± 0.3%) i/s -      3.927k in   5.098336s
               Shale    107.286  (± 0.0%) i/s -    540.000  in   5.033357s
       Representable     25.685  (± 0.0%) i/s -    130.000  in   5.061734s

Comparison:
             By hand:      770.3 i/s
               Shale:      107.3 i/s - 7.18x  (± 0.00) slower
       Representable:       25.7 i/s - 29.99x  (± 0.00) slower
```

### Hash: Generating Hash by hand vs Shale.to_hash vs Representable

```
Warming up --------------------------------------
             By hand   134.000  i/100ms
               Shale    11.000  i/100ms
       Representable     3.000  i/100ms
Calculating -------------------------------------
             By hand      1.347k (± 0.5%) i/s -      6.834k in   5.072884s
               Shale    119.426  (± 0.8%) i/s -    605.000  in   5.066094s
       Representable     30.153  (± 0.0%) i/s -    153.000  in   5.074923s

Comparison:
             By hand:     1347.2 i/s
               Shale:      119.4 i/s - 11.28x  (± 0.00) slower
       Representable:       30.2 i/s - 44.68x  (± 0.00) slower
```

### XML: building object model by hand vs Shale.from_xml vs Representable

```
Warming up --------------------------------------
       By hand (CSS)     1.000  i/100ms
     By hand (xpath)     1.000  i/100ms
               Shale     2.000  i/100ms
       Representable     1.000  i/100ms
Calculating -------------------------------------
       By hand (CSS)      6.342  (± 0.0%) i/s -     32.000  in   5.046412s
     By hand (xpath)      8.318  (± 0.0%) i/s -     42.000  in   5.051052s
               Shale     24.931  (± 4.0%) i/s -    126.000  in   5.055790s
       Representable      5.633  (± 0.0%) i/s -     29.000  in   5.157554s

Comparison:
               Shale:       24.9 i/s
     By hand (xpath):        8.3 i/s - 3.00x  (± 0.00) slower
       By hand (CSS):        6.3 i/s - 3.93x  (± 0.00) slower
       Representable:        5.6 i/s - 4.43x  (± 0.00) slower
```
