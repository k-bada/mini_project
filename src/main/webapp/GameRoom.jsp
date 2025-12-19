<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Game Room</title>
</head>
<body>

<h2>게임방</h2>
<p>roomId = <%= request.getParameter("roomId") %></p>

<button onclick="leaveRoom()">나가기</button>

<script>
const roomId = "<%= request.getParameter("roomId") %>";

const socket = new WebSocket(
    (location.protocol === "https:" ? "wss://" : "ws://") +
    location.host +
    "/mini_project/room"
);

socket.onopen = () => {
    console.log("GameRoom WebSocket connected");
};

function leaveRoom() {
    socket.send(JSON.stringify({
        type: "LEAVE_ROOM",
        roomId: roomId
    }));

    // 약간의 여유 후 이동 (전송 보장)
    setTimeout(() => {
        location.href = "RoomList.jsp";
    }, 100);
}
</script>




</body>
</html>
