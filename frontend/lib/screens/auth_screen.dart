import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';

enum AuthMode { login, register }

class AuthScreen extends StatefulWidget {
  final AppState state;

  const AuthScreen({super.key, required this.state});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _mode = AuthMode.login;
  bool _obscurePassword = true;
  bool _acceptTerms = true;
  bool _isLoading = false;

  // Controllers for login
  final TextEditingController _loginEmailCtrl = TextEditingController(text: 'correo.para.pruebas.2005@gmail.com');
  final TextEditingController _loginPasswordCtrl = TextEditingController(text: '12345678');

  // Controllers for register
  final TextEditingController _regFirstNameCtrl = TextEditingController(text: 'María');
  final TextEditingController _regLastNameCtrl = TextEditingController(text: 'Gonzales');
  final TextEditingController _regEmailCtrl = TextEditingController(text: 'maria.gonzales@negocio.com');
  final TextEditingController _regPasswordCtrl = TextEditingController(text: '');

  // Testimonials Carousel
  int _currentTestimonialIndex = 0;
  Timer? _testimonialTimer;

  final List<Map<String, String>> _testimonials = [
    {
      'quote': '“Ahora mis ventas se cuadran solas al cierre del día. Antes me tomaba dos horas.”',
      'name': 'Carlos R.',
      'location': 'Minimarket · Lima',
      'initials': 'CR',
      'avatarBg': '0xFF0284C7',
    },
    {
      'quote': '“Tomar inventario fue muy fácil. En una tarde tenía todos mis productos en el sistema.”',
      'name': 'Maria G.',
      'location': 'Bodega · Trujillo',
      'initials': 'MG',
      'avatarBg': '0xFF2563EB',
    },
    {
      'quote': '“La emisión de boletas y facturas electrónicas a la SUNAT es instantánea. Muy recomendado.”',
      'name': 'Roberto P.',
      'location': 'Restaurante · Arequipa',
      'initials': 'RP',
      'avatarBg': '0xFF7C3AED',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTestimonialAutoSlide();
  }

  @override
  void dispose() {
    _testimonialTimer?.cancel();
    _loginEmailCtrl.dispose();
    _loginPasswordCtrl.dispose();
    _regFirstNameCtrl.dispose();
    _regLastNameCtrl.dispose();
    _regEmailCtrl.dispose();
    _regPasswordCtrl.dispose();
    super.dispose();
  }

  void _startTestimonialAutoSlide() {
    _testimonialTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _currentTestimonialIndex = (_currentTestimonialIndex + 1) % _testimonials.length;
        });
      }
    });
  }

  // Google sign in action
  void _handleGoogleSignIn() {
    showDialog(
      context: context,
      builder: (ctx) => _buildGoogleAccountPickerDialog(ctx),
    );
  }

  Widget _buildGoogleAccountPickerDialog(BuildContext ctx) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildGoogleGLogo(size: 24),
                const SizedBox(width: 12),
                Text(
                  'Acceder con Google',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Selecciona una cuenta para continuar a Nubetap',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),

            // Option 1
            _buildGoogleAccountItem(
              name: 'Carlos Rodríguez',
              email: 'correo.para.pruebas.2005@gmail.com',
              avatarText: 'C',
              avatarColor: const Color(0xFF2563EB),
              onTap: () {
                Navigator.pop(ctx);
                _performLoginWithGoogle('correo.para.pruebas.2005@gmail.com', 'Carlos Rodriguez');
              },
            ),
            const Divider(height: 16),

            // Option 2
            _buildGoogleAccountItem(
              name: 'María Gonzales',
              email: 'maria.negocio.pe@gmail.com',
              avatarText: 'M',
              avatarColor: const Color(0xFF10B981),
              onTap: () {
                Navigator.pop(ctx);
                _performLoginWithGoogle('maria.negocio.pe@gmail.com', 'Maria Gonzales');
              },
            ),
            const Divider(height: 16),

            // Option 3
            _buildGoogleAccountItem(
              name: 'Usar otra cuenta',
              email: 'Inicia sesión con un correo diferente',
              icon: Icons.person_add_alt_1_rounded,
              onTap: () {
                Navigator.pop(ctx);
                _performLoginWithGoogle('usuario.nubetap@gmail.com', 'Usuario Nubetap');
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleAccountItem({
    required String name,
    required String email,
    String? avatarText,
    Color? avatarColor,
    IconData? icon,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            if (avatarText != null)
              CircleAvatar(
                radius: 18,
                backgroundColor: avatarColor ?? AppColors.primary,
                child: Text(
                  avatarText,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              )
            else
              CircleAvatar(
                radius: 18,
                backgroundColor: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                child: Icon(icon ?? Icons.person, size: 18, color: isDark ? Colors.white70 : AppColors.textPrimary),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performLoginWithGoogle(String email, String name) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    await widget.state.loginWithGoogle(googleEmail: email, displayName: name);
    setState(() => _isLoading = false);
  }

  // Email/Password login
  Future<void> _handleEmailLogin() async {
    final email = _loginEmailCtrl.text.trim();
    final password = _loginPasswordCtrl.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _showSnackbar('Por favor ingresa un correo electrónico válido');
      return;
    }
    if (password.isEmpty) {
      _showSnackbar('Por favor ingresa tu contraseña');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    await widget.state.loginWithEmail(email, password);
    setState(() => _isLoading = false);
  }

  // Registration handler
  Future<void> _handleRegister() async {
    final firstName = _regFirstNameCtrl.text.trim();
    final lastName = _regLastNameCtrl.text.trim();
    final email = _regEmailCtrl.text.trim();
    final password = _regPasswordCtrl.text.trim();

    if (firstName.isEmpty) {
      _showSnackbar('Por favor ingresa tu nombre');
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      _showSnackbar('Por favor ingresa un correo electrónico válido');
      return;
    }
    if (password.length < 8) {
      _showSnackbar('La contraseña debe tener al menos 8 caracteres');
      return;
    }
    if (!_acceptTerms) {
      _showSnackbar('Debes aceptar los Términos y la Política de privacidad');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    await widget.state.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
    setState(() => _isLoading = false);
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final emailCtrl = TextEditingController(text: _loginEmailCtrl.text);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Recuperar Contraseña',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingresa tu correo para enviarte las instrucciones de restablecimiento:',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                hintText: 'tu@negocio.com',
                prefixIcon: Icon(Icons.email_outlined, size: 20),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showSnackbar('Enlace de recuperación enviado a ${emailCtrl.text}');
            },
            child: const Text('Enviar enlace'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.state.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 980;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
      body: SafeArea(
        child: isDesktop ? _buildDesktopLayout(isDark) : _buildMobileLayout(isDark),
      ),
    );
  }

  // DESKTOP LAYOUT: 50% LEFT BRANDING + 50% RIGHT FORM
  Widget _buildDesktopLayout(bool isDark) {
    return Row(
      children: [
        // Left Column: Brand, Tagline, Value Props & Testimonial
        Expanded(
          flex: 5,
          child: Container(
            color: isDark ? const Color(0xFF090D16) : const Color(0xFFFAFAFA),
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Logo
                _buildNubetapLogo(isDark),

                const Spacer(flex: 2),

                // Hero Headline
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      letterSpacing: -0.8,
                      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                    ),
                    children: const [
                      TextSpan(text: 'Vende, organiza y crece\n'),
                      TextSpan(
                        text: 'desde una sola app.',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Subtitle
                Text(
                  'Nubetap es el sistema en la nube para bodegas,\nrestaurantes, farmacias y más negocios de LATAM.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 32),

                // 3 Value Proposition Bullets
                _buildValuePropItem(
                  title: 'Empieza gratis, sin tarjeta',
                  subtitle: 'Tu plan gratis no caduca. Súbete cuando tu negocio crezca.',
                  isDark: isDark,
                ),
                const SizedBox(height: 20),
                _buildValuePropItem(
                  title: 'Vende aunque se vaya el internet',
                  subtitle: 'Tus ventas se guardan y se sincronizan solas cuando vuelva la señal.',
                  isDark: isDark,
                ),
                const SizedBox(height: 20),
                _buildValuePropItem(
                  title: 'Funciona en celular, tablet y PC',
                  subtitle: 'Controla tus ventas y tu stock desde donde estés.',
                  isDark: isDark,
                ),

                const Spacer(flex: 2),

                // Testimonial Card
                _buildTestimonialCard(isDark),

                const Spacer(flex: 1),

                // Bottom Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '© 2026 Nubetap',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                      ),
                    ),
                    Row(
                      children: [
                        _buildFooterLink('Términos', isDark),
                        Text(' · ', style: TextStyle(color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8))),
                        _buildFooterLink('Privacidad', isDark),
                        Text(' · ', style: TextStyle(color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8))),
                        _buildFooterLink('Soporte', isDark),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Vertical Divider line between left and right
        Container(
          width: 1,
          color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
        ),

        // Right Column: Top Bar + Auth Box
        Expanded(
          flex: 5,
          child: Container(
            color: isDark ? AppColors.darkBackground : Colors.white,
            child: Column(
              children: [
                // Top Header with Dark mode button and Top Link
                _buildRightTopBar(isDark),

                // Centered Form
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: _mode == AuthMode.login
                              ? _buildLoginForm(isDark)
                              : _buildRegisterForm(isDark),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // MOBILE / TABLET LAYOUT: SCROLLABLE WITH TOP LOGO & SWITCHER
  Widget _buildMobileLayout(bool isDark) {
    return Column(
      children: [
        // Mobile Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNubetapLogo(isDark),
              _buildDarkModeToggle(isDark),
            ],
          ),
        ),
        const Divider(height: 1),

        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _mode == AuthMode.login
                          ? _buildLoginForm(isDark)
                          : _buildRegisterForm(isDark),
                    ),
                    const SizedBox(height: 32),
                    _buildTestimonialCard(isDark),
                    const SizedBox(height: 24),
                    Text(
                      '© 2026 Nubetap · Términos · Privacidad',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Nubetap Logo Widget
  Widget _buildNubetapLogo(bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.point_of_sale_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Nubetap',
          style: GoogleFonts.inter(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }

  // Value Proposition item with checkmark
  Widget _buildValuePropItem({
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.5) : const Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.check_rounded,
                size: 13,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Testimonial Card Widget
  Widget _buildTestimonialCard(bool isDark) {
    final item = _testimonials[_currentTestimonialIndex];
    final colorHex = int.parse(item['avatarBg']!);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              item['quote']!,
              key: ValueKey<int>(_currentTestimonialIndex),
              style: TextStyle(
                fontSize: 13.5,
                height: 1.4,
                fontStyle: FontStyle.italic,
                color: isDark ? AppColors.darkTextPrimary : const Color(0xFF334155),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Color(colorHex),
                child: Text(
                  item['initials']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name']!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    item['location']!,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Carousel pagination dots
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(_testimonials.length, (index) {
                  final isSelected = index == _currentTestimonialIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _currentTestimonialIndex = index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: isSelected ? 16 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Right Top Bar: Links and Dark Mode Toggle
  Widget _buildRightTopBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_mode == AuthMode.register) ...[
            Text(
              '¿Ya tienes cuenta? ',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
              ),
            ),
            InkWell(
              onTap: () => setState(() => _mode = AuthMode.login),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: Text(
                  'Inicia sesión',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
          _buildDarkModeToggle(isDark),
        ],
      ),
    );
  }

  // Dark Mode Toggle Icon Button
  Widget _buildDarkModeToggle(bool isDark) {
    return Tooltip(
      message: isDark ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
      child: InkWell(
        onTap: () => widget.state.toggleDarkMode(),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Center(
            child: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              size: 18,
              color: isDark ? const Color(0xFFFBBF24) : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }

  // 1. LOGIN FORM
  Widget _buildLoginForm(bool isDark) {
    return Column(
      key: const ValueKey('login_form'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Heading
        Text(
          'Bienvenido de vuelta',
          style: GoogleFonts.inter(
            fontSize: 27,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Inicia sesión para gestionar tu negocio.',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 24),

        // Google Sign In Button
        _buildGoogleButton(isDark),
        const SizedBox(height: 20),

        // Divider: "O INGRESA CON"
        _buildDivider('O INGRESA CON', isDark),
        const SizedBox(height: 20),

        // Field: Email
        _buildInputLabel('Email', isDark),
        const SizedBox(height: 6),
        TextField(
          controller: _loginEmailCtrl,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            hintText: 'tu@negocio.com',
            filled: true,
            fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Field: Password + Forgot password link
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInputLabel('Contraseña', isDark),
            InkWell(
              onTap: _showForgotPasswordDialog,
              child: const Text(
                '¿Olvidaste?',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _loginPasswordCtrl,
          obscureText: _obscurePassword,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            hintText: 'Tu contraseña',
            filled: true,
            fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 19,
                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Primary Button: "Iniciar sesión →"
        SizedBox(
          height: 46,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleEmailLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Iniciar sesión',
                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded, size: 17),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 24),

        // Bottom Link: Create Account
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¿No tienes cuenta? ',
                style: TextStyle(
                  fontSize: 13.5,
                  color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                ),
              ),
              InkWell(
                onTap: () => setState(() => _mode = AuthMode.register),
                child: const Text(
                  'Crea una gratis',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 2. REGISTER FORM
  Widget _buildRegisterForm(bool isDark) {
    final passwordText = _regPasswordCtrl.text;
    final hasMinLength = passwordText.length >= 8;
    final hasNumber = RegExp(r'[0-9]').hasMatch(passwordText);
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(passwordText);

    return Column(
      key: const ValueKey('register_form'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Heading
        Text(
          'Crea tu cuenta gratis',
          style: GoogleFonts.inter(
            fontSize: 27,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'En 2 minutos. Sin tarjeta de crédito.',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 22),

        // Google Sign In Button
        _buildGoogleButton(isDark),
        const SizedBox(height: 18),

        // Divider: "O REGÍSTRATE CON"
        _buildDivider('O REGÍSTRATE CON', isDark),
        const SizedBox(height: 18),

        // Row: Nombres & Apellidos
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputLabel('Nombres', isDark),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _regFirstNameCtrl,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                    ),
                    decoration: _inputDecoration(isDark, 'María'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputLabel('Apellidos', isDark),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _regLastNameCtrl,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                    ),
                    decoration: _inputDecoration(isDark, 'Gonzales'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Field: Email
        _buildInputLabel('Email', isDark),
        const SizedBox(height: 6),
        TextField(
          controller: _regEmailCtrl,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
          ),
          decoration: _inputDecoration(isDark, 'tu@negocio.com'),
        ),
        const SizedBox(height: 14),

        // Field: Password
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInputLabel('Contraseña', isDark),
            Text(
              'Mínimo 8 caracteres',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _regPasswordCtrl,
          obscureText: _obscurePassword,
          onChanged: (val) => setState(() {}),
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            hintText: 'Crea una contraseña segura',
            filled: true,
            fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 19,
                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 6),

        // Password strength meter bar
        Row(
          children: [
            Expanded(
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: hasMinLength
                      ? AppColors.primary
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: (hasMinLength && (hasNumber || hasUppercase))
                      ? AppColors.primary
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: (hasMinLength && hasNumber && hasUppercase)
                      ? AppColors.success
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          'Usa 8+ caracteres con números y mayúsculas',
          style: TextStyle(
            fontSize: 11.5,
            color: isDark ? AppColors.darkTextSecondary : const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 14),

        // Terms Checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: _acceptTerms,
                onChanged: (val) => setState(() => _acceptTerms = val ?? false),
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                side: BorderSide(
                  color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                    ),
                    children: const [
                      TextSpan(text: 'Acepto los '),
                      TextSpan(
                        text: 'Términos del servicio',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: ' y la '),
                      TextSpan(
                        text: 'Política de privacidad',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: ' de Nubetap.'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Primary Button: "Continuar →"
        SizedBox(
          height: 46,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continuar',
                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded, size: 17),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 20),

        // Bottom Link: Already have account
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¿Ya tienes cuenta? ',
                style: TextStyle(
                  fontSize: 13.5,
                  color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                ),
              ),
              InkWell(
                onTap: () => setState(() => _mode = AuthMode.login),
                child: const Text(
                  'Inicia sesión',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Google Sign In Button
  Widget _buildGoogleButton(bool isDark) {
    return InkWell(
      onTap: _isLoading ? null : _handleGoogleSignIn,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGoogleGLogo(size: 18),
            const SizedBox(width: 10),
            Text(
              'Continuar con Google',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Google "G" Multi-color Logo
  Widget _buildGoogleGLogo({double size = 18}) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleGLogoPainter(),
      ),
    );
  }

  // Divider with label (e.g. "O INGRESA CON")
  Widget _buildDivider(String text, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildInputLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextPrimary : const Color(0xFF334155),
      ),
    );
  }

  InputDecoration _inputDecoration(bool isDark, String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  Widget _buildFooterLink(String label, bool isDark) {
    return InkWell(
      onTap: () {
        _showSnackbar('Sección: $label');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }
}

// Custom Painter for Official Google "G" 4-color Logo
class _GoogleGLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2;
    final strokeWidth = w * 0.22;

    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final blueFillPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    // Draw Google arcs:
    // Red (top)
    canvas.drawArc(rect, -3.14159 * 0.75, 3.14159 * 0.55, false, redPaint);
    // Yellow (left)
    canvas.drawArc(rect, -3.14159 * 1.25, 3.14159 * 0.50, false, yellowPaint);
    // Green (bottom)
    canvas.drawArc(rect, 3.14159 * 0.25, 3.14159 * 0.50, false, greenPaint);
    // Blue (right)
    canvas.drawArc(rect, -3.14159 * 0.20, 3.14159 * 0.45, false, bluePaint);

    // Blue horizontal bar
    final barRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(center.dx - strokeWidth * 0.2, center.dy - strokeWidth / 2, radius + strokeWidth * 0.2, strokeWidth),
      Radius.circular(strokeWidth * 0.2),
    );
    canvas.drawRRect(barRect, blueFillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
