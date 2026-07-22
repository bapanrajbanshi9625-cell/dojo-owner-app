import 'package:flutter/material.dart';

void main() {
  runApp(const DojoOwnerApp());
  }

  class DojoOwnerApp extends StatelessWidget {
    const DojoOwnerApp({super.key});

      @override
        Widget build(BuildContext context) {
            return MaterialApp(
                  debugShowCheckedModeBanner: false,
                        title: 'Dojo Owner',
                              theme: ThemeData(
                                      primarySwatch: Colors.blue,
                                            ),
                                                  home: const Scaffold(
                                                          body: Center(
                                                                    child: Text(
                                                                                'Welcome to Dojo Owner App',
                                                                                            style: TextStyle(fontSize: 20),
                                                                                                      ),
                                                                                                              ),
                                                                                                                    ),
                                                                                                                        );
                                                                                                                          }
                                                                                                                          }importimport