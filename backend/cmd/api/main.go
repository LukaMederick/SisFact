package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"sisfact-backend/internal/handlers"
	"sisfact-backend/internal/repository"
)

// corsMiddleware adds CORS headers to allow requests from Flutter Web and mobile apps
func corsMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS, PATCH")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization, X-Requested-With")

		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusOK)
			return
		}

		next.ServeHTTP(w, r)
	})
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// Initialize repository (Memory repository with PostgreSQL integration capability)
	repo := repository.NewMemoryRepository()
	h := handlers.NewHandler(repo)

	mux := http.NewServeMux()

	// API Routes
	mux.HandleFunc("/api/health", h.HealthCheck)
	mux.HandleFunc("/api/dashboard", h.GetDashboard)
	mux.HandleFunc("/api/products", h.HandleProducts)
	mux.HandleFunc("/api/categories", h.HandleCategories)
	mux.HandleFunc("/api/shifts/current", h.HandleCurrentShift)
	mux.HandleFunc("/api/shifts/open", h.HandleOpenShift)
	mux.HandleFunc("/api/shifts/close", h.HandleCloseShift)
	mux.HandleFunc("/api/sales", h.HandleSales)
	mux.HandleFunc("/api/sales/kpis", h.HandleSalesKPIs)
	mux.HandleFunc("/api/cash-registers", h.HandleCashRegisters)

	handler := corsMiddleware(mux)

	addr := fmt.Sprintf("0.0.0.0:%s", port)
	log.Printf("🚀 SisFact Golang Backend running at http://localhost:%s\n", port)
	log.Printf("📊 PostgreSQL/PostgREST compatible endpoints ready.\n")

	if err := http.ListenAndServe(addr, handler); err != nil {
		log.Fatalf("Server error: %v", err)
	}
}
