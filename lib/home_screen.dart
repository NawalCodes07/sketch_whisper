import 'package:drawing_game/create_room_screen.dart';
import 'package:drawing_game/join_room_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Create or join a group to play!", style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          )),
          SizedBox(height: MediaQuery.of(context).size.height*0.1,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateRoomScreen()));
                },
                child: const Text("Create", style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[300],
                  minimumSize: Size(MediaQuery.of(context).size.width/2.5, 50),
                )
              ),
              ElevatedButton(onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const JoinRoomScreen()));
                }, 
                child: const Text("Join", style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[300],
                  minimumSize: Size(MediaQuery.of(context).size.width/2.5, 50),
                )
              ),
            ],
          )
        ],
      )
    );
  }
}