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
