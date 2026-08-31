package repository

import (
	"database/sql"
	"fmt"
	"log"
	"sync"
	"time"

	"sisfact-backend/internal/models"

	"github.com/google/uuid"
	_ "github.com/lib/pq"
)

type Repository interface {
	GetBranch() (*models.Branch, error)
	GetDashboardSummary() (*models.DashboardSummary, error)
	
	// Products
	GetProducts() ([]models.Product, error)
	CreateProduct(p *models.Product) (*models.Product, error)
	DeleteProduct(id string) error

	// Shifts (Jornadas)
	GetCurrentShift() (*models.Shift, error)
	OpenShift(initialAmount float64, notes string) (*models.Shift, error)
	CloseShift(finalAmount float64, notes string) (*models.Shift, error)

	// Sales
	GetSales(startDate, endDate string) ([]models.Sale, error)
	GetSalesKPIs(startDate, endDate string) (*models.SalesKPIStats, error)
	CreateSale(sale *models.Sale) (*models.Sale, error)

	// Cash Registers
	GetCashRegisters() ([]models.CashRegister, error)
	CreateCashRegister(name string) (*models.CashRegister, error)

	// Categories
	GetCategories() ([]models.Category, error)
	CreateCategory(name, colorHex string) (*models.Category, error)
}

// MemoryRepository provides robust in-memory implementation with full capabilities
type MemoryRepository struct {
	mu            sync.RWMutex
	branch        *models.Branch
	user          *models.User
	products      []models.Product
	categories    []models.Category
	cashRegisters []models.CashRegister
	shifts        []models.Shift
	sales         []models.Sale
}

func NewMemoryRepository() *MemoryRepository {
	branch := &models.Branch{
		ID:           "a0000000-0000-0000-0000-000000000001",
		Name:         "Prueba - Principal",
		BusinessName: "Prueba",
		BusinessType: "Minimarket · Perú",
		Address:      "Av. Principal 123, Lima",
		PlanName:     "Gratis",
		IsActive:     true,
		CreatedAt:    time.Now(),
		UpdatedAt:    time.Now(),
	}

	user := &models.User{
		ID:        "b0000000-0000-0000-0000-000000000001",
		BranchID:  branch.ID,
		Email:     "correo.para.pruebas.2005@gmail.com",
		FullName:  "Administrador",
		Role:      "Administrador",
		IsActive:  true,
		CreatedAt: time.Now(),
	}

	categories := []models.Category{
		{ID: uuid.NewString(), BranchID: branch.ID, Name: "Bebidas", ColorHex: "#2563EB", IsActive: true},
		{ID: uuid.NewString(), BranchID: branch.ID, Name: "Snacks & Golosinas", ColorHex: "#10B981", IsActive: true},
		{ID: uuid.NewString(), BranchID: branch.ID, Name: "Lácteos & Embutidos", ColorHex: "#F59E0B", IsActive: true},
		{ID: uuid.NewString(), BranchID: branch.ID, Name: "Abarrotes", ColorHex: "#8B5CF6", IsActive: true},
	}

	cashRegisters := []models.CashRegister{
		{
			ID:        "c0000000-0000-0000-0000-000000000001",
			BranchID:  branch.ID,
			Name:      "Caja Principal",
			Status:    "Cerrada",
			IsActive:  true,
			CreatedAt: time.Now().Add(-26 * 24 * time.Hour),
		},
	}

	return &MemoryRepository{
		branch:        branch,
		user:          user,
		products:      make([]models.Product, 0),
		categories:    categories,
		cashRegisters: cashRegisters,
		shifts:        make([]models.Shift, 0),
		sales:         make([]models.Sale, 0),
	}
}

func (r *MemoryRepository) GetBranch() (*models.Branch, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	return r.branch, nil
}

func (r *MemoryRepository) GetProducts() ([]models.Product, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	return r.products, nil
}

func (r *MemoryRepository) CreateProduct(p *models.Product) (*models.Product, error) {
	r.mu.Lock()
	defer r.mu.Unlock()
	if p.ID == "" {
		p.ID = uuid.NewString()
	}
	p.BranchID = r.branch.ID
	p.CreatedAt = time.Now()
	p.UpdatedAt = time.Now()
	r.products = append(r.products, *p)
	return p, nil
}

func (r *MemoryRepository) DeleteProduct(id string) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	filtered := make([]models.Product, 0, len(r.products))
	for _, p := range r.products {
		if p.ID != id {
			filtered = append(filtered, p)
		}
	}
	r.products = filtered
	return nil
}

func (r *MemoryRepository) GetCurrentShift() (*models.Shift, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	for i := len(r.shifts) - 1; i >= 0; i-- {
		if r.shifts[i].Status == "Abierta" {
			return &r.shifts[i], nil
		}
	}
	return nil, nil
}

func (r *MemoryRepository) OpenShift(initialAmount float64, notes string) (*models.Shift, error) {
	r.mu.Lock()
	defer r.mu.Unlock()

	shift := models.Shift{
		ID:             uuid.NewString(),
		BranchID:       r.branch.ID,
		CashRegisterID: r.cashRegisters[0].ID,
		OpenedAt:       time.Now(),
		InitialAmount:  initialAmount,
		OpeningNotes:   notes,
		Status:         "Abierta",
		CreatedAt:      time.Now(),
	}
	r.shifts = append(r.shifts, shift)
	r.cashRegisters[0].Status = "Abierta"
	return &shift, nil
}

