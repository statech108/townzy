import 'package:flutter/material.dart';
import 'googleauth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// Adjust the path accordingly

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Sign-In Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInDemo(),
    );
  }
}

class SignInDemo extends StatefulWidget {
  @override
  _SignInDemoState createState() => _SignInDemoState();
}

class _SignInDemoState extends State<SignInDemo> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  GoogleSignInAccount? _currentUser;
  String _status = 'Not signed in';

  @override
  void initState() {
    super.initState();

    // Listen to user changes
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
        _status = account == null
            ? 'Not signed in'
            : 'Signed in as ${account.displayName ?? account.email}';
      });
    });

    // Try to sign in silently at start
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      setState(() {
        _status = 'Sign in failed: $error';
      });
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.signOut();
    setState(() {
      _status = 'Signed out';
    });
  }

  Future<void> _handleGetAuthHeaders() async {
    if (_currentUser != null) {
      final headers = await _currentUser!.authHeaders;
      setState(() {
        _status = 'Auth Headers: $headers';
      });
    } else {
      setState(() {
        _status = 'No user signed in';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(_status),
            SizedBox(height: 20),
            _currentUser == null
                ? ElevatedButton(
              onPressed: _handleSignIn,
              child: Text('Sign In with Google'),
            )
                : Column(
              children: [
                CircleAvatar(
                  backgroundImage:
                  _currentUser!.photoUrl != null
                      ? NetworkImage(_currentUser!.photoUrl!)
                      : null,
                  radius: 40,
                  child: _currentUser!.photoUrl == null
                      ? Icon(Icons.account_circle, size: 80)
                      : null,
                ),
                SizedBox(height: 10),
                Text('Name: ${_currentUser!.displayName ?? 'N/A'}'),
                Text('Email: ${_currentUser!.email}'),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _handleGetAuthHeaders,
                  child: Text('Get Auth Headers'),
                ),
                ElevatedButton(
                  onPressed: _handleSignOut,
                  child: Text('Sign Out'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
