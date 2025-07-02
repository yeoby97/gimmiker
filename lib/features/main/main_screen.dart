import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gimmiker/features/main/main_provider.dart';
import 'package:gimmiker/features/manager_warehouse_management/manager_warehouse_management_screen.dart';
import 'package:provider/provider.dart';
import '../../data/model/user.dart';
import '../home/home_screen.dart';
import '../my_reservation/my_reservation_screen.dart';
import '../my_using_space/my_using_space_screen.dart';
import '../my_warehouse/my_warehouse_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainProvider = context.watch<MainProvider>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        mainProvider.handleBackPressed(context);
      },
      child: Scaffold(
        body: _Body(),
        floatingActionButton: _FloatingButton(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({super.key});

  @override
  Widget build(BuildContext context) {
    final homeScreenViewModel = context.watch<MainProvider>();

    return switch (homeScreenViewModel.currentIndex) {
      0 => const HomeScreen(),
      1 => const MyWarehouseScreen(),
      2 => const MyReservationScreen(),
      3 => const MyUsingSpaceScreen(),
      4 => const Center(child: Text('내 정보')),
      5 => const ManagerWarehouseManagementScreen(),
      _ => const Center(child: Text('오류')),
    };
  }
}

class _FloatingButton extends StatelessWidget {

  const _FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final mainProvider = context.watch<MainProvider>();

    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black.withAlpha(150),
      overlayOpacity: 0.3,
      spacing: 10,
      spaceBetweenChildren: 10,
      children: [
        _buildDial(icon: Icons.home, label: '홈', tab: 0, context: context),
        _buildDial(icon: Icons.warehouse, label: '내 창고', tab: 1, context: context),
        _buildDial(icon: Icons.calendar_month, label: '예약현황', tab: 2, context: context),
        _buildDial(icon: Icons.person, label: '이용중', tab: 3, context: context),
        _buildDial(icon: Icons.person, label: '내 정보', tab: 4, context: context),
        if(mainProvider.currentUser != null &&
            mainProvider.currentUser!.userType == UserType.manager)
          _buildDial(icon: Icons.add_card, label: '창고관리', tab: 5, context: context),
      ],
    );
  }

  SpeedDialChild _buildDial({
    required IconData icon,
    required String label,
    required int tab,
    required BuildContext context,
  }) {
    final mainProvider = context.read<MainProvider>();

    return SpeedDialChild(
      child: Icon(icon),
      label: label,
      onTap: () => mainProvider.onTabSelected(tab, context),
    );
  }
}


