--- *lem.theme* Centralized color definitions for Neovim themes and plugins
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev
local M = {}

-- UI
M.ui = {
  bg = "#1d1f21",
  color_column = "#373b41",
  cursor = "#c5c8c6",
  cursor_column = "#373b41",
  cursor_line = "#373b41",
  cursor_line_nr = "#373b41",
  fg = "#c5c8c6",
  line_nr = "#c5c8c6",
  non_text = "#969896",
  special_key = "#282a2e",
  whitespace = "#282a2e",
}

-- Syntax
M.syntax = {
  builtin = "#de935f",
  comment = "#969896",
  constant = "#de935f",
  delimiter = "#c5c8c6",
  character = "#b5bd68",
  ["function"] = "#81a2be",
  keyword = "#b294bb",
  number = "#de935f",
  operator = "#8abeb7",
  preproc = "#de935f",
  property = "#81a2be",
  special = "#8abeb7",
  special_char = "#8abeb7",
  string = "#b5bd68",
  type = "#f0c674",
  variable = "#cc6666",
}

-- Fzf
M.fzf = {
  fg = "#c5c8c6",
  bg = "#1d1f21",
  hl = "#f0c674",
  ["fg+"] = "#ffffff",
  ["bg+"] = "#373b41",
  ["hl+"] = "#f0c674",
  info = "#81a2be",
  border = "#969896",
  query = "#c5c8c6",
  prompt = "#de935f",
  pointer = "#de935f",
  marker = "#81a2be",
  spinner = "#de935f",
  header = "#969896",
  label = "#c5c8c6",
  gutter = "#1d1f21",
}

-- StatusLine
M.statusline = {
  normal_bg = "#c5c8c6",
  normal_fg = "#1d1f21",
  insert_bg = "#b5bd68",
  insert_fg = "#1d1f21",
  visual_bg = "#b294bb",
  visual_fg = "#1d1f21",
  replace_bg = "#cc6666",
  replace_fg = "#1d1f21",
  command_bg = "#de935f",
  command_fg = "#1d1f21",
  terminal_bg = "#81a2be",
  terminal_fg = "#1d1f21",
  section_bg = "#282a2e",
  section_fg = "#c5c8c6",
  inactive_bg = "#282a2e",
  inactive_fg = "#c5c8c6",
}

-- lualine theme
M.lualine_theme = {
  normal = {
    a = { bg = M.statusline.normal_bg, fg = M.statusline.normal_fg },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.statusline.normal_bg, fg = M.statusline.normal_fg },
  },
  insert = {
    a = { bg = M.statusline.insert_bg, fg = M.statusline.insert_fg },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.statusline.insert_bg, fg = M.statusline.insert_fg },
  },
  visual = {
    a = { bg = M.statusline.visual_bg, fg = M.statusline.visual_fg },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.statusline.visual_bg, fg = M.statusline.visual_fg },
  },
  replace = {
    a = { bg = M.statusline.replace_bg, fg = M.statusline.replace_fg },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.statusline.replace_bg, fg = M.statusline.replace_fg },
  },
  command = {
    a = { bg = M.statusline.command_bg, fg = M.statusline.command_fg },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.statusline.command_bg, fg = M.statusline.command_fg },
  },
  terminal = {
    a = { bg = M.statusline.terminal_bg, fg = M.statusline.terminal_fg },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.statusline.terminal_bg, fg = M.statusline.terminal_fg },
  },
  inactive = {
    a = { bg = M.statusline.inactive_bg, fg = M.statusline.inactive_fg },
    b = { bg = M.statusline.inactive_bg, fg = M.statusline.inactive_fg },
    c = { bg = M.statusline.inactive_bg, fg = M.statusline.inactive_fg },
    z = { bg = M.statusline.inactive_bg, fg = M.statusline.inactive_fg },
  },
}

