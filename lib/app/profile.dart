import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_livechat_app/common_widget/platform_responsive_alert_dialog.dart';
import 'package:flutter_livechat_app/viewmodel/user_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _controllerUserName;
  File? _profilePhoto;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controllerUserName = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

  void _addProfilePhoto(ImageSource source) async{
    XFile? _pickedPhoto = await _picker.pickImage(source: source);
    setState(() {
      if(_pickedPhoto != null){
        _profilePhoto = File(_pickedPhoto.path);
      }
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    _controllerUserName.text = _userViewModel.user!.userName!;
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).secondaryHeaderColor,
          actions: [
            ElevatedButton(
              onPressed: () => _logOutRequest(context),
              child: Text(
                'Log Out',
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.camera_alt),
                                  title: Text('Camera'),
                                  onTap: () {
                                    _addProfilePhoto(ImageSource.camera);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.image),
                                  title: Text('Gallery'),
                                  onTap: () {
                                    _addProfilePhoto(ImageSource.gallery);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 75,
                      backgroundImage: _profilePhoto == null
                          ? NetworkImage(_userViewModel.user!.profileURL!)
                          : FileImage(_profilePhoto!),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: _userViewModel.user!.email,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: 'Email', border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _controllerUserName,
                    decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'Username',
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        _updateUserName(context);
                        _updateProfilePhoto(context);
                      },
                      child: Text('Save Changes')),
                )
              ],
            ),
          ),
        ));
  }

  Future<bool> _logOut(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    bool result = await _userViewModel.signOut();
    return result;
  }

  Future _logOutRequest(BuildContext context) async {
    final result = await PlatformResponsiveAlertDialog(
      title: 'Exit',
      content: 'Are you sure you want to log out?',
      buttonString: 'Yes',
      cancelButtonString: 'No',
    ).show(context);

    if (result == true) {
      _logOut(context);
    }
  }

  void _updateUserName(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    if (_userViewModel.user!.userName != _controllerUserName.text) {
      var updateResult = await _userViewModel.updateUserName(
          _userViewModel.user!.userID, _controllerUserName.text);
      if (updateResult == true) {
        _userViewModel.user!.userName = _controllerUserName.text;
        PlatformResponsiveAlertDialog(
                title: 'Success',
                content: 'Username Changed',
                buttonString: 'Okey')
            .show(context);
      } else {
        _controllerUserName.text = _userViewModel.user!.userName!;
        PlatformResponsiveAlertDialog(
                title: 'Error',
                content:
                    'This username is used by someone else, try another username',
                buttonString: 'Okey')
            .show(context);
      }
    } 
  }
  
  void _updateProfilePhoto(BuildContext context) async{
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    if(_profilePhoto != null) {
      var url = await _userViewModel.uploadFile(_userViewModel.user!.userID, 'profile_photo', _profilePhoto!);
      print('Profile Photo URL : $url');

      if(url.isNotEmpty) {
        PlatformResponsiveAlertDialog(
                title: 'Succes',
                content:
                    'Profile Photo Updated',
                buttonString: 'Okey')
            .show(context);
      }
    }
  }
}
