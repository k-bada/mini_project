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
            overflow: hidden;
        }
        
        .popup-container {
        	width: 700px;
    		height: 500px;
    		
		    display: flex;
		    flex-direction: column; 
		    align-items: center;
		    justify-content: center;
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
            margin-bottom: 30px; 
            
        }

        .radio-box input[type="radio"]{
            display: none;
        }

        .radio-wrap {
            display: flex;
            gap: 70px;
            margin: 10px;
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
            cursor: pointer;
        }

    </style>
    
    <script>
	window.onload = () => {
	    const TARGET_WIDTH = 1000;
	    const TARGET_HEIGHT = 700;
	
	    // 🔥 현재 창 크기와 실제 컨텐츠 크기의 차이 계산
	    const widthDiff  = window.outerWidth  - window.innerWidth;
	    const heightDiff = window.outerHeight - window.innerHeight;
	
	    // 🔥 진짜 원하는 크기로 강제 리사이즈
	    window.resizeTo(
	        TARGET_WIDTH + widthDiff,
	        TARGET_HEIGHT + heightDiff
	    );
	
	    // 중앙 정렬
	    window.moveTo(
	        (screen.width  - (TARGET_WIDTH + widthDiff))  / 2,
	        (screen.height - (TARGET_HEIGHT + heightDiff)) / 2
	    );
	};
	</script>
    
    
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
    (location.protocol === "https:" ? "wss://" : "ws://") +
    location.host +
    "/mini_project/room"
);

socket.onopen = () => {
    console.log("✅ Popup WebSocket connected");
};

socket.onmessage = e => {
    const data = JSON.parse(e.data);

    if (data.type === "ROOM_CREATED") {
        // 👉 방 만들자마자 게임룸 입장
        window.opener.location.href =
            "/mini_project/GameRoom.jsp?roomId=" + data.roomId;

        window.close();
    }
};

function createRoom() {
    const title = document.getElementById("title").value.trim();
    const mode = document.querySelector("input[name=mode]:checked").value;

    if (!title) {
        alert("방 제목을 입력하세요");
        return;
    }

    // ⚠️ 이 조건은 거의 안 걸림 (예외 방어용)
    if (socket.readyState !== WebSocket.OPEN) {
        console.warn("WebSocket not ready yet");
        return;
    }

    socket.send(JSON.stringify({
        type: "CREATE_ROOM",
        title: title,
        mode: mode
    }));
}
</script>





    
</body>
</html>