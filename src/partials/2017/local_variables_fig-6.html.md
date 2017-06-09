---
---

```scss
// page.scss

$page-settings: (
    padding: 40px,
    bg-color: #fff,
    text-color: #000,
);

.page {
    padding:          map-get($page-settings, padding);
    background-color: map-get($page-settings, bg-color);
    color:            map-get($page-settings, text-color);
}
```
