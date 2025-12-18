// socket은 파일 최상단, 단 1번
const socket = new WebSocket(
	(location.protocol === "https:" ? "wss://" : "ws://")
	+ location.host
	+ "/mini_project/room"
);

socket.onopen = () => {
	console.log("RoomList WebSocket connected");
};

socket.onmessage = e => {
	const rooms = JSON.parse(e.data);
	renderRooms(rooms);
};


function searchRooms() {
	const keyword = document
		.getElementById("searchInput")
		.value.toLowerCase();

	document.querySelectorAll(".room-card").forEach(card => {
		const title = card
			.querySelector(".room-title")
			.innerText
			.toLowerCase();

		card.style.display = title.includes(keyword) ? "" : "none";
	});
};

function renderRooms(rooms) {
	const list = document.getElementById("roomList");
	list.innerHTML = "";

	 // ✅ 방이 없을 때
    if (rooms.length === 0) {
        emptyState.style.display = "block";
        list.style.display = "none";
        return;
    }

    // ✅ 방이 있을 때
    emptyState.style.display = "none";
    list.style.display = "grid";
	
	rooms.sort((a, b) => {
		const countA =
			(a.blackPlayer ? 1 : 0) + (a.whitePlayer ? 1 : 0);
		const countB =
			(b.blackPlayer ? 1 : 0) + (b.whitePlayer ? 1 : 0);

		const fullA = countA === 2;
		const fullB = countB === 2;

		return fullA - fullB; 
		// false(0) → true(1) : 안 찬 방이 앞
	});

	rooms.forEach(room => {
		const black = room.blackPlayer;
		const white = room.whitePlayer;

		const count =
			(black ? 1 : 0) +
			(white ? 1 : 0);

		const isFull = count === 2;

		const leftName = black ? black.nickname : "대기중";
		const rightName = white ? white.nickname : "대기중";
	
		const playersHtml = `
			<div class="player-line">
				${leftName} <span class="vs">vs</span> ${rightName}
			</div>
		`;
	
		const card = document.createElement("div");
		card.className = "room-card" + (isFull ? " orange" : "");

		card.onclick = () => {
			if (isFull) {
				alert("이미 꽉 찬 방입니다.");
				return;
			}

			socket.send(JSON.stringify({
				type: "JOIN_ROOM",
				roomId: room.roomId
			}));

			setTimeout(() => {
				location.href = "GameRoom.jsp?roomId=" + room.roomId;
			}, 50);
		};

		card.innerHTML = `
			<div class="room-title">${room.title}</div>
			<div class="room-info">
				<div class="player-list">
					${playersHtml}
				</div>
				<span class="time">${room.mode}</span>
			</div>
		`;

		list.appendChild(card);
	});
}