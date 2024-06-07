import 'package:aplikasi/functions/auth/staff/create.dart';
import 'package:aplikasi/page/component/constrainedbox.dart';
import 'package:aplikasi/page/component/titles.dart';
import 'package:flutter/material.dart';

class BuatAkunStaffView extends StatefulWidget {
  const BuatAkunStaffView({super.key});

  @override
  State<BuatAkunStaffView> createState() => _BuatAkunStaffViewState();
}

class _BuatAkunStaffViewState extends State<BuatAkunStaffView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  Future<void> _createAccount(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );

      if (await CreateAkunStaff(_nameController.text, _emailController.text,
          _passwordController.text)) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.red.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: const Text(
                  'Berhasil menambahkan akun',
                ),
                content: Text(
                    'akun dengan ${_emailController.text} telah berhasil ditambahkan'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      {
                        _nameController.clear();
                        _emailController.clear();
                        _passwordController.clear();
                        _passwordConfirmController.clear();
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.red.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: const Text(
                  'Gagal menambahkan akun',
                ),
                content: const Text('Mohon periksa koneksi internet anda'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BoxWithMaxWidth(
          maxWidth: 1000,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const H1("Create Staff Account"),
                Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        _buildNameField(),
                        const SizedBox(height: 20),
                        _buildEmailField(),
                        const SizedBox(height: 20),
                        _buildPasswordField(),
                        const SizedBox(height: 20),
                        _buildConfirmPasswordField(),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () async {
                            await _createAccount(context);
                          },
                          child: const Text('Create Account'),
                        ),
                      ],
                    ))
              ],
            ),
          )),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Name cannot be empty';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email cannot be empty';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password cannot be empty';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _passwordConfirmController,
      decoration: const InputDecoration(
        labelText: 'Confirm Password',
        border: OutlineInputBorder(),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Confirm Password cannot be empty';
        }

        if (_passwordController.text != _passwordConfirmController.text) {
          return 'Mohon memasukkan konfirmasi password';
        }
        return null;
      },
    );
  }
}
