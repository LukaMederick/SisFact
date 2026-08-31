package models

import (
	"time"
)

type Branch struct {
	ID           string    `json:"id"`
	Name         string    `json:"name"`
	BusinessName string    `json:"business_name"`
	BusinessType string    `json:"business_type"`
	Address      string    `json:"address"`
	Phone        string    `json:"phone"`
	RUC          string    `json:"ruc"`
	PlanName     string    `json:"plan_name"`
	IsActive     bool      `json:"is_active"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

type User struct {
	ID        string    `json:"id"`
	BranchID  string    `json:"branch_id"`
	Email     string    `json:"email"`
	FullName  string    `json:"full_name"`
	Role      string    `json:"role"`
	AvatarURL string    `json:"avatar_url"`
	IsActive  bool      `json:"is_active"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type Category struct {
	ID          string    `json:"id"`
	BranchID    string    `json:"branch_id"`
	Name        string    `json:"name"`
	Description string    `json:"description"`
	ColorHex    string    `json:"color_hex"`
	IsActive    bool      `json:"is_active"`
	CreatedAt   time.Time `json:"created_at"`
}

type Product struct {
	ID                       string    `json:"id"`
	BranchID                 string    `json:"branch_id"`
	CategoryID               *string   `json:"category_id,omitempty"`
	CategoryName             string    `json:"category_name,omitempty"`
	BrandName                string    `json:"brand_name,omitempty"`
	SupplierName             string    `json:"supplier_name,omitempty"`
	Barcode                  string    `json:"barcode"`
	Name                     string    `json:"name"`
	Description              string    `json:"description"`
	PrintDescriptionOnTicket bool      `json:"print_description_on_ticket"`
	Price                    float64   `json:"price"`
	Cost                     float64   `json:"cost"`
	HasVariants              bool      `json:"has_variants"`
	TrackInventory           bool      `json:"track_inventory"`
	Stock                    float64   `json:"stock"`
	MinStock                 float64   `json:"min_stock"`
	ImageURL                 string    `json:"image_url"`
	IsActive                 bool      `json:"is_active"`
	IsFavorite               bool      `json:"is_favorite"`
	CreatedAt                time.Time `json:"created_at"`
	UpdatedAt                time.Time `json:"updated_at"`
}

type CashRegister struct {
	ID        string    `json:"id"`
	BranchID  string    `json:"branch_id"`
	Name      string    `json:"name"`
	Status    string    `json:"status"` // "Abierta", "Cerrada"
	IsActive  bool      `json:"is_active"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type Shift struct {
	ID             string     `json:"id"`
	BranchID       string     `json:"branch_id"`
	CashRegisterID string     `json:"cash_register_id"`
	UserID         *string    `json:"user_id,omitempty"`
	OpenedAt       time.Time  `json:"opened_at"`
	ClosedAt       *time.Time `json:"closed_at,omitempty"`
	InitialAmount  float64    `json:"initial_amount"`
	FinalAmount    float64    `json:"final_amount"`
	ExpectedAmount float64    `json:"expected_amount"`
	Difference     float64    `json:"difference"`
	OpeningNotes   string     `json:"opening_notes"`
	ClosingNotes   string     `json:"closing_notes"`
	Status         string     `json:"status"` // "Abierta", "Cerrada"
	CreatedAt      time.Time  `json:"created_at"`
}

type SaleItem struct {
	ID          string  `json:"id"`
	SaleID      string  `json:"sale_id"`
	ProductID   *string `json:"product_id,omitempty"`
	ProductName string  `json:"product_name"`
	Quantity    float64 `json:"quantity"`
	UnitPrice   float64 `json:"unit_price"`
	UnitCost    float64 `json:"unit_cost"`
	Discount    float64 `json:"discount"`
	Total       float64 `json:"total"`
}

type Sale struct {
	ID             string     `json:"id"`
	BranchID       string     `json:"branch_id"`
	ShiftID        *string    `json:"shift_id,omitempty"`
	CashRegisterID *string    `json:"cash_register_id,omitempty"`
	UserID         *string    `json:"user_id,omitempty"`
	CustomerID     *string    `json:"customer_id,omitempty"`
	CustomerName   string     `json:"customer_name,omitempty"`
	TicketNumber   string     `json:"ticket_number"`
	ReceiptType    string     `json:"receipt_type"` // Ticket, Boleta, Factura
	PaymentMethod  string     `json:"payment_method"` // Efectivo, Tarjeta, Yape, Plin, Transferencia
	Subtotal       float64    `json:"subtotal"`
	Tax            float64    `json:"tax"`
	Discount       float64    `json:"discount"`
	Total          float64    `json:"total"`
	AmountPaid     float64    `json:"amount_paid"`
	ChangeGiven    float64    `json:"change_given"`
	ItemsCount     int        `json:"items_count"`
	Notes          string     `json:"notes"`
	Status         string     `json:"status"`
	CreatedAt      time.Time  `json:"created_at"`
	Items          []SaleItem `json:"items,omitempty"`
}

type SalesKPIStats struct {
	TotalSales      int     `json:"total_sales"`
	TotalRevenue    float64 `json:"total_revenue"`
	AverageTicket   float64 `json:"average_ticket"`
	ProductsSold    int     `json:"products_sold"`
	CashRevenue     float64 `json:"cash_revenue"`
	CardRevenue     float64 `json:"card_revenue"`
	TransferRevenue float64 `json:"transfer_revenue"`
}

type DashboardSummary struct {
	Greeting       string         `json:"greeting"`
	CurrentDate    string         `json:"current_date"`
	SoldToday      float64        `json:"sold_today"`
	OutOfStock     int            `json:"out_of_stock"`
	NewCustomers   int            `json:"new_customers"`
	SevenDaysTotal float64        `json:"seven_days_total"`
	DailyAverage   float64        `json:"daily_average"`
	ShiftOpen      bool           `json:"shift_open"`
	Shift          *Shift         `json:"shift,omitempty"`
	SalesKPIs      SalesKPIStats  `json:"sales_kpis"`
}
