class AuthDi {
  void init() {
    // Provider (presentation)
    // di.registerFactory(() => AuthProvider(sl()));

    // Use cases (domain)
    // di.registerLazySingleton(() => LoginUseCase(sl()));

    // Repository (data)
    // di.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

    // Data source
    // di.registerLazySingleton<AuthRemoteDataSource>(
    //   () => AuthRemoteDataSourceImpl(sl()),
    // );
  }
}

// using:
// ChangeNotifierProvider(
// create: (_) => sl<AuthProvider>(),
// );
// or
// class LoginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => sl<AuthProvider>(),
//       child: const LoginView(),
//     );
//   }
// }
