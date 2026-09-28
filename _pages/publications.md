---
layout: page
permalink: /publications/
title: publications
description:
nav: true
nav_order: 2
---

<!-- _pages/publications.md -->

<!-- Bibsearch Feature -->

{% include bib_search.liquid %}

<div class="pub-filter">
  <button id="firstauthor-toggle" class="btn btn-sm" type="button">Show first-author papers only</button>
</div>

<div class="publications">

{% bibliography %}

</div>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    var btn = document.getElementById('firstauthor-toggle');
    if (!btn) return;
    btn.addEventListener('click', function () {
      var on = btn.classList.toggle('active');
      btn.textContent = on ? 'Show all papers' : 'First-author papers only';
      document.querySelectorAll('ol.bibliography > li').forEach(function (li) {
        var fa = li.querySelector('[data-firstauthor="true"]');
        li.style.display = (on && !fa) ? 'none' : '';
      });
      // Hide year headers whose entries are all filtered out.
      document.querySelectorAll('h2.bibliography').forEach(function (h) {
        var ol = h.nextElementSibling;
        while (ol && ol.tagName !== 'OL') { ol = ol.nextElementSibling; }
        if (!ol) return;
        var anyVisible = Array.prototype.some.call(ol.children, function (li) {
          return li.style.display !== 'none';
        });
        h.style.display = anyVisible ? '' : 'none';
      });
    });
  });

  // "In brief" summary toggle (self-contained; mirrors the abstract toggle).
  document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('a.inbrief').forEach(function (link) {
      link.addEventListener('click', function (e) {
        e.preventDefault();
        var scope = link.closest('.row') || link.closest('li');
        if (!scope) return;
        var panel = scope.querySelector('.inbrief-panel');
        if (panel) panel.classList.toggle('open');
      });
    });
  });
</script>
