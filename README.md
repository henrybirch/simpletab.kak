# Simpletab.kak
Very simple tab menu using info -markup kakoune command. Has functions for switching to buffer by index, moving the current buffer by index and by 1 in the positive and negative directions. Botched solution just to get a functioning 'tab menu'.

## Default options
declare-option str-list simpletab_bufnames_to_ignore "\*lint-output\*" "\*debug\*"<br>
:bp and :bn ignore these two so I ignore them in the popup and when using indices.

declare-option str simpletab_default_face "Menu"<br>
The face used for the text that represents all buffers other than the current buffer.

declare-option str simpletab_current_buffer_face "PrimaryCursor"<br>
The face used for the text that represents the current buffer.

Please note that all indices are 0 based other than the visual representation that is 1..9 and then 0.

## Possible keybinds
map global user <b> ': simpletab-show-buffers<ret>' -docstring 'Show-Buffers'

map global normal <c-n> ': bn<ret>:simpletab-show-buffers<ret>'
map global normal <c-p> ': bp<ret>:simpletab-show-buffers<ret>'

map global normal <c-q> ': db<ret>:simpletab-show-buffers<ret>'
map global normal <c-Q> ': db!<ret>:simpletab-show-buffers<ret>'

map global normal <c-[> ':simpletab-move-buffer -1<ret>:simpletab-show-buffers<ret>'
map global normal <c-]> ':simpletab-move-buffer 1<ret>:simpletab-show-buffers<ret>'

map global normal <a-1> ':simpletab-get-buffer-by-index 0<ret>:simpletab-show-buffers<ret>'
map global normal <a-2> ':simpletab-get-buffer-by-index 1<ret>:simpletab-show-buffers<ret>'
map global normal <a-3> ':simpletab-get-buffer-by-index 2<ret>:simpletab-show-buffers<ret>'
map global normal <a-4> ':simpletab-get-buffer-by-index 3<ret>:simpletab-show-buffers<ret>'
map global normal <a-5> ':simpletab-get-buffer-by-index 4<ret>:simpletab-show-buffers<ret>'
map global normal <a-6> ':simpletab-get-buffer-by-index 5<ret>:simpletab-show-buffers<ret>'
map global normal <a-7> ':simpletab-get-buffer-by-index 6<ret>:simpletab-show-buffers<ret>'
map global normal <a-8> ':simpletab-get-buffer-by-index 7<ret>:simpletab-show-buffers<ret>'
map global normal <a-9> ':simpletab-get-buffer-by-index 8<ret>:simpletab-show-buffers<ret>'
map global normal <a-0> ':simpletab-get-buffer-by-index 9<ret>:simpletab-show-buffers<ret>'

map global normal <c-a-1> ':simpletab-move-buffer-to-index 0<ret>:simpletab-show-buffers<ret>'
map global normal <c-a-2> ':simpletab-move-buffer-to-index 1<ret>:simpletab-show-buffers<ret>'
map global normal <c-a-3> ':simpletab-move-buffer-to-index 2<ret>:simpletab-show-buffers<ret>'
map global normal <c-a-4> ':simpletab-move-buffer-to-index 3<ret>:simpletab-show-buffers<ret>'
map global normal <c-a-5> ':simpletab-move-buffer-to-index 4<ret>:simpletab-show-buffers<ret>'
map global normal <c-a-6> ':simpletab-move-buffer-to-index 5<ret>:simpletab-show-buffers<ret>'
map global normal <c-a-7> ':simpletab-move-buffer-to-index 6<ret>:simpletab-show-buffers<ret>'
map global normal <c-a-8> ':simpletab-move-buffer-to-index 7<ret>:simpletab-show-buffers<ret>'
map global normal <c-a-9> ':simpletab-move-buffer-to-index 8<ret>:simpletab-show-buffers<ret>'
map global normal <c-a-0> ':simpletab-move-buffer-to-index 9<ret>:simpletab-show-buffers<ret>'
