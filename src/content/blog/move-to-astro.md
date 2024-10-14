---
author: Shawn Wang
pubDatetime: 2024-10-14
modDatetime: 2024-10-14
title: Switch to astro
slug: switch-to-astro
featured: true
draft: false
tags:
  - astro.js
  - ssg
description:
  Astro.js is awesome. I like it.

---

# Astro.js is awesome.

## Why I choose Astro.js instead of hugo or zola?

- great Markdown support as smilar as hugo/zola
- much flexible to customize
  - like Islands to support multiple UI frameworks like React, Preact, Svelte, Vue, and SolidJS. I'm not a frontend guy, the flexible ability that me to switch between those JS UI frameworks.
- SSG (Static-Site Generating)
  - easy for me to deploy to Github Pages.

But Hugo and Zola still have some small advantages:
- easy to switch themes
- data / layout are much independent

## What I just did?

1. Github Action - withastro/action https://github.com/withastro/action.git
2. astro-paper - astro theme https://github.com/satnaing/astro-paper.git
3. astro-paper with Giscus comments - https://astro-paper.pages.dev/posts/how-to-integrate-giscus-comments/
