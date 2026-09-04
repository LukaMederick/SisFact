package handlers

import (
	"encoding/json"
	"net/http"

	"sisfact-backend/internal/models"
	"sisfact-backend/internal/repository"
)

type Handler struct {
	repo repository.Repository
}

func NewHandler(repo repository.Repository) *Handler {
	return &Handler{repo: repo}
}

func jsonResponse(w http.ResponseWriter, status int, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(data)
}

func errorResponse(w http.ResponseWriter, status int, message string) {
	jsonResponse(w, status, map[string]string{"error": message})
}

// Health check
func (h *Handler) HealthCheck(w http.ResponseWriter, r *http.Request) {
	jsonResponse(w, http.StatusOK, map[string]string{
		"status":  "ok",
		"service": "SisFact Go Backend API",
		"version": "1.0.0",
	})
}

// Dashboard
func (h *Handler) GetDashboard(w http.ResponseWriter, r *http.Request) {
	summary, err := h.repo.GetDashboardSummary()
	if err != nil {
		errorResponse(w, http.StatusInternalServerError, err.Error())
		return
	}
	jsonResponse(w, http.StatusOK, summary)
}

// Products
func (h *Handler) HandleProducts(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case http.MethodGet:
		products, err := h.repo.GetProducts()
		if err != nil {
			errorResponse(w, http.StatusInternalServerError, err.Error())
			return
		}
		jsonResponse(w, http.StatusOK, products)

	case http.MethodPost:
		var p models.Product
		if err := json.NewDecoder(r.Body).Decode(&p); err != nil {
			errorResponse(w, http.StatusBadRequest, "Invalid JSON body")
			return
		}
		created, err := h.repo.CreateProduct(&p)
		if err != nil {
			errorResponse(w, http.StatusInternalServerError, err.Error())
			return
		}
		jsonResponse(w, http.StatusCreated, created)

	default:
		errorResponse(w, http.StatusMethodNotAllowed, "Method not allowed")
	}
}

// Shift / Jornada
func (h *Handler) HandleCurrentShift(w http.ResponseWriter, r *http.Request) {
	shift, err := h.repo.GetCurrentShift()
	if err != nil {
		errorResponse(w, http.StatusInternalServerError, err.Error())
		return
	}
	jsonResponse(w, http.StatusOK, shift)
}

func (h *Handler) HandleOpenShift(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		errorResponse(w, http.StatusMethodNotAllowed, "Method not allowed")
		return
	}
	var req struct {
		InitialAmount float64 `json:"initial_amount"`
		OpeningNotes  string  `json:"opening_notes"`
	}
	json.NewDecoder(r.Body).Decode(&req)
	shift, err := h.repo.OpenShift(req.InitialAmount, req.OpeningNotes)
	if err != nil {
		errorResponse(w, http.StatusInternalServerError, err.Error())
		return
	}
	jsonResponse(w, http.StatusCreated, shift)
}

func (h *Handler) HandleCloseShift(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		errorResponse(w, http.StatusMethodNotAllowed, "Method not allowed")
		return
	}
	var req struct {
		FinalAmount  float64 `json:"final_amount"`
		ClosingNotes string  `json:"closing_notes"`
	}
	json.NewDecoder(r.Body).Decode(&req)
	shift, err := h.repo.CloseShift(req.FinalAmount, req.ClosingNotes)
	if err != nil {
		errorResponse(w, http.StatusBadRequest, err.Error())
		return
	}
	jsonResponse(w, http.StatusOK, shift)
}

// Sales
func (h *Handler) HandleSales(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case http.MethodGet:
		startDate := r.URL.Query().Get("start_date")
		endDate := r.URL.Query().Get("end_date")
		sales, err := h.repo.GetSales(startDate, endDate)
		if err != nil {
			errorResponse(w, http.StatusInternalServerError, err.Error())
			return
		}
		jsonResponse(w, http.StatusOK, sales)

	case http.MethodPost:
		var sale models.Sale
		if err := json.NewDecoder(r.Body).Decode(&sale); err != nil {
			errorResponse(w, http.StatusBadRequest, "Invalid JSON body")
			return
		}
		created, err := h.repo.CreateSale(&sale)
		if err != nil {
			errorResponse(w, http.StatusInternalServerError, err.Error())
			return
		}
		jsonResponse(w, http.StatusCreated, created)

	default:
		errorResponse(w, http.StatusMethodNotAllowed, "Method not allowed")
	}
}

