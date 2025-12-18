<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>방 만들기</title>

    <style>
    	html, body {
		    width: 100%;
		    height: 100%;
		    margin: 0;
		}
    
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        
        .popup-container {
		    display: flex;
		    flex-direction: column; 
		    align-items: center;
		    gap: 30px;
		}

        h1 {
            font-size: 36px;
            font-weight: 800;
            align-self: flex-start;
            padding-left: 50px;
        }

        #addTitle {
            display: flex;
            flex-direction: column;
            width: 580px;
            height: 240px;
            border: 6px solid #D4D4D4;
            border-radius: 15px;
            align-items: center;
            justify-content: flex-start;
            gap: 10px;
        }

        #title {
            width: 430px;
            height: 50px;
            font-size: 24px;
            padding-left: 15px;
            font-weight: 500;
            border: 6px solid #D4D4D4;
            border-radius: 15px;
            
        }

        .radio-box input[type="radio"]{
            display: none;
        }

        .radio-wrap {
            display: flex;
            gap: 70px;
            margin: 20px;
        }

        .radio-box {
            cursor: pointer;
            line-height: 110px;
        }

        .radio-box input:checked + .text-stroke {
            color: white;
            -webkit-text-stroke: 4px #7F7F7F;
            border: 5px dashed #F0B061;

        }

        .text-stroke {
            color: white;
            text-align: center;
            font-size: 64px;
            font-weight: 800;
            -webkit-text-stroke: 4px #DCDCDC;
            width: 200px;
            height: 120px;
            background-color: #f5f5f5;
            border-radius: 15px;
            border: 4px dashed #85BE57;
        }

        #addBtn {
            width: 314px;
            height: 70px;
            border-radius: 15px;
            background-color: #85BE57;
            color: white;
            font-size: 35px;
            font-weight: 700;
            border: 0px;
            text-align: center;
            line-height: 70px;
        }

        form {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            width: 1000px;
            height: 700px;
            gap: 15px;
        }

    </style>
</head>

<body>
  <div class="popup-container">
    <div id="addTitle">
        <h1>방제</h1>
        <input type="text" id="title" placeholder="방 제목">
    </div>

    <div class="radio-wrap">
    	<!-- 30s -->
        <label class="radio-box">
          <input type="radio" name="mode" value="30s" checked>
          <div class="text-stroke">30s</div>
        </label>

    	<!-- 60s -->
        <label class="radio-box">
          <input type="radio" name="mode" value="60s">
          <div class="text-stroke">60s</div>
        </label>
    </div>

	<button type="button" id="addBtn" onclick="createRoom()">방 만들기</button>
    
   </div>
    
          
<script>
const socket = new WebSocket(
    (location.protocol === "https:" ? "wss://" : "ws://")
    + location.host
    + "/mini_project/room"
);

socket.onmessage = e => {
    const data = JSON.parse(e.data);

    if (data.type === "ROOM_CREATED") {
        window.opener.location.href =
            "/mini_project/GameRoom.jsp?roomId=" + data.roomId;
        window.close();
    }

};

function createRoom() {
    socket.send(JSON.stringify({
        type: "CREATE_ROOM",
        title: document.getElementById("title").value,
        mode: document.querySelector("input[name=mode]:checked").value
    }));
}
</script>



    
</body>
</html>