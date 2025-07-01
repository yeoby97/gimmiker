import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gimmiker/data/repository/warehouse_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../data/dataSource/image_file_source.dart';
import '../../data/dataSource/location_source.dart';
import '../../data/dataSource/space_source.dart';
import '../../data/dataSource/user_source.dart';
import '../../data/dataSource/warehouse_source.dart';
import '../../data/model/space.dart';
import '../../data/model/user.dart';
import '../../data/model/warehouse.dart';
import '../../data/repository/image_file_repository.dart';
import '../../data/repository/location_repository.dart';
import '../../data/repository/space_repository.dart';
import '../../data/repository/user_repository.dart';
import '../main/main_provider.dart';
import '../search/search_screen.dart';

class WarehouseRegisterProvider extends ChangeNotifier{

  final userRepository = UserRepository(UserSource());
  final warehouseRepository = WarehouseRepository(WarehouseSource());
  final locationRepository = LocationRepository(LocationSource());
  final imageFileRepository = ImageFileRepository(ImageFileSource());
  final spaceRepository = SpaceRepository(SpaceSource());

  bool _isLoading = false;
  bool _isLayout = false;
  List<XFile> _images = [];
  String? address;
  LatLng? location;
  final detailAddressController = TextEditingController();
  final countController = TextEditingController();
  int? _count;
  bool _isDraw = false;
  final _lines = <Line>[];
  final Set<Offset> _doors = {};
  TransformedData? _transformedData;
  int spaceIdCounter = 0;
  int? selectedSpaceId;
  final List<Space> spaces = [];
  final TransformationController _transformationController = TransformationController();
  double gridSize = 30;
  bool scroll = true;


  String get detailAddress => detailAddressController.text;
  bool get isLoading => _isLoading;
  List<XFile> get images => _images;
  int? get count => _count;
  bool get isDraw => _isDraw;
  List<Line> get lines => _lines;
  Set<Offset> get doors => _doors;
  TransformedData? get transformedData => _transformedData;

  set detailAddress(String value) {
    detailAddressController.text = value;
    notifyListeners();
  }

