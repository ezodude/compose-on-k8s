package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"math/rand"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/go-redis/redis/v7"
)

var (
	cache *redis.Client
)

func newCacheClient(endpoint, password string) *redis.Client{
	return redis.NewClient(&redis.Options{
		Addr:     endpoint,
		Password: password,
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

func MustLookupSecretOrEnv(key string) string{
	secret := fmt.Sprintf("%s_FILE", key)
	if secretPath, ok := os.LookupEnv(secret); ok {
		data, err := ioutil.ReadFile(secretPath)
		if err != nil {
			panic(fmt.Errorf("cannot read data supplied by %s secret, please fix to access cache", secret))
		}
		log.Printf("SECRET_ENV:[%s], SECRET PATH:[%s], SECRET DATA:[%s]\n", secret, secretPath, string(data))
		return strings.TrimSpace(string(data))
	}

	if val, ok := os.LookupEnv(key); ok {
		log.Printf("ENV:[%s], ENV DATA:[%s]\n", key, val)
		return val
	}

	panic(fmt.Errorf("%s secret or related %s env are missing", secret, key))
}

func main() {
	cacheEndpoint := MustLookupSecretOrEnv("CACHE_ENDPOINT")
	cachePwd := MustLookupSecretOrEnv("CACHE_PASSWORD")
	cache = newCacheClient(cacheEndpoint, cachePwd)

	http.HandleFunc("/hello-backend", helloHandler)
	http.HandleFunc("/weather/london", londonHandler)

	fmt.Println("Backend server running...")
	http.ListenAndServe(":8080", nil)
}


