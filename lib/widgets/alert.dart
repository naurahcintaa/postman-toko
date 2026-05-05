import 'package:flutter/material.dart';

class AlertMessage {

  // =========================
  // ✅ SNACKBAR (SUCCESS / ERROR)
  // =========================
  static void showSnackBar(
    BuildContext context, {
    required String message,
    required bool status,
  }) {
    Color bgColor = status ? Colors.green.shade100 : Colors.pink.shade100;
    Color borderColor = status ? Colors.green : Colors.pink;

    IconData icon = status ? Icons.check_circle : Icons.error;

    final snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      content: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 6,
              offset: Offset(2, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: borderColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: const Icon(Icons.close, size: 18),
            )
          ],
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // =========================
  // ⚠️ ALERT KONFIRMASI DELETE
  // =========================
  static void showDeleteDialog({
    required BuildContext context,
    required Function onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Konfirmasi"),
          content: const Text("Yakin mau hapus data ini?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm(); // 🔥 jalankan delete
              },
              child: const Text(
                "Hapus",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}