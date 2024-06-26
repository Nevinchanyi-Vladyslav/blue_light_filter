import 'package:blue_light_filter/filter/data/entities/profile_entity.dart';
import 'package:blue_light_filter/filter/presentation/pages/filter/cubits/current_profile/current_profile_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/color_intencity/color_intencity_cubit.dart';
import '../cubits/color_temperature/color_temperature_cubit.dart';
import '../cubits/profiles_list/profiles_list_cubit.dart';
import '../cubits/screen_dim/screen_dim_cubit.dart';

class ProfilesList extends StatefulWidget {
  const ProfilesList({super.key, this.dimension = 80});

  final double dimension;

  @override
  State<ProfilesList> createState() => _ProfilesListState();
}

class _ProfilesListState extends State<ProfilesList> {
  static const int _itemPerScreen = 9;

  void _showDeleteConfirmationDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('delete_profile'.tr()),
          content: Text('delete_profile_message'.tr()),
          actions: [
            TextButton(
              child: Text('no'.tr()),
              onPressed: () {
                _profileNameFieldController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('yes'.tr()),
              onPressed: () {
                _profileNameFieldController.clear();
                context
                    .read<ProfilesListCubit>()
                    .deleteProfile(id)
                    .then((value) => Navigator.of(context).pop());
              },
            ),
          ],
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _profileNameFieldController =
      TextEditingController();

  void _showAddProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('add_profile'.tr()),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _profileNameFieldController,
              decoration: InputDecoration(
                labelText: 'profile_name'.tr(),
              ),
              validator: (value) {
                if (value?.isEmpty == true) {
                  return 'please_enter_profile_name'.tr();
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('no'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('yes'.tr()),
              onPressed: () async {
                if (_formKey.currentState?.validate() == true) {
                  // Perform the desired action with the profile name
                  final name = _profileNameFieldController.text.trim();
                  final int colorTemperature =
                      context.read<ColorTemperatureCubit>().state.temperature;
                  final int colorIntensity =
                      context.read<ColorIntencityCubit>().state.intencity;
                  final int screenDim =
                      context.read<ScreenDimCubit>().state.dim;
                  context
                      .read<ProfilesListCubit>()
                      .addProfile(ProfileEntity.create(
                        name: name,
                        colorTemperature: colorTemperature,
                        colorIntensity: colorIntensity,
                        screenDim: screenDim,
                      ))
                      .then((value) {
                    Navigator.of(context).pop();
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _onProfileSelected(ProfileEntity profileEntity) {
    context.read<CurrentProfileCubit>().updateProfile(profileEntity);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'profiles'.tr(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Expanded(
              child: Text(
                'saved_profile_settings'.tr(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        SizedBox(
          height: widget.dimension,
          child: BlocBuilder<ProfilesListCubit, ProfilesListState>(
            builder: (context, state) {
              if (state is ProfilesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ProfilesLoaded) {
                final profiles = state.profiles;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: profiles.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        width:
                            MediaQuery.of(context).size.width / _itemPerScreen,
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showAddProfileDialog(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      size: 32,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'add'.tr(),
                                style: Theme.of(context).textTheme.labelSmall,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Need to subtract 1 because of the add profile button
                      index--;
                      return Container(
                        width:
                            MediaQuery.of(context).size.width / _itemPerScreen,
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        width: 2,
                                      ),
                                    ),
                                    child: ProfileAvatar(
                                      title: profiles[index].name,
                                    ),
                                  ),
                                  onTap: () => _onProfileSelected(
                                    profiles[index],
                                  ),
                                ),
                                Positioned(
                                  bottom: 28,
                                  left: 28,
                                  child: GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                      child: const Icon(
                                        Icons.cancel_rounded,
                                        size: 16,
                                      ),
                                    ),
                                    onTap: () => _showDeleteConfirmationDialog(
                                      context,
                                      profiles[index].id,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Text(
                                profiles[index].name,
                                style: Theme.of(context).textTheme.labelSmall,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                );
              } else {
                return Center(
                  child: Text('error_loading_profiles'.tr()),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _profileNameFieldController.dispose();
    super.dispose();
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Center(
        child: Text(
          title.substring(0, 1),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