function M.setup()
  local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- ============================================================================
  -- Neovim UI
  -- ============================================================================

  -- `Normal` is the default text area for the current window.
  hl("Normal", { fg = M.ui.fg, bg = M.ui.bg })

  -- `NormalNC` is the default text area for inactive windows.
  hl("NormalNC", { fg = M.ui.fg, bg = M.ui.bg })

  -- `Cursor` is the visual caret in the active window.
  hl("Cursor", { fg = M.ui.bg, bg = M.ui.cursor })

  -- `CursorLine` highlights the current line. TODO
  hl("CursorLine", { bg = M.ui.cursor_line })

  -- `CursorColumn` highlights the current cursor column. TODO
  hl("CursorColumn", { bg = M.ui.cursor_column })

  -- `CursorLineNr` highlights the number on the current line.
  hl("CursorLineNr", { bg = M.ui.cursor_line_nr, bold = true })

  -- `ColorColumn` marks preferred text width columns.
  hl("ColorColumn", { bg = M.ui.color_column })

  -- `LineNr` is the line number gutter for non-current lines.
  hl("LineNr", { fg = M.ui.line_nr })

  -- `SignColumn` holds signs such as diagnostics and git marks.
  hl("SignColumn", { fg = M.ui.fg, bg = M.ui.bg })

  -- `FoldColumn` shows fold markers.
  hl("FoldColumn", { fg = M.ui.fg, bg = M.ui.bg })

  -- `Folded` is used for folded text lines.
  -- hl("Folded", {})

  -- `Search` highlights the last search match.
  -- hl("Search", {})

  -- `CurSearch` highlights the current search match under the cursor.
  -- hl("CurSearch", {})

  -- `IncSearch` highlights incremental search matches.
  -- hl("IncSearch", {})

  -- `Visual` highlights visual selections.
  -- hl("Visual", {})

  -- `VisualNOS` highlights visual selections when not owned by Vim.
  -- hl("VisualNOS", {})

  -- `Pmenu` styles popup menu entries.
  -- hl("Pmenu", {})

  -- `PmenuSel` styles the selected popup menu entry.
  -- hl("PmenuSel", {})

  -- `PmenuSbar` styles the popup menu scrollbar track.
  -- hl("PmenuSbar", {})

  -- `PmenuThumb` styles the popup menu scrollbar thumb.
  -- hl("PmenuThumb", {})

  -- `NormalFloat` is the base background for floating windows.
  -- hl("NormalFloat", {})

  -- `FloatBorder` is the border around floating windows.
  -- hl("FloatBorder", {})

  -- `FloatTitle` is the title of floating windows.
  -- hl("FloatTitle", {})

  -- `StatusLine` is the active status line.
  -- hl("StatusLine", {})

  -- `StatusLineNC` is the inactive status line.
  -- hl("StatusLineNC", {})

  -- `TabLine` is the tab bar for inactive tabs.
  -- hl("TabLine", {})

  -- `TabLineSel` is the selected tab label.
  -- hl("TabLineSel", {})

  -- `TabLineFill` fills unused tab bar space.
  -- hl("TabLineFill", {})

  -- `VertSplit` separates vertically split windows.
  -- hl("VertSplit", {})

  -- `WinSeparator` separates split windows in newer Neovim.
  -- hl("WinSeparator", {})

  -- `WinBar` is the window-local bar above the buffer.
  -- hl("WinBar", {})

  -- `WinBarNC` is the inactive window bar.
  -- hl("WinBarNC", {})

  -- `Directory` marks directory names in listings.
  -- hl("Directory", {})

  -- `Title` is used for titles and headings.
  -- hl("Title", {})

  -- `Question` is used for yes/no prompts.
  -- hl("Question", {})

  -- `WarningMsg` is used for warning messages.
  -- hl("WarningMsg", {})

  -- `ErrorMsg` is used for error messages.
  -- hl("ErrorMsg", {})

  -- `ModeMsg` is used for mode/status messages.
  -- hl("ModeMsg", {})

  -- `MoreMsg` is used for pager prompts.
  -- hl("MoreMsg", {})

  -- `MsgArea` is the message area below the command line.
  -- hl("MsgArea", {})

  -- `MsgSeparator` separates message chunks in the command area.
  -- hl("MsgSeparator", {})

  -- `MatchParen` highlights the matching bracket pair.
  -- hl("MatchParen", {})

  -- `QuickFixLine` marks the current quickfix item.
  -- hl("QuickFixLine", {})

  -- `EndOfBuffer` is the filler after the last line of a buffer.
  -- hl("EndOfBuffer", {})

  -- `NonText` marks invisible buffer filler text like `~`.
  hl("NonText", { fg = M.ui.non_text })

  -- `SpecialKey` marks special non-printable key representations.
  hl("SpecialKey", { fg = M.ui.special_key })

  -- `Whitespace` marks listchars whitespace.
  hl("Whitespace", { fg = M.ui.whitespace })

  -- ============================================================================
  -- Syntax
  -- ============================================================================

  -- `Comment` is used for regular comments, like `-- note` or `// note`.
  hl("Comment", { fg = M.syntax.comment })

  -- `String` is used for quoted strings, like `"hello"` or `'world'`.
  hl("String", { fg = M.syntax.string })

  -- `Character` is used for character literals, like `'a'` or `'\n'`.
  hl("Character", { fg = M.syntax.character })

  -- `Number` is used for integer literals, like `42` or `0xff`.
  hl("Number", { fg = M.syntax.number })

  -- `Float` is used for floating-point literals, like `3.14` or `1e10`.
  hl("Float", { fg = M.syntax.number })

  -- `Boolean` is used for boolean literals, like `true` or `false`.
  hl("Boolean", { fg = M.syntax.constant })

  -- `Constant` is used for generic constants, like `PI` or `MAX_SIZE`.
  hl("Constant", { fg = M.syntax.constant })

  -- `Identifier` is used for variables and identifiers, like `foo` or `count`.
  hl("Identifier", { fg = M.syntax.variable })

  -- `Function` is used for function names, like `print` or `map`.
  hl("Function", { fg = M.syntax["function"] })

  -- `Statement` is used for language statements, like `return` or `break`.
  hl("Statement", { fg = M.syntax.keyword })

  -- `Conditional` is used for if/else style constructs, like `if` or `else`.
  hl("Conditional", { fg = M.syntax.keyword })

  -- `Repeat` is used for loop constructs, like `for` or `while`.
  hl("Repeat", { fg = M.syntax.keyword })

  -- `Label` is used for goto-style labels, like `loop:` or `::retry::`.
  hl("Label", { fg = M.syntax.keyword })

  -- `Operator` is used for symbolic operators, like `+`, `-`, `=`, or `*`.
  hl("Operator", { fg = M.syntax.operator })

  -- `Keyword` is used for reserved words, like `function`, `local`, or `end`.
  hl("Keyword", { fg = M.syntax.keyword })

  -- `Exception` is used for error-handling keywords, like `try` or `catch`.
  hl("Exception", { fg = M.syntax.keyword })

  -- `PreProc` is used for preprocessor directives, like `#include` or `#define`.
  hl("PreProc", { fg = M.syntax.preproc })

  -- `Include` is used for include/import directives, like `#include <stdio.h>`.
  hl("Include", { fg = M.syntax.preproc })

  -- `Define` is used for macro or constant definitions, like `#define MAX 10`.
  hl("Define", { fg = M.syntax.preproc })

  -- `Macro` is used for macro invocations, like `MAX(10)`.
  hl("Macro", { fg = M.syntax.preproc })

  -- `PreCondit` is used for conditional preprocessing, like `#if` or `#ifdef`.
  hl("PreCondit", { fg = M.syntax.preproc })

  -- `Type` is used for type names, like `int`, `String`, or `MyStruct`.
  hl("Type", { fg = M.syntax.type })

  -- `StorageClass` is used for storage modifiers, like `static` or `extern`.
  hl("StorageClass", { fg = M.syntax.type })

  -- `Structure` is used for composite types, like `struct Point`.
  hl("Structure", { fg = M.syntax.type })

  -- `Typedef` is used for type aliases, like `typedef Foo Bar`.
  hl("Typedef", { fg = M.syntax.type })

  -- `Special` is used for special symbols, like punctuation-heavy tokens or atoms.
  hl("Special", { fg = M.syntax.special })

  -- `SpecialChar` is used for escapes and special characters, like `\n` or `\t`.
  hl("SpecialChar", { fg = M.syntax.special_char })

  -- `Tag` is used for tag-like names, like `div` in HTML tags.
  hl("Tag", { fg = M.syntax.special })

  -- `Delimiter` is used for punctuation and separators, like `,` or `;`.
  hl("Delimiter", { fg = M.syntax.delimiter })

  -- `SpecialComment` is used for comment variants like `TODO` or `FIXME`.
  hl("SpecialComment", { fg = M.syntax.comment })

  -- `Debug` is used for debugging-related syntax, like `dbg!` or trace markers.
  hl("Debug", { fg = M.syntax.special })

  -- `Underlined` is used for underlined text, like links or emphasis.
  hl("Underlined", { fg = M.syntax.special, underline = true })

  -- `Ignore` is used for text that should be ignored.
  -- NOTE: This is a special case where the text is typically hidden or not rendered,
  -- so we set it to the background color to effectively hide it.
  -- hl("Ignore", {})

  -- `Error` is used for syntax errors, like invalid tokens or broken constructs.
  hl("Error", { fg = M.ui.fg, bg = M.ui.bg, bold = true })

  -- `Todo` is used for TODO/FIXME-style markers, like `TODO`, `FIXME`, or `XXX`.
  hl("Todo", { fg = M.syntax.comment, bold = true })

  -- ============================================================================
  -- Treesitter
  -- ============================================================================

  -- `@variable` matches variable-like identifiers, like `foo`, `count`, or `result`.
  hl("@variable", { fg = M.syntax.variable })

  -- `@variable.builtin` matches built-in variables, like `self` or `this`.
  hl("@variable.builtin", { fg = M.syntax.constant })

  -- `@variable.parameter` matches function parameters, like `foo` in `function f(foo) end`.
  hl("@variable.parameter", { fg = M.syntax.variable })

  -- `@variable.parameter.builtin` matches special built-in parameters, like `_` or `it`.
  hl("@variable.parameter.builtin", { fg = M.syntax.constant })

  -- `@variable.member` matches object and struct fields, like `user.name` or `point.x`.
  hl("@variable.member", { fg = M.syntax.variable })

  -- `@constant` matches constant identifiers, like `PI` or `MAX_SIZE`.
  hl("@constant", { fg = M.syntax.constant })

  -- `@constant.builtin` matches built-in constants, like `true`, `false`, or `nil`.
  hl("@constant.builtin", { fg = M.syntax.constant })

  -- `@constant.macro` matches macro-defined constants, like `MAX(10)` in a C macro.
  hl("@constant.macro", { fg = M.syntax.preproc })

  -- `@module` matches module and namespace names, like `vim` in `vim.api`.
  hl("@module", { fg = M.syntax.type })

  -- `@module.builtin` matches built-in modules or namespaces, like `math` or `vim`.
  hl("@module.builtin", { fg = M.syntax.type })

  -- `@label` matches labels and goto targets, like `loop:` or `::retry::`.
  hl("@label", { fg = M.syntax.keyword })

  -- `@string` matches string literals, like `"hello"` or `'world'`.
  hl("@string", { fg = M.syntax.string })

  -- `@string.documentation` matches documentation strings, like Python docstrings.
  hl("@string.documentation", { fg = M.syntax.string })

  -- `@string.regexp` matches regular expressions, like `/foo.*/` or `r"[0-9]+"`.
  hl("@string.regexp", { fg = M.syntax.special_char })

  -- `@string.escape` matches escapes inside strings, like `\n` or `\t`.
  hl("@string.escape", { fg = M.syntax.special_char })

  -- `@string.special` matches special string forms, like dates or symbols.
  hl("@string.special", { fg = M.syntax.special })

  -- `@string.special.symbol` matches symbols or atoms, like `:ok` or `:error`.
  hl("@string.special.symbol", { fg = M.syntax.special })

  -- `@string.special.path` matches file paths, like `src/main.lua`.
  hl("@string.special.path", { fg = M.syntax.special })

  -- `@string.special.url` matches URLs, like `https://example.com`.
  hl("@string.special.url", { fg = M.syntax.special })

  -- `@character` matches character literals, like `'a'` or `'\n'`.
  hl("@character", { fg = M.syntax.character })

  -- `@character.special` matches special character literals, like `'\t'` or `'\x1b'`.
  hl("@character.special", { fg = M.syntax.special_char })

  -- `@boolean` matches boolean literals, like `true` or `false`.
  hl("@boolean", { fg = M.syntax.constant })

  -- `@number` matches numeric literals, like `42` or `0xff`.
  hl("@number", { fg = M.syntax.number })

  -- `@number.float` matches floating-point literals, like `3.14` or `1e10`.
  hl("@number.float", { fg = M.syntax.number })

  -- `@type` matches type names, like `int`, `String`, or `MyStruct`.
  hl("@type", { fg = M.syntax.type })

  -- `@type.builtin` matches built-in types, like `int` or `string`.
  hl("@type.builtin", { fg = M.syntax.type })

  -- `@type.definition` matches type-definition names, like `typedef Foo Bar`.
  hl("@type.definition", { fg = M.syntax.type })

  -- `@attribute` matches annotations and attributes, like `@deprecated` or `#[test]`.
  hl("@attribute", { fg = M.syntax.keyword })

  -- `@attribute.builtin` matches built-in attributes, like `@property`.
  hl("@attribute.builtin", { fg = M.syntax.keyword })

  -- `@property` matches object properties and keys, like `name` in `user.name`.
  hl("@property", { fg = M.syntax.property or M.syntax.variable })

  -- `@function` matches function definitions, like `function foo() end`.
  hl("@function", { fg = M.syntax["function"] })

  -- `@function.builtin` matches built-in functions, like `print` or `len`.
  hl("@function.builtin", { fg = M.syntax["function"] })

  -- `@function.call` matches function call sites, like `print(x)` or `foo(bar)`.
  hl("@function.call", { fg = M.syntax["function"] })

  -- `@function.macro` matches macro-like functions, like `#define FOO(x)`.
  hl("@function.macro", { fg = M.syntax.preproc })

  -- `@function.method` matches method definitions, like `obj:method()`.
  hl("@function.method", { fg = M.syntax["function"] })

  -- `@function.method.call` matches method calls, like `obj:method()`.
  hl("@function.method.call", { fg = M.syntax["function"] })

  -- `@constructor` matches constructor calls and definitions, like `Foo.new()`.
  hl("@constructor", { fg = M.syntax.type })

  -- `@operator` matches symbolic operators, like `+`, `-`, `=`, or `*`.
  hl("@operator", { fg = M.syntax.operator })

  -- `@keyword` matches reserved words, like `return` or `break`.
  hl("@keyword", { fg = M.syntax.keyword })

  -- `@keyword.coroutine` matches coroutine-related keywords, like `async` or `await`.
  hl("@keyword.coroutine", { fg = M.syntax.keyword })

  -- `@keyword.function` matches function-defining keywords, like `function` or `def`.
  hl("@keyword.function", { fg = M.syntax.keyword })

  -- `@keyword.operator` matches word-based operators, like `and`, `or`, or `not`.
  hl("@keyword.operator", { fg = M.syntax.operator })

  -- `@keyword.import` matches import/export keywords, like `import`, `from`, or `use`.
  hl("@keyword.import", { fg = M.syntax.keyword })

  -- `@keyword.type` matches type-oriented keywords, like `struct`, `enum`, or `class`.
  hl("@keyword.type", { fg = M.syntax.type })

  -- `@keyword.modifier` matches modifiers like `const`, `static`, or `public`.
  hl("@keyword.modifier", { fg = M.syntax.keyword })

  -- `@keyword.repeat` matches loop keywords, like `for`, `while`, or `loop`.
  hl("@keyword.repeat", { fg = M.syntax.keyword })

  -- `@keyword.return` matches return-style keywords, like `return` or `yield`.
  hl("@keyword.return", { fg = M.syntax.keyword })

  -- `@keyword.debug` matches debugging keywords, like `breakpoint`-style commands.
  hl("@keyword.debug", { fg = M.syntax.keyword })

  -- `@keyword.exception` matches exception keywords, like `throw` or `catch`.
  hl("@keyword.exception", { fg = M.syntax.keyword })

  -- `@keyword.conditional` matches conditionals, like `if`, `else`, and `elseif`.
  hl("@keyword.conditional", { fg = M.syntax.keyword })

  -- `@keyword.conditional.ternary` matches ternary operators, like `? :`.
  hl("@keyword.conditional.ternary", { fg = M.syntax.operator })

  -- `@keyword.directive` matches preprocessor directives and shebangs, like `#include` or `#!/usr/bin/env sh`.
  hl("@keyword.directive", { fg = M.syntax.preproc })

  -- `@keyword.directive.define` matches directive definitions, like `#define`.
  hl("@keyword.directive.define", { fg = M.syntax.preproc })

  -- `@punctuation.delimiter` matches commas, dots, and separators, like `,` or `.`.
  hl("@punctuation.delimiter", { fg = M.syntax.delimiter })

  -- `@punctuation.bracket` matches brackets and braces, like `(`, `)`, `{`, or `}`.
  hl("@punctuation.bracket", { fg = M.syntax.delimiter })

  -- `@punctuation.special` matches special punctuation in interpolations, like `{` in `${var}`.
  hl("@punctuation.special", { fg = M.syntax.special })

  -- `@comment` matches comments, like `-- note` or `// note`.
  hl("@comment", { fg = M.syntax.comment })

  -- `@comment.documentation` matches documentation comments, like `/// docs` or `/** docs */`.
  hl("@comment.documentation", { fg = M.syntax.comment })

  -- `@comment.error` matches error-like comments, like `ERROR` or `BROKEN`.
  hl("@comment.error", { fg = M.syntax.comment })

  -- `@comment.warning` matches warning-like comments, like `WARNING` or `HACK`.
  hl("@comment.warning", { fg = M.syntax.comment })

  -- `@comment.todo` matches TODO-style comments, like `TODO`, `FIXME`, or `XXX`.
  hl("@comment.todo", { fg = M.syntax.comment, bold = true })

  -- `@comment.note` matches note-style comments, like `NOTE` or `INFO`.
  hl("@comment.note", { fg = M.syntax.comment })

  -- `@markup.strong` matches bold markup, like `**bold**`.
  hl("@markup.strong", { fg = M.syntax.constant, bold = true })

  -- `@markup.italic` matches italic markup, like `*italic*`.
  hl("@markup.italic", { fg = M.syntax.constant, italic = true })

  -- `@markup.strikethrough` matches struck-through markup, like `~~deleted~~`.
  hl("@markup.strikethrough", { fg = M.syntax.constant, strikethrough = true })

  -- `@markup.underline` matches underlined markup, like HTML `<u>` text.
  hl("@markup.underline", { fg = M.syntax.constant, underline = true })

  -- `@markup.heading` matches headings and titles, like `# Title`.
  hl("@markup.heading", { fg = M.syntax.type, bold = true })

  -- `@markup.heading.1` matches top-level headings, like `# Title`.
  hl("@markup.heading.1", { fg = M.syntax.type, bold = true })

  -- `@markup.heading.2` matches second-level headings, like `## Section`.
  hl("@markup.heading.2", { fg = M.syntax.type, bold = true })

  -- `@markup.heading.3` matches third-level headings, like `### Subsection`.
  hl("@markup.heading.3", { fg = M.syntax.type, bold = true })

  -- `@markup.heading.4` matches fourth-level headings, like `#### Topic`.
  hl("@markup.heading.4", { fg = M.syntax.type, bold = true })

  -- `@markup.heading.5` matches fifth-level headings, like `##### Topic`.
  hl("@markup.heading.5", { fg = M.syntax.type, bold = true })

  -- `@markup.heading.6` matches sixth-level headings, like `###### Topic`.
  hl("@markup.heading.6", { fg = M.syntax.type, bold = true })

  -- `@markup.quote` matches block quotes, like `> quoted text`.
  hl("@markup.quote", { fg = M.syntax.special })

  -- `@markup.math` matches math environments, like `$a^2 + b^2$`.
  hl("@markup.math", { fg = M.syntax.special })

  -- `@markup.link` matches references and citations, like `[label](url)`.
  hl("@markup.link", { fg = M.syntax.special, underline = true })

  -- `@markup.link.label` matches link labels, like the `label` part in `[label](url)`.
  hl("@markup.link.label", { fg = M.syntax.special })

  -- `@markup.link.url` matches URL-style links, like `https://example.com`.
  hl("@markup.link.url", { fg = M.syntax.special, underline = true })

  -- `@markup.raw` matches inline raw text, like ``code`` or `printf`.
  hl("@markup.raw", { fg = M.syntax.string })

  -- `@markup.raw.block` matches raw block text, like fenced code blocks.
  hl("@markup.raw.block", { fg = M.syntax.string })

  -- `@markup.list` matches list markers, like `-` or `*`.
  hl("@markup.list", { fg = M.syntax.delimiter })

  -- `@markup.list.checked` matches checked list markers, like `[x]`.
  hl("@markup.list.checked", { fg = M.syntax.delimiter })

  -- `@markup.list.unchecked` matches unchecked list markers, like `[ ]`.
  hl("@markup.list.unchecked", { fg = M.syntax.delimiter })

  -- `@diff.plus` matches added text, like a line prefixed with `+`.
  hl("@diff.plus", { fg = M.syntax.constant })

  -- `@diff.minus` matches deleted text, like a line prefixed with `-`.
  hl("@diff.minus", { fg = M.syntax.constant })

  -- `@diff.delta` matches changed text, like a modified hunk header.
  hl("@diff.delta", { fg = M.syntax.constant })

  -- `@tag` matches XML/HTML-style tag names, like `div` or `section`.
  hl("@tag", { fg = M.syntax.special })

  -- `@tag.builtin` matches built-in tag names, like HTML `div` or `span`.
  hl("@tag.builtin", { fg = M.syntax.special })

  -- `@tag.attribute` matches XML/HTML-style tag attributes, like `class` or `href`.
  hl("@tag.attribute", { fg = M.syntax.variable })

  -- `@tag.delimiter` matches XML/HTML-style tag delimiters, like `<`, `>`, or `</`.
  hl("@tag.delimiter", { fg = M.syntax.delimiter })

  -- ============================================================================
  -- WhichKey
  -- ============================================================================

  -- `WhichKeyNormal` is the popup background and text area.
  hl("WhichKeyNormal", { fg = M.ui.fg, bg = M.ui.bg })

  -- `WhichKeyBorder` is the popup border.
  hl("WhichKeyBorder", { fg = M.ui.fg, bg = M.ui.bg })

  -- `WhichKeyTitle` labels the popup title.
  hl("WhichKeyTitle", { fg = M.ui.fg, bg = M.ui.bg })

  -- `WhichKeyGroup` marks grouped key prefixes. TODO: set fg
  hl("WhichKeyGroup", { fg = M.ui.fg, bg = M.ui.bg })

  -- `WhichKeyDesc` marks mapping descriptions.
  hl("WhichKeyDesc", { fg = M.ui.fg, bg = M.ui.bg })

  -- `WhichKeySeparator` separates keys from descriptions.
  hl("WhichKeySeparator", { fg = M.ui.fg, bg = M.ui.bg })

  -- `WhichKeyValue` shows plugin-provided values. TODO: set fg
  hl("WhichKeyValue", { fg = M.ui.fg, bg = M.ui.bg })
end

return M
