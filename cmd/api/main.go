package main

import (
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"os"
	"time"

	"github.com/go-redis/redis/v7"
)

var (
	cache *redis.Client
)

func newCacheClient(url string) *redis.Client{
	return redis.NewClient(&redis.Options{
		Addr:     url,
		Password: "", // no password set
		DB:       0,  // use default DB
	})
}

func newReading() int {
	rand.Seed(time.Now().UnixNano())
	return rand.Intn(15 - 10) + 10
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	log.Println("helloHandler")

	fmt.Fprint(w, "Hello from Go!")
}

func londonHandler(w http.ResponseWriter, r *http.Request) {
	log.Println("londonHandler")

	cachedTemp := cache.Get("london-temp")
	log.Printf("cachedTemp: [%+v]\n", cachedTemp)
	var reading, err = cachedTemp.Int()

	if err != nil {
		log.Println("[london-temp] cache miss.")

		reading = newReading()
		expiration := time.Duration(15) * time.Second

		cache.Set("london-temp", reading, expiration)
		log.Printf("[london-temp] new reading cached: [%d].", reading)
	}

	fmt.Fprintf(w, "London weather: %d", reading)
}

func main() {
	cacheUrl, ok := os.LookupEnv("CACHE_ENDPOINT")
	if !ok {
		panic("CACHE_ENDPOINT env is missing, please configure access to cache")
	}
	cache = newCacheClient(cacheUrl)

	http.HandleFunc("/hello-backend", helloHandler)
	http.HandleFunc("/weather/london", londonHandler)

	fmt.Println("Backend server running...")
	http.ListenAndServe(":8080", nil)
}


