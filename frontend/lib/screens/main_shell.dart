import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/more_menu_popup.dart';
import 'dashboard_screen.dart';
import 'inventory_screen.dart';
import 'pos_screen.dart';
import 'sales_screen.dart';
import 'cash_registers_screen.dart';
import 'box_sessions_screen.dart';
import 'business_sessions_screen.dart';
import 'purchases_screen.dart';
import 'cash_movements_screen.dart';
import 'employees_screen.dart';
import 'customers_screen.dart';
import 'roles_permissions_screen.dart';
import 'reports_hub_screen.dart';
import 'sunat_documents_screen.dart';

class MainShell extends StatelessWidget {
  final AppState state;

  const MainShell({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 850;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            AppTopBar(state: state),

            // Screen Content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _buildCurrentScreen(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: state.currentTabIndex > 3 ? 4 : state.currentTabIndex,
              onTap: (index) {
                if (index == 4) {
                  showDialog(
                    context: context,
                    builder: (ctx) => MoreMenuPopup(state: state),
                  );
                } else {
                  state.setTab(index);
                }
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textSecondary,
              backgroundColor: isDark ? AppColors.darkCard : AppColors.card,
              selectedFontSize: 11.5,
              unselectedFontSize: 11.5,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.all_inbox_outlined),
                  activeIcon: Icon(Icons.all_inbox_rounded),
                  label: 'Inventario',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_basket_outlined),
                  activeIcon: Icon(Icons.shopping_basket_rounded),
                  label: 'Vender',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.attach_money_rounded),
                  activeIcon: Icon(Icons.attach_money_rounded),
                  label: 'Ventas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view_rounded),
                  activeIcon: Icon(Icons.grid_view_rounded),
                  label: 'Más',
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildCurrentScreen() {
    switch (state.currentTabIndex) {
      case 0:
        return DashboardScreen(state: state);
      case 1:
        return InventoryScreen(state: state);
      case 2:
        return PosScreen(state: state);
      case 3:
        return SalesScreen(state: state);
      case 4:
        return CashRegistersScreen(state: state);
      case 5:
        return BoxSessionsScreen(state: state);
      case 6:
        return BusinessSessionsScreen(state: state);
      case 7:
        return PurchasesScreen(state: state);
      case 8:
        return CashMovementsScreen(state: state);
      case 9:
        return EmployeesScreen(state: state);
      case 10:
        return CustomersScreen(state: state);
      case 11:
        return RolesPermissionsScreen(state: state);
      case 12:
        return ReportsHubScreen(state: state);
      case 13:
        return SunatDocumentsScreen(state: state);
      default:
        return DashboardScreen(state: state);
    }
  }
}
