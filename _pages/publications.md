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
  <button id="compact-toggle" class="btn btn-sm" type="button">Compact view</button>
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

  // "In brief" summary toggle. Mutually exclusive with the abstract panel:
  // opening one closes the other within the same publication entry.
  document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('a.inbrief').forEach(function (link) {
      link.addEventListener('click', function (e) {
        e.preventDefault();
        var scope = link.closest('.row') || link.closest('li');
        if (!scope) return;
        // Close the abstract panel if it is open.
        var abs = scope.querySelector('.abstract.hidden.open');
        if (abs) abs.classList.remove('open');
        var panel = scope.querySelector('.inbrief-panel');
        if (panel) panel.classList.toggle('open');
      });
    });
    // When abstract / award / bibtex opens, close the in-brief panel.
    document.querySelectorAll('a.abstract, a.award, a.bibtex').forEach(function (link) {
      link.addEventListener('click', function () {
        var scope = link.closest('.row') || link.closest('li');
        if (!scope) return;
        var panel = scope.querySelector('.inbrief-panel.open');
        if (panel) panel.classList.remove('open');
      });
    });
  });

  // Compact view: hide thumbnails, shrink fonts, tighten spacing.
  document.addEventListener('DOMContentLoaded', function () {
    var cbtn = document.getElementById('compact-toggle');
    var pubs = document.querySelector('.publications');
    if (!cbtn || !pubs) return;
    cbtn.addEventListener('click', function () {
      var on = pubs.classList.toggle('compact');
      cbtn.classList.toggle('active', on);
      cbtn.textContent = on ? 'Normal view' : 'Compact view';
    });
    // Default behaviour: unfold a paper's summary below it once the mouse has
    // rested on it for a moment (avoids flicker on quick pass-overs). Skipped in
    // compact view, and only on hover-capable (desktop) devices -- on touch
    // screens hover is unreliable and would swallow the first tap, so there the
    // summary opens via the "In brief" button instead.
    var canHover = window.matchMedia('(hover: hover) and (pointer: fine)').matches;
    if (canHover) {
      var HOVER_DELAY = 800; // ms
      pubs.querySelectorAll('ol.bibliography > li').forEach(function (li) {
        var panel = li.querySelector('.inbrief-panel');
        if (!panel) return;
        var timer = null;
        li.addEventListener('mouseenter', function () {
          if (pubs.classList.contains('compact')) return;
          timer = setTimeout(function () { panel.classList.add('hover-open'); }, HOVER_DELAY);
        });
        li.addEventListener('mouseleave', function () {
          if (timer) { clearTimeout(timer); timer = null; }
          panel.classList.remove('hover-open');
        });
      });
    }
    // In compact view, click a paper's title to reveal/hide its buttons.
    pubs.querySelectorAll('.title').forEach(function (title) {
      title.addEventListener('click', function () {
        if (!pubs.classList.contains('compact')) return;
        var row = title.closest('.row');
        if (row) row.classList.toggle('links-open');
      });
    });
  });
</script>
