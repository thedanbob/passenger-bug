## Reproduction steps

1. `docker build -t passenger-bug .`
2. `mkdir --mode=777 uploads`
3. `docker run --rm -it -p 8080:8080 -p 8081:8081 -v ./uploads:/uploads passenger-bug`
4. `dd if=/dev/urandom of=data.bin count=16 bs=1024`
5. `curl --data-binary '@data.bin' http://localhost:8080/buffered.bin`
6. `shasum data.bin uploads/buffered.bin` (hashes are the same)
7. `curl --data-binary '@data.bin' http://localhost:8081/unbuffered.bin`
8. `shasum data.bin uploads/unbuffered.bin` (hashes are different)
