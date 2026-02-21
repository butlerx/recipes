# Kitchen Runbook 👨‍🍳

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/butlerx/recipes/blob/main/LICENSE)

> Random recipes I've collected and make — 75+ dishes from around the world Irish, Mexican, Chinese, French, Swedish,
> Indian, Italian, and more.

### 🏠 [Homepage](https://recipes.notthe.cloud)

Built with [Hugo](https://gohugo.io) using the [hugo-recipes](https://github.com/butlerx/hugo-recipes) theme and hosted
on [Cloudflare Pages](https://pages.cloudflare.com).

## 🛠 Development

Requires [mise](https://mise.jdx.dev) for tooling (Hugo, Node, linters).

```sh
mise install
```

```sh
mise run serve
```

```sh
mise run build
```

```sh
mise run check
```

## 🍳 Adding a Recipe

Recipes live in `content/` as Markdown files with YAML frontmatter:

```yaml
---
title: Recipe Name
date: 2024-01-01
tags: [main, italian, vegetarian]
servings: 4
prep_time: 15
cook_time: 30
---
```

Each recipe has an **Ingredients** section and a **Directions** section. Recipes with images go in their own folder
(e.g. `content/my-recipe/index.md` with images alongside).

## 👤 Author

**Cian Butler**

- Website: [cianbutler.ie](https://cianbutler.ie)
- Github: [@butlerx](https://github.com/butlerx)
- Fediverse: [@butlerx@mastodon.ie](https://mastodon.ie/@butlerx)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

Feel free to check the [issues page](https://github.com/butlerx/recipes/issues).

## Show your support

Give a ⭐️ if this project helped you!

## 📝 License

Copyright © 2019 [Cian Butler](https://github.com/butlerx).

This project is [MIT](https://github.com/butlerx/recipes/blob/main/LICENSE) licensed.
