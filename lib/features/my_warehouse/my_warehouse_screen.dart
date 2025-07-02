import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gimmiker/features/my_warehouse/my_warehouse_provider.dart';
import 'package:gimmiker/features/warehouse_management/warehouse_management_provider.dart';
import 'package:gimmiker/features/warehouse_management/warehouse_management_screen.dart';
import 'package:gimmiker/features/warehouse_register/touch_counter.dart';
import 'package:gimmiker/features/warehouse_register/warehouse_register_provider.dart';
import 'package:provider/provider.dart';
import '../main/main_provider.dart';
import '../sign/signin/sign_in_screen.dart';
import '../warehouse_register/warehouse_register_screen.dart';

class MyWarehouseScreen extends StatefulWidget {
  const MyWarehouseScreen({super.key});

  @override
  State<MyWarehouseScreen> createState() => _MyWarehouseScreenState();
}

class _MyWarehouseScreenState extends State<MyWarehouseScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 안전한 방법:
    Future.microtask(() {
      final provider = context.read<MyWarehouseProvider>();
      provider.init(context);
    });
  }
  @override
  Widget build(BuildContext context) {

    final provider = context.watch<MyWarehouseProvider>();

    if (provider.isLoading) {
      // 로딩 화면 분기
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('창고 정보를 불러오는 중입니다...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 창고 목록'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '창고 등록',
            onPressed: () async {
              final provider = context.read<MyWarehouseProvider>();
              final mainProvider = context.read<MainProvider>();
              final user = mainProvider.currentUser;

              if (user == null) {
                final loginResult = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SignInScreen(),
                  ),
                );

                if (loginResult != true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('로그인 후 이용해주세요.')),
                  );
                  return;
                }
              }

              mainProvider.subscribeToUser();

              final registerResult = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider(create: (_) => TouchCounterNotifier()),
                      ChangeNotifierProvider(create: (_) => WarehouseRegisterProvider()),
                    ],
                    child: const WarehouseRegisterScreen(),
                  ),
                ),
              );

              if (registerResult == true) {
                await provider.init(context);
              }
            },
          ),
        ],
      ),
      body: _buildWarehouseList(provider),
    );
  }

  Widget _buildWarehouseList(MyWarehouseProvider viewModel) {

    final warehouses = viewModel.warehouses;
    if (warehouses.isEmpty) {
      return const Center(child: Text('등록된 창고가 없습니다.'));
    }

    return ListView.builder(
      itemCount: warehouses.length,
      itemBuilder: (context, index) {
        final warehouse = warehouses[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: warehouse.images.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: warehouse.images.first,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 1.5),
                  ),
                ),
                errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            )
                : const Icon(Icons.home_work, size: 40),
            title: Text(warehouse.address),
            subtitle: Text('${warehouse.count}칸'),
            onTap: () async{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => WarehouseManagementProvider(),
                    child: WarehouseManagementScreen(warehouse: warehouse),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}