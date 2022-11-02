import 'package:dantex/com.shockbytes.dante/util/dante_colors.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(color: DanteColors.accent),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: DanteColors.background,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/ic-launcher.png',
                  width: 92,
                ),
                SizedBox(height: 16),
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Login with your account to synchronize your books with other devices.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12
                  )
                ),
                SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.g_mobiledata,
                        color: Colors.red,
                      ),
                      Expanded(
                        child: Text(
                          'Login with Google',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(Icons.mail_outline),
                      Expanded(
                        child: Text(
                          'Login with Email',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Divider(
                  height: 2,
                  color: DanteColors.accent,
                ),
                SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.no_accounts_outlined,
                        color: DanteColors.textPrimary,
                      ),
                      Expanded(
                        child: Text(
                          'Stay anonymous',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: DanteColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
