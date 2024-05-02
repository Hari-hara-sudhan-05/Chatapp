import 'package:flutter/Material.dart';
import 'package:image_picker/image_picker.dart';

class PickSource extends StatefulWidget {
  const PickSource({super.key, required this.onType});

  final void Function(ImageSource type) onType;

  @override
  State<PickSource> createState() {
    return _PickSource();
  }
}

class _PickSource extends State<PickSource> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 19),
            child: Text(
              'Profile Photo',
              style: TextStyle(
                  fontSize: 24, color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      widget.onType(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.camera,
                      size: 40,
                    ),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    'Camera ',
                    style: TextStyle(fontSize: 16,color: Theme.of(context).colorScheme.primary),
                  )
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      widget.onType(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.image,
                      size: 40,
                    ),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    'Gallery ',
                    style: TextStyle(fontSize: 16,color: Theme.of(context).colorScheme.primary),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
