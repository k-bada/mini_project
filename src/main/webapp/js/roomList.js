// js/room.js
const socket = new WebSocket("ws://localhost:8080/mini_project/room");

socket.onmessage = e => {
    renderRooms(JSON.parse(e.data));
};

function renderRooms(rooms) {
    const list = document.getElementById("roomList");
    list.innerHTML = "";

    rooms.forEach(r => {
        const count =
            (r.blackUser ? 1 : 0) + (r.whiteUser ? 1 : 0);

        const div = document.createElement("div");
        div.className = "room-card";

        div.innerHTML = `
            <div># ${r.title}</div>
            <div>${r.blackUser?.nickname || ""}
                 ${r.whiteUser ? "vs " + r.whiteUser.nickname : "대기중"}
            </div>
            <button ${count === 2 ? "disabled" : ""}
                onclick="joinRoom('${r.roomId}')">
                ${count === 2 ? "FULL" : "JOIN"}
            </button>
        `;

        list.appendChild(div);
    });
}

function joinRoom(roomId) {
    socket.send(JSON.stringify({
        type: "JOIN_ROOM",
        roomId: roomId
    }));
    location.href = "GameRoom.jsp?roomId=" + roomId;
}
