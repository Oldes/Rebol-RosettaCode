Rebol [
    title: "Rosetta code: Reverse the order of lines in a text file while preserving the contents of each line"
    file:  %Reverse_the_order_of_lines_in_a_text_file_while_preserving_the_contents_of_each_line.r3
    url:   https://rosettacode.org/wiki/Reverse_the_order_of_lines_in_a_text_file_while_preserving_the_contents_of_each_line
]

write %quote.txt { "Diplomacy is the art of
   saying  'Nice Doggy'
until you can find a rock."

                            --- Will Rodgers}

;; read as block of lines, reverse order, write back as lines
write/lines %quote-reversed.txt reverse read/lines %quote.txt

;; page through the result
more %quote-reversed.txt  

;; clean up temp file
delete %quote.txt
delete %quote-reversed.txt