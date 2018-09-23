package main

import (
	"log"
	"net/http"
	"os"

	"github.com/pipa/go.d/homepage"
	"github.com/pipa/go.d/server"
)

var (
	AgoCertFile    = os.Getenv("AGO_CERT_FILE")
	AgoKeyFile     = os.Getenv("AGO_KEY_FILE")
	AgoServiceAddr = os.Getenv("AGO_SERVICE_ADDR")
)

func main() {
	logger := log.New(os.Stdout, "AGO", log.LstdFlags|log.Lshortfile)

	h := homepage.NewHandlers(logger)

	mux := http.NewServeMux()
	h.SetupRoutes(mux)

	srv := server.New(mux, AgoServiceAddr)

	logger.Println("Server starting...")
	err := srv.ListenAndServeTLS(AgoCertFile, AgoKeyFile)
	if err != nil {
		logger.Fatalf("Server failed to start: %v", err)
	}
}
