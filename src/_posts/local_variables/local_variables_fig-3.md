```less
// page.less v0.3

.page-settings() {
    @padding: 40px;
    @txt-color: #000;
    @bg-color: #fff;
}

.page {
    .page-settings();

    padding: @padding;
    color: @txt-color;
    background-color: @bg-color;
}
```
