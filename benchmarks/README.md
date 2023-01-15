# Performance testing and comparison

Ruby version: ruby 3.2.0 (2022-12-25 revision a528908271) [arm64-darwin22]

### JSON: building object model by hand vs Shale.from_json vs Representable

```
Warming up --------------------------------------
             By hand    25.000  i/100ms
               Shale     7.000  i/100ms
       Representable     2.000  i/100ms
Calculating -------------------------------------
             By hand    259.513  (± 1.9%) i/s -      1.300k in   5.011472s
               Shale     77.509  (± 1.3%) i/s -    392.000  in   5.058519s
       Representable     24.228  (± 0.0%) i/s -    122.000  in   5.036925s

Comparison:
             By hand:      259.5 i/s
               Shale:       77.5 i/s - 3.35x  (± 0.00) slower
       Representable:       24.2 i/s - 10.71x  (± 0.00) slower
```

### JSON: Generating JSON by hand vs Shale.to_json vs Representable

```
Warming up --------------------------------------
             By hand   141.000  i/100ms
               Shale    10.000  i/100ms
       Representable     3.000  i/100ms
Calculating -------------------------------------
             By hand      1.411k (± 1.7%) i/s -      7.191k in   5.097159s
               Shale    106.277  (± 1.9%) i/s -    540.000  in   5.082863s
       Representable     29.835  (± 0.0%) i/s -    150.000  in   5.029009s

Comparison:
             By hand:     1411.2 i/s
               Shale:      106.3 i/s - 13.28x  (± 0.00) slower
       Representable:       29.8 i/s - 47.30x  (± 0.00) slower
```

### Hash: building object model by hand vs Shale.from_hash vs Representable

```
Warming up --------------------------------------
             By hand    71.000  i/100ms
               Shale     9.000  i/100ms
       Representable     2.000  i/100ms
Calculating -------------------------------------
             By hand    712.838  (± 0.7%) i/s -      3.621k in   5.079906s
               Shale     96.503  (± 2.1%) i/s -    486.000  in   5.037626s
       Representable     25.884  (± 3.9%) i/s -    130.000  in   5.024405s

Comparison:
             By hand:      712.8 i/s
               Shale:       96.5 i/s - 7.39x  (± 0.00) slower
       Representable:       25.9 i/s - 27.54x  (± 0.00) slower
```

### Hash: Generating Hash by hand vs Shale.to_hash vs Representable

```
Warming up --------------------------------------
             By hand   142.000  i/100ms
               Shale    11.000  i/100ms
       Representable     3.000  i/100ms
Calculating -------------------------------------
             By hand      1.394k (± 2.8%) i/s -      7.100k in   5.099047s
               Shale    116.401  (± 0.9%) i/s -    583.000  in   5.009173s
       Representable     30.340  (± 3.3%) i/s -    153.000  in   5.044886s

Comparison:
             By hand:     1393.6 i/s
               Shale:      116.4 i/s - 11.97x  (± 0.00) slower
       Representable:       30.3 i/s - 45.93x  (± 0.00) slower
```

### XML: building object model by hand vs Shale.from_xml vs Representable

```
Warming up --------------------------------------
       By hand (CSS)     1.000  i/100ms
     By hand (xpath)     1.000  i/100ms
               Shale     2.000  i/100ms
       Representable     1.000  i/100ms
Calculating -------------------------------------
       By hand (CSS)      6.749  (± 0.0%) i/s -     34.000  in   5.042602s
     By hand (xpath)      9.207  (± 0.0%) i/s -     46.000  in   5.006744s
               Shale     28.294  (± 3.5%) i/s -    142.000  in   5.022104s
       Representable      5.857  (± 0.0%) i/s -     30.000  in   5.135525s

Comparison:
               Shale:       28.3 i/s
     By hand (xpath):        9.2 i/s - 3.07x  (± 0.00) slower
       By hand (CSS):        6.7 i/s - 4.19x  (± 0.00) slower
       Representable:        5.9 i/s - 4.83x  (± 0.00) slower
```

