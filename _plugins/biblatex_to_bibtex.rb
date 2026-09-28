# frozen_string_literal: true
#
# The bibliography is exported from Zotero as **BibLaTeX** (fields: date,
# journaltitle, eventtitle, eprinttype). jekyll-scholar / bibtex-ruby, however,
# expect **BibTeX** (year, month, journal, booktitle, archiveprefix) and in
# particular need `year` (and `month`) for the year-grouping and month-sorting on
# the publications page.
#
# This generator reads the BibLaTeX file (`_bibliography/papers.bib`) and writes a
# normalized BibTeX file (`_bibliography/papers.generated.bib`) that jekyll-scholar
# actually reads (see `scholar.bibliography` in _config.yml). Just keep exporting
# `papers.bib` from Zotero — this runs on every build.
module Jekyll
  class BiblatexToBibtex < Generator
    priority :highest
    safe true

    MONTHS = %w[jan feb mar apr may jun jul aug sep oct nov dec].freeze

    def generate(site)
      src = File.join(site.source, "_bibliography", "papers.bib")
      dst = File.join(site.source, "_bibliography", "papers.generated.bib")
      return unless File.exist?(src)

      text = File.read(src)

      # date = {YYYY-MM-DD} -> year = {YYYY}, month = <macro>, (keep date too)
      text = text.gsub(/^([ \t]*)date\s*=\s*\{(\d{4})(?:-(\d{2}))?[^}]*\},?/) do
        indent = Regexp.last_match(1)
        year   = Regexp.last_match(2)
        month  = Regexp.last_match(3)
        out = +"#{indent}year = {#{year}},"
        if month
          m = month.to_i
          out << "\n#{indent}month = #{MONTHS[m - 1]}," if m.between?(1, 12)
        end
        out << "\n#{indent}date = {#{year}#{month ? "-#{month}" : ''}},"
        out
      end

      # BibLaTeX field name -> BibTeX field name
      text = text.gsub(/^([ \t]*)journaltitle(\s*=)/) { "#{Regexp.last_match(1)}journal#{Regexp.last_match(2)}" }
      text = text.gsub(/^([ \t]*)eventtitle(\s*=)/)   { "#{Regexp.last_match(1)}booktitle#{Regexp.last_match(2)}" }
      text = text.gsub(/^([ \t]*)eprinttype(\s*=)/)   { "#{Regexp.last_match(1)}archiveprefix#{Regexp.last_match(2)}" }

      # eprint = {2512.18128 [cs]} -> eprint = {2512.18128}  (+ expose as arxiv id)
      text = text.gsub(/^([ \t]*)eprint\s*=\s*\{([^\s\]}]+)[^}]*\},?/) do
        indent = Regexp.last_match(1)
        id = Regexp.last_match(2)
        "#{indent}eprint = {#{id}},\n#{indent}arxiv = {#{id}},"
      end

      File.write(dst, text)
    end
  end
end
