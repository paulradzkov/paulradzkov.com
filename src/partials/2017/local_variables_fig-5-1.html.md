---
---

```less
// так нельзя

@txt-color: white;

.page-settings() {
    // тут рекурсия и ошибка компиляции
    @txt-color: @txt-color;
}
```
