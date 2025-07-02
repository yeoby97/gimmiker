import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_using_space_provider.dart';

class MyUsingSpaceScreen extends StatefulWidget {
  const MyUsingSpaceScreen({super.key});

  @override
  State<MyUsingSpaceScreen> createState() => _MyUsingSpaceScreenState();
}

class _MyUsingSpaceScreenState extends State<MyUsingSpaceScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 안전한 방법:
    Future.microtask(() {
      final provider = context.read<MyUsingSpaceProvider>();
      provider.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {

    final usingSpaceProvider = context.watch<MyUsingSpaceProvider>();

    if (usingSpaceProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('사용중인 공간'),
        actions: [ /* 기존 IconButton 등록 버튼 */ ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUsingSpaceList(usingSpaceProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildUsingSpaceList(MyUsingSpaceProvider viewModel) {
    final usingSpaces = viewModel.usingSpaces;

    if (usingSpaces.isEmpty) {
      return const Center(child: Text('사용 중인 공간이 없습니다.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: usingSpaces.length,
      itemBuilder: (context, index) {
        final item = usingSpaces[index];
        final warehouse = item.warehouse;
        final space = item.space;

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
                placeholder: (_, __) =>
                const Center(
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
            title: Text('${warehouse.address} - ${space.num}'),
            subtitle: Text('공간 크기: ${space.height * space.width ?? 'N/A'}'),
            onTap: () {
              // TODO: 공간 상세 페이지로 이동 구현
            },
          ),
        );
      },
    );
  }
}
