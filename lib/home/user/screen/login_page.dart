import 'package:flutter/material.dart';
import 'package:travel_guide/select_user.dart';
import 'package:travel_guide/services/login_services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  bool _obscurePassword = true;

  void LoginHandler() async {
    setState(() {
      loading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    await LoginServiceFire().LoginService(
      email: email,
      password: password,
      context: context,
    );

    setState(() {
      loading = false;
    });
  }

  void _navigateToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectUser()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0C1615), // Black app bar
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Custom Painted Background
          CustomPaint(
            size: Size(double.infinity, double.infinity),
            painter: BackgroundPainter(),
          ),
          // Login Form
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 100),
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.green),
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        labelStyle: TextStyle(color: Colors.greenAccent),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        } else if (!RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: TextStyle(color: Colors.green),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.greenAccent),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.greenAccent,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)')
                            .hasMatch(value)) {
                          return 'Password must include at least one uppercase letter, one lowercase letter, and one number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Login button
                    ElevatedButton(
                      onPressed: LoginHandler,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.greenAccent),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Redirect to Signup page
                    TextButton(
                      onPressed: _navigateToSignup,
                      child: Text(
                        'Create account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Background
class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..style = PaintingStyle.fill;

    // Background color (Dark Green)
    paint.color = Color(0xFF0C1615);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Light Green Strips
    paint.color = Color(0xFF3CA55C);
    var path1 = Path();
    path1.moveTo(0, size.height * 0.75);
    path1.lineTo(size.width, size.height * 0.65);
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    canvas.drawPath(path1, paint);

    // Medium Green Strip
    paint.color = Color(0xFF2E8B57);
    var path2 = Path();
    path2.moveTo(0, size.height * 0.85);
    path2.lineTo(size.width, size.height * 0.75);
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint);

    // Darker Green Strip
    paint.color = Color(0xFF1B5E20);
    var path3 = Path();
    path3.moveTo(0, size.height * 0.95);
    path3.lineTo(size.width, size.height * 0.85);
    path3.lineTo(size.width, size.height);
    path3.lineTo(0, size.height);
    path3.close();
    canvas.drawPath(path3, paint);

    // Draw a wave-like structure at the top
    paint.color = Color.fromARGB(255, 18, 34, 32); // Light Green for the wave
    var wavePath = Path();
    wavePath.moveTo(0, 100); // Start position
    wavePath.quadraticBezierTo(size.width * 0.25, 50, size.width * 0.5, 100); // Wave curve
    wavePath.quadraticBezierTo(size.width * 0.75, 150, size.width, 100); // Wave curve
    wavePath.lineTo(size.width, 0);
    wavePath.lineTo(0, 0);
    wavePath.close();
    canvas.drawPath(wavePath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
