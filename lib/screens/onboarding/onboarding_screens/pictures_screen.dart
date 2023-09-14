import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '/widgets/widgets.dart';
import '/screens/screens.dart';
import '/blocs/blocs.dart';
import '../widgets/widgets.dart';

class Pictures extends StatelessWidget {
  const Pictures({
    super.key,
    required this.state,
  });
  final OnboardingLoaded state;

  @override
  Widget build(BuildContext context) {
    var images = state.user.imageUrls;
    var imageCount = images.length;
    return OnboardingScreenLayout(
      currentStep: 4,
      onPressed: () {
        context
            .read<OnboardingBloc>()
            .add(ContinueOnboarding(user: state.user));
      },
      children: [
        const CustomTextHeader(text: 'Add 2 or More Pictures'),
        const SizedBox(height: 20),
        SizedBox(
          height: 350,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.66,
            ),
            itemCount: 6,
            itemBuilder: (BuildContext context, int index) {
              return (imageCount > index)
                  ? UserImage.medium(
                      url: images[index],
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).primaryColor,
                      ),
                      margin: const EdgeInsets.only(
                        bottom: 10.0,
                        right: 10.0,
                      ),
                    )
                  : AddUserImage(
                      onPressed: () async {
                        final XFile? image = await ImagePicker().pickImage(
                            source: ImageSource.gallery, imageQuality: 50);

                        if (image == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No image was selected.'),
                            ),
                          );
                        } else {
                          print('Uploading ...');
                          BlocProvider.of<OnboardingBloc>(context).add(
                            UpdateUserImages(image: image),
                          );
                        }
                      },
                    );
            },
          ),
        ),
      ],
    );
  }
}
