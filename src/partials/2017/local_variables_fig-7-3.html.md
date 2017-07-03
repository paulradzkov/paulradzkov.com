---
---

```scss
// page.scss v0.2

$page-override: ( ); // [1]

@if variable-exists(page-settings) {
    $page-override: $page-settings; // [2]
}

$page-settings:  map-merge((
    padding: 40px,
    bg-color: #fff,
    text-color: #000,
), $page-override); // [3]

.page {
    padding:          map-get($page-settings, padding);
    background-color: map-get($page-settings, bg-color);
    color:            map-get($page-settings, text-color);
}
```
