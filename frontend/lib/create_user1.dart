import 'package:flutter/material.dart';
import 'create_user2.dart';


void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key});


  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      title: "Profile",
      home: ProfileViewScreen(),
    );
  }
}



class ProfileViewScreen extends StatefulWidget {

  const ProfileViewScreen({Key? key});

  @override
  ProfileViewScreenState createState() => ProfileViewScreenState();
}

class ProfileViewScreenState extends State<ProfileViewScreen>{

  List<Profile> profiles = [];

  void addProfile(Profile profile){
    setState(() {
      profiles.add(profile);
    });

  }

  void deleteProfile(int index){
    setState(() {
      profiles.removeAt(index);
    });
  }



  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 리스트'),
      ),
      body: profiles.isEmpty ? Center(
        child:

        Text('프로필을 생성하세요'),
      ) : ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, index){
          return ListTile(
              title: Text(profiles[index].name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async{
                      final updatedProfile = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>
                            ProfileEditScreen(profile: profiles[index])),);


                      if(updatedProfile != null) {
                        setState(() {
                          profiles[index] = updatedProfile;
                        });
                      }
                    },),
                  IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteProfile(index)
                  )
                ],
              )
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> const ProfileEditScreen()),
          );

          if(result != null){
            setState(() {
              profiles.add(result);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

}

class Profile{
  String name;
  String email;
  String password='';
  String confirm_password = '';
  String account;

  Profile({required this.name, required this.email, required this.password, required this.account, required this.confirm_password});



}