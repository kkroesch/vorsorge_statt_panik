## 🧠 Ziel

Markdown:

```markdown
> [!info] Das ist eine Info-Box.
```

wird in LaTeX:

```latex
\begin{infobox}
Das ist eine Info-Box.
\end{infobox}
```

### 📦 1. Lua-Filter `infobox.lua`

```lua
function BlockQuote(el)
  local first = el.content[1]
  if first and first.t == 'Para' and #first.c > 0 then
    local span = first.c[1]
    if span.t == 'Str' and span.text:match("^%[!%a+%]") then
      local box_type = span.text:match("^%[!(%a+)%]")
      -- Remove the marker from the content
      table.remove(first.c, 1)
      -- Optional: remove space if needed
      if first.c[1] and first.c[1].t == 'Space' then
        table.remove(first.c, 1)
      end
      -- Map box type to LaTeX environment name
      local env = string.lower(box_type) .. "box"
      return pandoc.RawBlock('latex', '\\begin{' .. env .. '}\n' .. pandoc.write(pandoc.Pandoc(el.content), 'latex') .. '\n\\end{' .. env .. '}')
    end
  end
end
```

---

### 📁 2. Datei speichern

Speichere den Filter als `infobox.lua` im selben Verzeichnis wie dein Markdown- oder `.tex`-Projekt.

---

### 📤 3. LaTeX-Umgebungen definieren

Füge in deine `main.tex` oder über `--include-in-header` folgende LaTeX-Definition ein (Beispiel mit `tcolorbox`):

```latex
\usepackage[most]{tcolorbox}
\tcbset{colback=blue!5, colframe=blue!50!black, boxrule=0.5pt, arc=2pt}

\newtcolorbox{infobox}{title=Info}
\newtcolorbox{warnbox}{title=Warnung, colback=red!5, colframe=red!70!black}
\newtcolorbox{notebox}{title=Hinweis, colback=gray!10, colframe=gray!80}
```

Du kannst beliebig weitere Typen definieren (`tipbox`, `dangerbox`, etc.).

---

### 🧪 4. Aufruf mit Pandoc

```bash
pandoc -s kapitel1.md -o kapitel1.tex --lua-filter=infobox.lua
```

Du kannst auch direkt nach PDF konvertieren:

```bash
pandoc -s kapitel1.md -o kapitel1.pdf --lua-filter=infobox.lua --pdf-engine=lualatex
```

---

### ✅ Ergebnis

```markdown
> [!info] Das ist eine Info-Box.
> [!warn] Achtung, etwas stimmt nicht!
```

Erzeugt stilisierte Boxen im PDF.
