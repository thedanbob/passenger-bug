## Reproduction steps

1. `docker build -t passenger-bug .`
2. `mkdir --mode=777 uploads`
3. `docker run --rm -it -p 8080:8080 -p 8081:8081 -v ./uploads:/uploads passenger-bug`
5. `curl --data-binary '@16kb.txt' http://localhost:8080/16kb_buf.txt`
6. `diff 16kb.txt uploads/16kb_buf.txt` (files are the same)
7. `curl --data-binary '@16kb.txt' http://localhost:8081/16kb_unbuf.txt`
8. `diff 16kb.txt uploads/16kb_unbuf.txt` (files are different)
9. Repeat steps 4-8 with `8kb.txt` and both diffs will match.