func (r *MemoryRepository) CloseShift(finalAmount float64, notes string) (*models.Shift, error) {
	r.mu.Lock()
	defer r.mu.Unlock()

	for i := len(r.shifts) - 1; i >= 0; i-- {
		if r.shifts[i].Status == "Abierta" {
			now := time.Now()
			r.shifts[i].Status = "Cerrada"
			r.shifts[i].ClosedAt = &now
			r.shifts[i].FinalAmount = finalAmount
			r.shifts[i].ClosingNotes = notes
			r.cashRegisters[0].Status = "Cerrada"
			return &r.shifts[i], nil
		}
	}
	return nil, fmt.Errorf("no open shift found")
}

func (r *MemoryRepository) GetSales(startDate, endDate string) ([]models.Sale, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	return r.sales, nil
}

func (r *MemoryRepository) GetSalesKPIs(startDate, endDate string) (*models.SalesKPIStats, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	stats := &models.SalesKPIStats{
		TotalSales:   len(r.sales),
		TotalRevenue: 0.0,
		ProductsSold: 0,
	}

	for _, s := range r.sales {
		stats.TotalRevenue += s.Total
		stats.ProductsSold += s.ItemsCount
		switch s.PaymentMethod {
		case "Efectivo":
			stats.CashRevenue += s.Total
		case "Tarjeta":
			stats.CardRevenue += s.Total
		default:
			stats.TransferRevenue += s.Total
		}
	}

	if stats.TotalSales > 0 {
		stats.AverageTicket = stats.TotalRevenue / float64(stats.TotalSales)
	}

	return stats, nil
}

func (r *MemoryRepository) CreateSale(sale *models.Sale) (*models.Sale, error) {
	r.mu.Lock()
	defer r.mu.Unlock()

	if sale.ID == "" {
		sale.ID = uuid.NewString()
	}
	if sale.TicketNumber == "" {
		sale.TicketNumber = fmt.Sprintf("B001-%06d", len(r.sales)+1)
	}
	sale.BranchID = r.branch.ID
	sale.CreatedAt = time.Now()
	sale.Status = "Completada"

	// Count products and reduce inventory
	totalItems := 0
	for _, item := range sale.Items {
		totalItems += int(item.Quantity)
		for j := range r.products {
			if item.ProductID != nil && r.products[j].ID == *item.ProductID {
				r.products[j].Stock -= item.Quantity
			}
		}
	}
	sale.ItemsCount = totalItems

	r.sales = append(r.sales, *sale)
	return sale, nil
}

func (r *MemoryRepository) GetCashRegisters() ([]models.CashRegister, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	return r.cashRegisters, nil
}

func (r *MemoryRepository) CreateCashRegister(name string) (*models.CashRegister, error) {
	r.mu.Lock()
	defer r.mu.Unlock()
	cr := models.CashRegister{
		ID:        uuid.NewString(),
		BranchID:  r.branch.ID,
		Name:      name,
		Status:    "Cerrada",
		IsActive:  true,
		CreatedAt: time.Now(),
	}
	r.cashRegisters = append(r.cashRegisters, cr)
	return &cr, nil
}

func (r *MemoryRepository) GetCategories() ([]models.Category, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	return r.categories, nil
}

func (r *MemoryRepository) CreateCategory(name, colorHex string) (*models.Category, error) {
	r.mu.Lock()
	defer r.mu.Unlock()
	cat := models.Category{
		ID:        uuid.NewString(),
		BranchID:  r.branch.ID,
		Name:      name,
		ColorHex:  colorHex,
		IsActive:  true,
		CreatedAt: time.Now(),
	}
	r.categories = append(r.categories, cat)
	return &cat, nil
}

func (r *MemoryRepository) GetDashboardSummary() (*models.DashboardSummary, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	kpis, _ := r.GetSalesKPIs("", "")
	shift, _ := r.GetCurrentShift()

	outOfStock := 0
	for _, p := range r.products {
		if p.Stock <= 0 {
			outOfStock++
		}
	}

	hour := time.Now().Hour()
	greeting := "Buenas noches"
	if hour >= 6 && hour < 12 {
		greeting = "Buenos días"
	} else if hour >= 12 && hour < 19 {
		greeting = "Buenas tardes"
	}

	return &models.DashboardSummary{
		Greeting:       greeting,
		CurrentDate:    time.Now().Format("02/01/2006"),
		SoldToday:      kpis.TotalRevenue,
		OutOfStock:     outOfStock,
		NewCustomers:   0,
		SevenDaysTotal: kpis.TotalRevenue,
		DailyAverage:   kpis.AverageTicket,
		ShiftOpen:      shift != nil,
		Shift:          shift,
		SalesKPIs:      *kpis,
	}, nil
}

// PostgresRepository connection initializer (when DB_HOST is set)
func InitPostgresDB(connStr string) (*sql.DB, error) {
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		return nil, err
	}
	if err := db.Ping(); err != nil {
		return nil, err
	}
	log.Println("Connected to PostgreSQL successfully.")
	return db, nil
}
