import 'package:intergrasi_backend/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:intergrasi_backend/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isFetching = false; // Loading state untuk fetch data
  List<dynamic> _fetchedData = []; // Menyimpan hasil data fetch

  void handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await login(_emailController.text, _passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login berhasil!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login gagal: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleFetchData() async {
    setState(() {
      _isFetching = true;
    });

    try {
      // Panggil fungsi fetchProtectedData
      final data = await fetchProtectedData(); // Harus mengembalikan data
      setState(() {
        _fetchedData = data; // Simpan data ke state
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data berhasil diambil!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengambil data: $e")),
      );
    } finally {
      setState(() {
        _isFetching = false;
      });
    }
  }

  void handleHapusToken() async {
    try {
      await logout();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Access token berhasil dihapus!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus token: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: _isLoading ? "Loading..." : "Login",
              onPressed: _isLoading ? null : handleLogin,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: _isFetching ? "Loading..." : "Fetch Data",
              onPressed: _isFetching ? null : handleFetchData,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Hapus Access Token",
              onPressed: handleHapusToken,
            ),
            const SizedBox(height: 20),
            const Text(
              "Hasil Data:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Expanded(
              child: _fetchedData.isEmpty
                  ? const Center(child: Text("Belum ada data"))
                  : ListView.builder(
                      itemCount: _fetchedData.length,
                      itemBuilder: (context, index) {
                        final item = _fetchedData[index];
                        return ListTile(
                          title: Text(item['title'] ?? "No Title"),
                          subtitle:
                              Text(item['description'] ?? "No Description"),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
