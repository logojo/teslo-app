import 'package:image_picker/image_picker.dart';
import 'camera_galery.dart';

class CameraGaleryServiceImpl extends CameraGaleryService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> selectPhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (image == null) return null;

    return image.path;
  }

  @override
  Future<String?> takePhoto() async {
    // Capturar a photo.
    final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        preferredCameraDevice: CameraDevice.rear);

    if (photo == null) return null;

    return photo.path;
  }
}
