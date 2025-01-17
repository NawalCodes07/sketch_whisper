const express = require("express");
var http = require("http")
const app = express();
const port = process.env.PORT || 3000
var server = http.createServer(app);
const mongoose = require("mongoose");
const Room = require("./models/Room");
const getWord = require("./api/getWord");

//var io = require("socket.io")(server)  this is same as below
var socket = require("socket.io")
var io = socket(server);

//middleware
app.use(express.json());

//connect to database
const DB = 'mongodb+srv://rishi:Vssakrj12%23@cluster0.pjjuj5x.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0';

const DB1 = 'mongodb+srv://rushilsethi076:ZOp3m5Z9RgAYBHJ3@cluster0.sh1bs13.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0';

mongoose.connect(DB1).then(()=>{
    console.log("Connection successful");
}).catch((error)=>{
    console.log(error);
})


io.on('connection', (socket)=>{
    console.log("connected");

    //CREATE GAME CALLBACK
    socket.on('create-game', async({nickname, name, occupancy, maxRounds})=>{
        console.log("creating room program");
        try{
            const existingRoom = await Room.findOne({name});
            if(existingRoom){
                socket.emit('notCorrectGame', "Room with that name already exists!");
                return;
            }
            let room = new Room();
            const word = getWord();
            room.word = word;
            room.name = name;
            room.occupancy = occupancy;
            room.maxRounds = maxRounds;

            let player = {
                socketID: socket.id,
                nickname,
                isPartyLeader: true,
            }
            room.players.push(player);
            room = await room.save();
            socket.join(name);
            io.to(name).emit('updateRoom', room);
        }catch(error){
            console.log(error);
        }
    });

    //JOIN GAME CALLBACK
    socket.on('join-game', async({nickname, name }) => {
        console.log("joining player program");
        try {
            let room = await Room.findOne({name});
            if(!room){
                socket.emit('notCorrectGame','Please enter a vaild room name');
                return; 
            }
             console.log(room.isJoin);
            if(room.isJoin){
                let player = {
                    socketID: socket.id,
                    nickname,
                }
                room.players.push(player);
                socket.join(name);
                if(room.players.length == room.occupancy){
                    room.isJoin = false;
                }
                room.turn = room.players[room.turnIndex];
                room = await room.save();
                io.to(name).emit('updateRoom', room);
            }else{
                socket.emit('notCorrectGame','The game is in progress, please try later!');
            }

        }catch(error){
            console.log(error);
        }
    })
    
    socket.on('msg', async(data) => {
        try{
            if(data.message === data.word){
                console.log("entered if block");
                let room = await Room.find({name: data.roomName});
                console.log("room vairable initialised");
                let userPlayer = room[0].players.filter(
                    (player)=>player.nickname === data.username
                )
                if(data.timeTaken !== 0){
                    userPlayer[0].points += Math.round((200/data.timeTaken)*10);
                }
                room = await room[0].save();
                io.to(data.roomName).emit('msg',{
                    username: data.username,
                    msg: 'Guessed it!',
                    guessedUserCtr: data.guessedUserCtr + 1,
                })
                socket.emit('closeInput', "");
            }else{
                io.to(data.roomName).emit('msg', {
                    username: data.username,
                    msg: data.message,
                    guessedUserCtr: data.guessedUserCtr,
                });
            }
        }catch(error){
            console.log(error.toString());
        }
    })

    socket.on('change-turn', async(name) => {
        try{
            let room = await Room.findOne({name});
            let idx = room.turnIndex;
            if(room.turnIndex + 1 == room.players.length){
                room.currentRound+=1; 
            }
            if(room.currentRound <= room.maxRounds){
                const word = getWord();
                room.word = word; 
                room.turnIndex = (idx + 1) % room.players.length;
                room.turn = room.players[room.turnIndex];
                room = await room.save();
                io.to(name).emit('change-turn', room);
            }else{
                //show the leaderboard
                io.to(name).emit("show-leaderboard", room.players);
            }
        }catch(error){
            console.log(error);
        }
    } )


    socket.on('updateScore', async(name) => {
        try{
            const room = await Room.findOne({name});
            io.to(name).emit('updateScore', room);
        }catch(error){
            console.log(error);
        }
    }) 

    //white board sockets
    socket.on('paint',({details, roomName})=>{
        io.to(roomName).emit('points',{details: details});
    })

    //color scokets
    socket.on('color-change',({color, roomName}) => {
        io.to(roomName).emit('color-change',color);
    })


    //stroke socket
    socket.on('stroke-width', ({value, roomName})=>{
        io.to(roomName).emit('stroke-width', value);
    })

    //clear screen
    socket.on('clean-screen', (roomName)=>{
        io.to(roomName).emit('clear-screen', '');
    })


    socket.on('disconnect', async() =>{
        try{
            let room = await Room.findOne({"players.socketID": socket.id});
            for(let i=0; i < room.players.length; i++){
                if(room.players[i].socketID === socket.id){
                    room.players.splice(i, 1);
                    break;
                }
            }
            room = await room.save();
            if(room.players.length === 1){
                socket.broadcast.to(room.name).emit('show-leaderboard', room.players);
            }else{
                socket.broadcast.to(room.name).emit('user-disconnected', room);
            }
        }catch(error){
            console.log(error);
        }
    })
})


server.listen(port, "0.0.0.0",()=>{
    console.log("server started and running on port "+port)
})