func (h *Handler) HandleSalesKPIs(w http.ResponseWriter, r *http.Request) {
	startDate := r.URL.Query().Get("start_date")
	endDate := r.URL.Query().Get("end_date")
	kpis, err := h.repo.GetSalesKPIs(startDate, endDate)
	if err != nil {
		errorResponse(w, http.StatusInternalServerError, err.Error())
		return
	}
	jsonResponse(w, http.StatusOK, kpis)
}

// Cash Registers
func (h *Handler) HandleCashRegisters(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case http.MethodGet:
		crs, err := h.repo.GetCashRegisters()
		if err != nil {
			errorResponse(w, http.StatusInternalServerError, err.Error())
			return
		}
		jsonResponse(w, http.StatusOK, crs)
	case http.MethodPost:
		var req struct {
			Name string `json:"name"`
		}
		json.NewDecoder(r.Body).Decode(&req)
		cr, err := h.repo.CreateCashRegister(req.Name)
		if err != nil {
			errorResponse(w, http.StatusInternalServerError, err.Error())
			return
		}
		jsonResponse(w, http.StatusCreated, cr)
	default:
		errorResponse(w, http.StatusMethodNotAllowed, "Method not allowed")
	}
}

// Categories
func (h *Handler) HandleCategories(w http.ResponseWriter, r *http.Request) {
	categories, err := h.repo.GetCategories()
	if err != nil {
		errorResponse(w, http.StatusInternalServerError, err.Error())
		return
	}
	jsonResponse(w, http.StatusOK, categories)
}

// Auth Handlers
func (h *Handler) HandleLogin(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		errorResponse(w, http.StatusMethodNotAllowed, "Method not allowed")
		return
	}
	var req struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		errorResponse(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	user := map[string]interface{}{
		"id":         "b0000000-0000-0000-0000-000000000001",
		"email":      req.Email,
		"first_name": "Administrador",
		"last_name":  "Sistema",
		"role":       "Administrador",
		"store_name": "Prueba",
		"token":      "demo-jwt-token-sisfact-2026",
	}
	jsonResponse(w, http.StatusOK, user)
}

func (h *Handler) HandleRegister(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		errorResponse(w, http.StatusMethodNotAllowed, "Method not allowed")
		return
	}
	var req struct {
		FirstName string `json:"first_name"`
		LastName  string `json:"last_name"`
		Email     string `json:"email"`
		Password  string `json:"password"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		errorResponse(w, http.StatusBadRequest, "Invalid request payload")
		return
	}
	user := map[string]interface{}{
		"id":         "b0000000-0000-0000-0000-000000000002",
		"email":      req.Email,
		"first_name": req.FirstName,
		"last_name":  req.LastName,
		"role":       "Administrador",
		"store_name": "Prueba",
		"token":      "demo-jwt-token-sisfact-2026",
	}
	jsonResponse(w, http.StatusCreated, user)
}

func (h *Handler) HandleGoogleAuth(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		errorResponse(w, http.StatusMethodNotAllowed, "Method not allowed")
		return
	}
	var req struct {
		GoogleEmail string `json:"email"`
		DisplayName string `json:"name"`
		GoogleToken string `json:"token"`
	}
	json.NewDecoder(r.Body).Decode(&req)
	email := req.GoogleEmail
	if email == "" {
		email = "correo.para.pruebas.2005@gmail.com"
	}
	user := map[string]interface{}{
		"id":         "b0000000-0000-0000-0000-000000000001",
		"email":      email,
		"first_name": "Carlos",
		"last_name":  "Rodriguez",
		"role":       "Administrador",
		"store_name": "Prueba",
		"token":      "demo-google-jwt-token-2026",
	}
	jsonResponse(w, http.StatusOK, user)
}
