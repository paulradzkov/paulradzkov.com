---
---

```scss
// page.scss

$page-override: ( );

@if variable-exists(page-settings) {
    $page-override: $page-settings;
}

$page-settings:  map-merge((
    padding: 40px,
    bg-color: #fff,
    text-color: #000,
), $page-override);

.page {
    padding:          map-get($page-settings, padding);
    background-color: map-get($page-settings, bg-color);
    color:            map-get($page-settings, text-color);
}
```