---

Ruby version: ruby 3.2.0 (2022-12-25 revision a528908271) +YJIT [arm64-darwin22]

### JSON: building object model by hand vs Shale.from_json vs Representable

```
Warming up --------------------------------------
             By hand    26.000  i/100ms
               Shale     9.000  i/100ms
       Representable     3.000  i/100ms
Calculating -------------------------------------
             By hand    271.626  (± 1.8%) i/s -      1.378k in   5.074675s
               Shale     98.272  (± 2.0%) i/s -    495.000  in   5.038682s
       Representable     34.393  (± 2.9%) i/s -    174.000  in   5.066939s

Comparison:
             By hand:      271.6 i/s
               Shale:       98.3 i/s - 2.76x  (± 0.00) slower
       Representable:       34.4 i/s - 7.90x  (± 0.00) slower
```

### JSON: Generating JSON by hand vs Shale.to_json vs Representable

```
Warming up --------------------------------------
             By hand   209.000  i/100ms
               Shale    12.000  i/100ms
       Representable     4.000  i/100ms
Calculating -------------------------------------
             By hand      2.081k (± 1.5%) i/s -     10.450k in   5.023058s
               Shale    128.162  (± 2.3%) i/s -    648.000  in   5.058112s
       Representable     43.780  (± 4.6%) i/s -    220.000  in   5.035027s

Comparison:
             By hand:     2080.9 i/s
               Shale:      128.2 i/s - 16.24x  (± 0.00) slower
       Representable:       43.8 i/s - 47.53x  (± 0.00) slower
```

### Hash: building object model by hand vs Shale.from_hash vs Representable

```
Warming up --------------------------------------
             By hand    82.000  i/100ms
               Shale    13.000  i/100ms
       Representable     4.000  i/100ms
Calculating -------------------------------------
             By hand    816.531  (± 1.5%) i/s -      4.100k in   5.022337s
               Shale    129.868  (± 2.3%) i/s -    650.000  in   5.007157s
       Representable     39.971  (± 2.5%) i/s -    200.000  in   5.006888s

Comparison:
             By hand:      816.5 i/s
               Shale:      129.9 i/s - 6.29x  (± 0.00) slower
       Representable:       40.0 i/s - 20.43x  (± 0.00) slower
```

### Hash: Generating Hash by hand vs Shale.to_hash vs Representable

```
Warming up --------------------------------------
             By hand   209.000  i/100ms
               Shale    14.000  i/100ms
       Representable     4.000  i/100ms
Calculating -------------------------------------
             By hand      2.044k (± 2.9%) i/s -     10.241k in   5.013650s
               Shale    144.279  (± 2.1%) i/s -    728.000  in   5.047483s
       Representable     47.764  (± 2.1%) i/s -    240.000  in   5.026905s

Comparison:
             By hand:     2044.4 i/s
               Shale:      144.3 i/s - 14.17x  (± 0.00) slower
       Representable:       47.8 i/s - 42.80x  (± 0.00) slower
```

### XML: building object model by hand vs Shale.from_xml vs Representable

```
Warming up --------------------------------------
       By hand (CSS)     1.000  i/100ms
     By hand (xpath)     1.000  i/100ms
               Shale     2.000  i/100ms
       Representable     1.000  i/100ms
Calculating -------------------------------------
       By hand (CSS)      7.081  (± 0.0%) i/s -     36.000  in   5.098523s
     By hand (xpath)      9.104  (±11.0%) i/s -     46.000  in   5.086781s
               Shale     27.464  (± 3.6%) i/s -    138.000  in   5.034970s
       Representable      6.938  (± 0.0%) i/s -     35.000  in   5.059458s

Comparison:
               Shale:       27.5 i/s
     By hand (xpath):        9.1 i/s - 3.02x  (± 0.00) slower
       By hand (CSS):        7.1 i/s - 3.88x  (± 0.00) slower
       Representable:        6.9 i/s - 3.96x  (± 0.00) slower
```
