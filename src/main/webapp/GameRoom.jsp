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
    (location.protocol === "https:" ? "wss://" : "ws://")
    + location.host
    + "/mini_project/room"
);

socket.onopen = () => {
    socket.send(JSON.stringify({
        type: "JOIN_ROOM",
        roomId: roomId
    }));
};

function leaveRoom() {
    socket.send(JSON.stringify({
        type: "LEAVE_ROOM",
        roomId: roomId
    }));
    location.href = "RoomList.jsp";
}
</script>


</body>
</html>
