import 'package:drawing_game/paint_screen.dart';
import 'package:drawing_game/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();
  late String? _maxRoundValue = null;
  late String? _roomSizeValue = null;

   void  createRoom(){
    if(_nameController.text.isNotEmpty && _roomNameController.text.isNotEmpty && _maxRoundValue != null && _roomSizeValue != null){
      print("navigating to paint screen");
      Map<String, String> data = {
        "nickname": _nameController.text,
        "name": _roomNameController.text,
        "occupancy": _roomSizeValue!,
        "maxRounds": _maxRoundValue!
      };
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PaintScreen(data: data, screenFrom: 'createRoom')));
    }
    print("out of if block");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Create Room",
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
            )),
        SizedBox(height: MediaQuery.of(context).size.height * 0.08),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomTextField(
            controller: _nameController,
            hintText: "Enter your Name",
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomTextField(
            controller: _roomNameController,
            hintText: "Enter Room Name",
          ),
        ),
        SizedBox(height: 20),
        DropdownButton<String>(
            focusColor: Color(0xffF5F6FA),
            items: <String>[
              "2",
              "3",
              "4",
              "5"
            ].map<DropdownMenuItem<String>>((String value) => DropdownMenuItem(
                value: value,
                child: new Text(
                  value,
                  style: TextStyle(color: Colors.black),
                ))).toList(),
                hint: Text(_maxRoundValue!=null ? "Selected rounds: $_maxRoundValue" : "Select max rounds", style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
                onChanged: (String? value){
                  setState(() {
                    _maxRoundValue = value;
                  });
                }
          ),
          SizedBox(height: 20,),
          DropdownButton<String>(
            focusColor: Color(0xffF5F6FA),
            items: <String>[
              "2",
              "3",
              "4",
              "5",
              "6",
              "7",
              "8",
              "9",
              "10"
            ].map<DropdownMenuItem<String>>((String value) => DropdownMenuItem(
                value: value,
                child: new Text(
                  value,
                  style: TextStyle(color: Colors.black),
                ))).toList(),
                hint: Text(_roomSizeValue!=null ? "Selected room size: $_roomSizeValue" : "Select room size", style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
                onChanged: (String? value){
                  setState(() {
                    _roomSizeValue = value;
                  });
                }
          ),
          SizedBox(height: 40,),
          ElevatedButton(onPressed: createRoom, 
            child: Text("Create", style: TextStyle(color: Colors.black, fontSize: 16)),
            style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[300],
                  minimumSize: Size(MediaQuery.of(context).size.width/2.5, 50),
                )
          )
      ],
    ));
  }
}