  void toggleLayout() {
    _isLayout = !_isLayout;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void deletePhoto(int index) {
    _images.removeAt(index);
    notifyListeners();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final newImages = await picker.pickMultiImage();

    if (newImages.isNotEmpty) {
      _images = (_images + newImages).take(10).toList();
      notifyListeners();
    }
  }

  void selectLocation(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
    if (result != null && context.mounted) {
      address = result["address"];
      location = result["location"];
      notifyListeners();
    }
  }

  void countChange(int? value) {
    _count = value;
  }

  void drawChange(bool value) {
    _isDraw = value;
    notifyListeners();
  }

  @override
  void dispose() {
    detailAddressController.dispose();
    countController.dispose();
    super.dispose();
  }

  void _showMessage(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> upload(BuildContext context) async{


    final mainProvider = context.read<MainProvider>();

    if(!_validateInputs(context)) return;

    setLoading(true);

    try{
      final user = mainProvider.currentUser;

      String locationId;

      final locationCheck = await locationRepository.getLocationFromLatLng(location!.latitude, location!.longitude);
      if(locationCheck != null) {
        locationId = locationCheck.id!;
      } else {
        locationId = await locationRepository.addLocation(location!.latitude, location!.longitude);
      }

      final imageUrls = await imageFileRepository.uploadImages(images,locationId, address!);

      Warehouse warehouse = Warehouse(
        locationId: locationId,
        address: address!,
        detailAddress: detailAddressController.text,
        count: _count!,
        images: imageUrls,
        lat: location!.latitude,
        lng: location!.longitude,
        ownerId: user!.uid,
        width: _transformedData?.width ?? 0,
        height: _transformedData?.height ?? 0,
        createdAt: DateTime.now(),
        layout: {
          'lines': _transformedData?.shiftedLines ?? [],
          'doors': _transformedData?.shiftedDoors ?? {},
        },
      );

      final warehouseId = await warehouseRepository.addWarehouse(warehouse);
      warehouse = warehouse.copyWith(id: warehouseId);
      final myWarehouse = MyWarehouse(
          locationId : locationId,
          warehouseId : warehouseId,
      );


      late final AppUser updateUser;
      if (user.myWarehouses == null) {
        updateUser = user.copyWith(myWarehouses: []);
      } else {
        updateUser = user;
      }
      updateUser.myWarehouses!.add(myWarehouse);
      await userRepository.updateUser(updateUser);
      await spaceRepository.addAllSpaces(warehouse, spaces);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("창고가 성공적으로 등록되었습니다.")),
        );
        Navigator.of(context).pop(true);
      }
    } catch(e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("등록 중 오류 발생: $e")),
        );
      }
    } finally {
      setLoading(false);
    }

  }


  bool _validateInputs(BuildContext context) {

    if (context.read<MainProvider>().currentUser == null) {
      _showMessage(context, "로그인이 필요합니다.");
      return false;
    }
    if (address == null || location == null) {
      _showMessage(context, "주소를 선택해주세요.");
      return false;
    }
    if (detailAddressController.text.isEmpty) {
      _showMessage(context, "상세 주소를 입력해주세요.");
      return false;
    }
    _count = int.tryParse(countController.text);
    if (_count == null || _count! <= 0) {
      _showMessage(context, "창고 갯수를 올바르게 입력해주세요.");
      return false;
    }
    if (_images.isEmpty) {
      _showMessage(context, "사진을 선택해주세요.");
      return false;
    }
    if (spaces.length != _count) {
      _showMessage(context, "선택한 상자 수가 맞지 않습니다.");
      return false;
    }
    return true;
  }

  void getTransformedDataWithMargin(double margin) {
    if (_lines.isEmpty) {
      _transformedData = TransformedData(shiftedLines: [], shiftedDoors: {}, width: 0, height: 0);
      return;
    }

    // 모든 점 수집
    final allPoints = _lines.expand((line) => [line.start, line.end]).toList() + _doors.toList();

    // 최소/최대 좌표 계산
    final minX = allPoints.map((p) => p.dx).reduce((a, b) => a < b ? a : b);
    final minY = allPoints.map((p) => p.dy).reduce((a, b) => a < b ? a : b);
    final maxX = allPoints.map((p) => p.dx).reduce((a, b) => a > b ? a : b);
    final maxY = allPoints.map((p) => p.dy).reduce((a, b) => a > b ? a : b);

    final dxOffset = 60 - minX;
    final dyOffset = 60 - minY;

    // 이동된 선과 문 생성
    final shiftedLines = _lines
        .map((line) => Line(
      Offset(line.start.dx + dxOffset, line.start.dy + dyOffset),
      Offset(line.end.dx + dxOffset, line.end.dy + dyOffset),
    ))
        .toList();

    final shiftedDoors = _doors
        .map((door) => Offset(door.dx + dxOffset, door.dy + dyOffset))
        .toSet();

    final width = (maxX - minX) + 120; // 왼쪽 50, 오른쪽 50 마진 포함
    final height = (maxY - minY) + 120;

    _transformedData = TransformedData(
      shiftedLines: shiftedLines,
      shiftedDoors: shiftedDoors,
      width: width,
      height: height,
    );
  }

  void addSpace(double width, double height, int num,int price) {

    final shape = Space(
      x: 100,
      y: 100,
      num: num,
      width: width,
      height: height,
      price: price,
    );
    spaces.add(shape);
    spaceIdCounter++;

    notifyListeners();
  }

  Future<void> showSpaceSizeDialog(BuildContext context) async {
    final widthController = TextEditingController();
    final heightController = TextEditingController();
    final numController = TextEditingController();
    final priceController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('창고 크기 설정'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: widthController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '가로 (width)'),
            ),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '세로 (height)'),
            ),
            TextField(
              controller: numController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '창고 번호'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '대여료(월)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              final width = double.tryParse(widthController.text) ?? 100;
              final height = double.tryParse(heightController.text) ?? 100;
              final num = int.tryParse(numController.text) ?? 99999;
              final price = int.tryParse(priceController.text) ?? 999999;
              addSpace(width, height, num, price);
              Navigator.pop(context);
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }



  void deleteSpace(int id,BuildContext context) {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: const Text('도형 삭제'),
            content: const Text('이 도형을 삭제할까요?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context),
                  child: const Text('취소')),
              TextButton(
                onPressed: () {
                  spaces.removeWhere((s) => s.num == id);
                  if (selectedSpaceId == id) selectedSpaceId = null;
                  spaceIdCounter--;
                  notifyListeners();
                },
                child: const Text(
                    '삭제', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void updateSpacePosition(int id, DragUpdateDetails details) {
    final shape = spaces.firstWhere((s) => s.num == id);
    final scale = _transformationController.value.getMaxScaleOnAxis();

    shape.x += details.delta.dx / scale;
    shape.y += details.delta.dy / scale;
    notifyListeners();
  }

  void snapSpaceToGrid(int id) {
    final shape = spaces.firstWhere((s) => s.num == id);
    shape.x = (shape.x / gridSize).round() * gridSize;
    shape.y = (shape.y / gridSize).round() * gridSize;
    notifyListeners();
  }

  void rotateSpace(int id) {
    final shape = spaces.firstWhere((s) => s.num == id);
    shape.angle += pi / 16;
    notifyListeners();
  }

  void selectSpace(int id) {
    selectedSpaceId = id;
    scroll = false;
    notifyListeners();
  }

  void scrollStop() {
    scroll = false;
    notifyListeners();
  }

  void scrollStart() {
    scroll = true;
    notifyListeners();
  }

  void onBackgroundTap(){
    selectedSpaceId = null;
    scroll = true;
    notifyListeners();
  }

}

class TransformedData {
  final List<Line> shiftedLines;
  final Set<Offset> shiftedDoors;
  final double width;
  final double height;

  TransformedData({
    required this.shiftedLines,
    required this.shiftedDoors,
    required this.width,
    required this.height,
  });
}