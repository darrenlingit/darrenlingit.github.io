-- Run after multibib so names are formatted first. Keep the .bib data reusable.
local function highlight_name(inlines)
  local result = pandoc.List()
  local i = 1
  while i <= #inlines do
    local first, space, last = inlines[i], inlines[i + 1], inlines[i + 2]
    local name, punctuation
    if first and first.t == 'Str' and space and space.t == 'Space'
        and last and last.t == 'Str' then
      if first.text == 'Darren' then
        punctuation = last.text:match('^Lin([,%.]?)$')
        if punctuation then name = 'Darren Lin' end
      elseif first.text == 'Lin,' then
        punctuation = last.text:match('^Darren([,%.]?)$')
        if punctuation then name = 'Lin, Darren' end
      end
    end
    if name then
      result:insert(pandoc.Strong(pandoc.Inlines(name)))
      if punctuation ~= '' then result:insert(pandoc.Str(punctuation)) end
      i = i + 3
    else
      result:insert(inlines[i])
      i = i + 1
    end
  end
  return result
end

function Div(div)
  if div.classes:includes('csl-entry') then
    return div:walk({ Inlines = highlight_name })
  end
end
