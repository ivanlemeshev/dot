# Tips

## Neovim Tips

### Delete a Column

1. Press Ctrl + v.
2. Highlight the columns you want to remove.
3. Press d or x.

### Insert Text on Multiple Lines (Before cursor)

1. Press Ctrl + v and select vertical lines.
2. Press Shift + i (Capital I).
3. Type the text you want to insert. Note: You will only see it appear on the
   first line while typing.
4. Press Esc. Wait a moment, and Neovim will apply the text to all selected
   lines.

### Append Text on Multiple Lines (After selection)

1. Press Ctrl + v and select vertical lines.
2. Press Shift + a (Capital A).
3. Type the text.
4. Press Esc to apply to all lines.

### Replace word+braces (or other punctuation) at once

For example: interface{}

Using cf}:

1. Place your cursor on the first character of the word (i in interface).
2. Type cf}.
3. Type your new text and press <Esc>.

Using c2iw (change 2 inner words):

1. Place your cursor on the first word
2. Type c2iw.
3. Type your new text and press <Esc>.
