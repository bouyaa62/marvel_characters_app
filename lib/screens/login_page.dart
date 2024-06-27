import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel_characters_app/cubit/auth_cubit.dart';
import 'package:marvel_characters_app/cubit/auth_state.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final email = _emailController.text;
                final password = _passwordController.text;
                context.read<AuthCubit>().login(email, password);
              },
              child: Text('Login'),
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state.errorMessage != null) {
                  return Text(
                    state.errorMessage!,
                    style: TextStyle(color: Colors.red),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
